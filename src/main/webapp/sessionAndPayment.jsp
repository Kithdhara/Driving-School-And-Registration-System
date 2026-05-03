<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.drivingschool.dao.*, com.drivingschool.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("STUDENT")) { response.sendRedirect("login.jsp"); return; }
    int userId = Integer.parseInt((String) session.getAttribute("userId"));
    Student student = new StudentDAO().getStudentByUserId(userId);
    request.setAttribute("student", student);
    if (student != null) {
        int sid = Integer.parseInt(student.getId());
        PaymentDAO paymentDAO = new PaymentDAO();
        Payment payment = paymentDAO.getPaymentByStudentId(sid);
        request.setAttribute("payment", payment);
        List<Payment> payments = paymentDAO.getPaymentsByStudentId(sid);
        request.setAttribute("payments", payments);
        List<Schedule> allSchedules = new ScheduleDAO().getSchedulesByStudent(sid);
        List<Schedule> upcoming = new java.util.ArrayList<>();
        List<Schedule> completed = new java.util.ArrayList<>();
        List<Schedule> cancelled = new java.util.ArrayList<>();
        int sessionsUsed = 0;
        
        for (Schedule sc : allSchedules) {
            if ("COMPLETED".equals(sc.getStatus())) {
                sessionsUsed++;
                completed.add(sc);
            } else if ("SCHEDULED".equals(sc.getStatus()) || "RESCHEDULE_REQ".equals(sc.getStatus())) {
                upcoming.add(sc);
            } else if ("CANCELLED".equals(sc.getStatus())) {
                cancelled.add(sc);
            }
        }
        
        int totalCredits = paymentDAO.getTotalSessionCredits(sid);
        int remainingSessions = totalCredits - sessionsUsed;
        request.setAttribute("remainingSessions", remainingSessions);
        request.setAttribute("sessionsUsed", sessionsUsed);
        request.setAttribute("totalCredits", totalCredits);
        boolean hasPendingPayment = (payment != null && "PENDING".equals(payment.getPaymentStatus()));
        boolean canPurchase = !hasPendingPayment && remainingSessions <= 0;
        request.setAttribute("canPurchase", canPurchase);
        request.setAttribute("hasPendingPayment", hasPendingPayment);
        request.setAttribute("totalPurchased", totalCredits);
        boolean hasConfirmedPayment = totalCredits > 0;
        request.setAttribute("hasConfirmedPayment", hasConfirmedPayment);
        
        request.setAttribute("upcoming", upcoming);
        request.setAttribute("completed", completed);
        request.setAttribute("cancelled", cancelled);
        request.setAttribute("cancelledSessions", cancelled.size());
        request.setAttribute("allSchedules", allSchedules);
    }
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Payments & Schedule | DrivePro Academy</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/premium.css">
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24; vertical-align: middle; }
        .bg-grid-pattern { background-image: linear-gradient(to right, rgba(15,23,42,0.03) 1px, transparent 1px), linear-gradient(to bottom, rgba(15,23,42,0.03) 1px, transparent 1px); background-size: 40px 40px; }
        .package-card { transition: all 0.3s ease; }
        .package-card:hover { transform: translateY(-4px); }
        .package-card.selected { border-color: #4f46e5 !important; box-shadow: 0 0 0 3px rgba(79,70,229,0.15); }
    </style>
</head>
<body class="bg-slate-50 text-slate-900 min-h-screen bg-grid-pattern selection:bg-indigo-500 selection:text-white">

    <header class="sticky top-0 z-50 bg-white/80 backdrop-blur-md border-b border-slate-200/60 shadow-sm transition-all">
        <div class="flex justify-between items-center h-16 px-6 lg:px-12 w-full max-w-7xl mx-auto">
            <div class="flex items-center gap-8">
                <div class="flex items-center gap-2 text-slate-900">
                    <div class="w-8 h-8 bg-slate-900 rounded-md flex items-center justify-center text-white shadow-sm">
                        <span class="material-symbols-outlined text-[18px]">directions_car</span>
                    </div>
                    <span class="text-lg font-bold tracking-tight">DrivePro</span>
                </div>
                <nav class="hidden md:flex items-center gap-6 h-16">
                    <a class="font-medium text-slate-500 hover:text-slate-900 h-full flex items-center px-1 text-sm transition-colors" href="studentDashboard.jsp">Dashboard</a>
                    <a class="font-semibold text-indigo-600 border-b-2 border-indigo-600 h-full flex items-center px-1 text-sm transition-colors" href="sessionAndPayment.jsp">Payments & Schedule</a>
                    <a class="font-medium text-slate-500 hover:text-slate-900 h-full flex items-center px-1 text-sm transition-colors" href="studentProfile.jsp">My Profile</a>
                    <a class="font-medium text-slate-500 hover:text-slate-900 h-full flex items-center px-1 text-sm transition-colors" href="addReview.jsp">Write Review</a>
                </nav>
            </div>
            <div class="flex items-center gap-4">
                <a href="studentProfile.jsp" class="h-8 w-8 rounded-full bg-indigo-600 relative cursor-pointer shadow-sm ring-2 ring-transparent hover:ring-indigo-200 transition-all block">
                    <div class="absolute inset-0 rounded-full flex items-center justify-center text-white text-xs font-bold">
                        ${not empty student.fullName ? student.fullName.substring(0,1).toUpperCase() : 'S'}
                    </div>
                    <img src="${pageContext.request.contextPath}/assets/images/profiles/${userId}.jpg?t=<%= System.currentTimeMillis() %>" onerror="this.style.opacity='0';" class="relative z-10 w-full h-full object-cover rounded-full transition-opacity duration-300">
                </a>
                <a href="javascript:void(0)" onclick="confirmLogout()" class="flex items-center gap-2 px-3 py-1.5 bg-slate-100 text-slate-700 font-semibold text-xs rounded-md hover:bg-slate-200 transition-colors btn-press">
                    Logout <span class="material-symbols-outlined text-[16px]">logout</span>
                </a>
            </div>
        </div>
    </header>

    <main class="max-w-6xl mx-auto px-6 lg:px-12 py-10 relative z-10">

        <!-- Remaining Sessions -->
        <c:if test="${hasConfirmedPayment}">
        <div class="mb-6 bg-white rounded-2xl p-5 shadow-premium border border-slate-200 flex items-center justify-between motion-pop motion-visible">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 rounded-lg bg-indigo-50 border border-indigo-100 flex items-center justify-center text-indigo-600"><span class="material-symbols-outlined text-[20px]">event_note</span></div>
                <div>
                    <p class="text-sm font-bold text-slate-900">Remaining Sessions: <span class="text-indigo-600">${remainingSessions}</span> / ${totalPurchased}</p>
                    <p class="text-xs text-slate-500">${sessionsUsed} sessions used <c:if test="${cancelledSessions > 0}">· ${cancelledSessions} cancelled</c:if></p>
                </div>
            </div>
            <c:if test="${remainingSessions == 0}">
            <span class="text-xs font-bold text-red-600 bg-red-50 border border-red-200 px-3 py-1.5 rounded-lg">All sessions used — purchase a new package below</span>
            </c:if>
        </div>
        </c:if>

        <!-- Master Schedule Display -->
        <c:if test="${!canPurchase}">
        <div class="mb-10 motion-pop motion-visible">
            <h2 class="text-xl font-bold text-slate-900 tracking-tight mb-6">Your Lesson Schedule</h2>
            
            <c:if test="${empty allSchedules}">
                <div class="bg-white rounded-2xl p-10 border border-slate-200 text-center flex flex-col items-center justify-center shadow-premium">
                    <div class="w-16 h-16 bg-slate-50 text-slate-400 rounded-full flex items-center justify-center mb-4 border border-slate-100">
                        <span class="material-symbols-outlined text-3xl">calendar_month</span>
                    </div>
                    <h3 class="text-base font-bold text-slate-900 mb-1">No Schedule Yet</h3>
                    <p class="text-slate-500 text-sm">Once your payment is approved, your assigned instructor will start scheduling your lessons.</p>
                </div>
            </c:if>

            <c:if test="${not empty allSchedules}">
                <div class="grid grid-cols-1 gap-4">
                    <!-- Upcoming -->
                    <c:forEach items="${upcoming}" var="sc">
                        <div class="bg-white rounded-xl p-5 border-l-4 border-l-indigo-600 border border-slate-200 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4 group hover:shadow-md transition-shadow">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-12 rounded-full bg-indigo-50 flex items-center justify-center text-indigo-600 border border-indigo-100">
                                    <span class="material-symbols-outlined text-[24px]">event</span>
                                </div>
                                <div>
                                    <h4 class="text-sm font-bold text-slate-900 mb-0.5">Upcoming Lesson</h4>
                                    <div class="flex items-center gap-3 text-xs text-slate-500 font-medium">
                                        <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">calendar_today</span> ${sc.sessionDate}</span>
                                        <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">schedule</span> ${sc.sessionTime}</span>
                                        <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">person</span> Inst. ${sc.instructorName}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="bg-indigo-50 text-indigo-700 px-3 py-1 rounded-md text-[11px] font-bold tracking-wider uppercase border border-indigo-100">
                                Scheduled
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Completed -->
                    <c:forEach items="${completed}" var="sc">
                        <div class="bg-white rounded-xl p-5 border-l-4 border-l-emerald-500 border border-slate-200 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4 opacity-75">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-12 rounded-full bg-slate-100 flex items-center justify-center text-slate-500">
                                    <span class="material-symbols-outlined text-[24px]">task_alt</span>
                                </div>
                                <div>
                                    <h4 class="text-sm font-bold text-slate-900 mb-0.5"><span class="line-through">Lesson Completed</span></h4>
                                    <div class="flex items-center gap-3 text-xs text-slate-500 font-medium">
                                        <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">event</span> ${sc.sessionDate}</span>
                                        <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">schedule</span> ${sc.sessionTime}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="bg-emerald-50 text-emerald-700 px-3 py-1 rounded-md text-[11px] font-bold tracking-wider uppercase border border-emerald-100">
                                Completed
                            </div>
                        </div>
                    </c:forEach>
                    
                    <!-- Cancelled -->
                    <c:forEach items="${cancelled}" var="sc">
                        <div class="bg-red-50 rounded-xl p-5 border-l-4 border-l-red-500 border border-red-200 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-12 rounded-full bg-white/60 flex items-center justify-center text-red-500">
                                    <span class="material-symbols-outlined text-[24px]">event_busy</span>
                                </div>
                                <div>
                                    <h4 class="text-sm font-bold text-red-900 mb-0.5">Lesson Cancelled</h4>
                                    <div class="flex items-center gap-3 text-xs text-red-700 font-medium">
                                        <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">event</span> ${sc.sessionDate}</span>
                                        <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">schedule</span> ${sc.sessionTime}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="bg-white text-red-600 px-3 py-1 rounded-md text-[11px] font-bold tracking-wider uppercase border border-red-200 shadow-sm">
                                Cancelled
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
        </c:if>

        <!-- Pending Payment Notice -->
        <c:if test="${hasPendingPayment}">
        <div class="mb-8 bg-amber-50 border border-amber-200 rounded-2xl p-6 flex items-start gap-4 motion-pop motion-visible">
            <div class="w-10 h-10 rounded-lg bg-amber-100 border border-amber-200 flex items-center justify-center text-amber-600 shrink-0"><span class="material-symbols-outlined text-[20px]">hourglass_empty</span></div>
            <div>
                <h3 class="text-sm font-bold text-amber-900">Payment Under Review</h3>
                <p class="text-xs text-amber-700 mt-1">Your <span class="font-bold">${payment.packageType} Package</span> payment of <span class="font-bold">Rs. <fmt:formatNumber value="${payment.amount}" pattern="#,##0"/></span> is currently being reviewed by admin. This usually takes 1–2 business days.</p>
            </div>
        </div>
        </c:if>

        <!-- Student Resources & Timeline (Shown when user has an active or pending package) -->
        <c:if test="${!canPurchase}">
        


        <div class="mb-10 motion-pop motion-visible">
            <h2 class="text-xl font-bold text-slate-900 tracking-tight mb-6">Student Resources Hub</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Theory Material -->
                <a href="#" class="bg-white rounded-2xl p-6 border border-slate-200 shadow-premium hover:border-indigo-300 hover:shadow-lg transition-all group interactive-card flex flex-col h-full">
                    <div class="w-12 h-12 rounded-xl bg-indigo-50 flex items-center justify-center text-indigo-600 mb-4 group-hover:scale-110 transition-transform">
                        <span class="material-symbols-outlined text-[24px]">menu_book</span>
                    </div>
                    <h3 class="text-base font-bold text-slate-900 mb-2">RMV Theory Guide</h3>
                    <p class="text-xs text-slate-500 leading-relaxed flex-grow">Download the official handbook covering road rules and regulations for your written exam.</p>
                    <div class="mt-4 flex items-center gap-1.5 text-xs font-bold text-indigo-600">
                        Download PDF <span class="material-symbols-outlined text-[14px]">download</span>
                    </div>
                </a>

                <!-- Traffic Signs -->
                <a href="#" class="bg-white rounded-2xl p-6 border border-slate-200 shadow-premium hover:border-emerald-300 hover:shadow-lg transition-all group interactive-card flex flex-col h-full">
                    <div class="w-12 h-12 rounded-xl bg-emerald-50 flex items-center justify-center text-emerald-600 mb-4 group-hover:scale-110 transition-transform">
                        <span class="material-symbols-outlined text-[24px]">traffic</span>
                    </div>
                    <h3 class="text-base font-bold text-slate-900 mb-2">Traffic Signs Mastery</h3>
                    <p class="text-xs text-slate-500 leading-relaxed flex-grow">Interactive flashcards and full cheatsheet of all local road signs and markings.</p>
                    <div class="mt-4 flex items-center gap-1.5 text-xs font-bold text-emerald-600">
                        View Flashcards <span class="material-symbols-outlined text-[14px]">arrow_forward</span>
                    </div>
                </a>

                <!-- Support -->
                <a href="#" class="bg-slate-900 rounded-2xl p-6 border border-slate-800 shadow-premium hover:bg-slate-800 transition-all group interactive-card flex flex-col h-full text-white relative overflow-hidden">
                    <div class="absolute inset-0 bg-grid-pattern opacity-10"></div>
                    <div class="relative z-10 flex flex-col h-full">
                        <div class="w-12 h-12 rounded-xl bg-white/10 flex items-center justify-center text-white mb-4 group-hover:scale-110 transition-transform border border-white/20">
                            <span class="material-symbols-outlined text-[24px]">support_agent</span>
                        </div>
                        <h3 class="text-base font-bold mb-2">Need Assistance?</h3>
                        <p class="text-xs text-slate-400 leading-relaxed flex-grow">Have questions about your schedule or payment? Our admin team is here to help.</p>
                        <div class="mt-4 flex items-center gap-1.5 text-xs font-bold text-indigo-400">
                            Contact Admin <span class="material-symbols-outlined text-[14px]">chat</span>
                        </div>
                    </div>
                </a>
            </div>
        </div>
        </c:if>

        <c:if test="${canPurchase}">
        <div class="mb-8 motion-pop motion-visible">
            <h1 class="text-2xl font-bold text-slate-900 tracking-tight mb-1">Our Driving Packages</h1>
            <p class="text-slate-500 text-sm">Choose the training package that best fits your needs and schedule.</p>
        </div>

        <!-- Package Cards -->
        <form action="PaymentServlet" method="POST" id="paymentForm">
        <input type="hidden" name="action" value="submit">
        <input type="hidden" name="package_type" id="selectedPackage" value="INDIVIDUAL">

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10 motion-container">

            <!-- Individual Package -->
            <div class="package-card bg-white rounded-2xl border-2 border-slate-200 shadow-premium overflow-hidden cursor-pointer motion-item selected" onclick="selectPackage('INDIVIDUAL', this)">
                <div class="p-6">
                    <div class="flex items-center gap-2 mb-4">
                        <div class="w-10 h-10 rounded-lg bg-blue-50 border border-blue-100 flex items-center justify-center text-blue-600"><span class="material-symbols-outlined text-[22px]">person</span></div>
                        <div><h3 class="text-base font-bold text-slate-900">Individual</h3><p class="text-[10px] font-semibold text-slate-400 uppercase tracking-wider">Most Popular</p></div>
                    </div>
                    <div class="mb-4"><span class="text-3xl font-bold text-slate-900">Rs. 25,000</span></div>
                    <ul class="space-y-2.5 mb-6">
                        <li class="flex items-center gap-2 text-sm text-slate-600"><span class="material-symbols-outlined text-emerald-500 text-[16px]">check_circle</span><span><b>10</b> driving lessons (1hr each)</span></li>
                        <li class="flex items-center gap-2 text-sm text-slate-600"><span class="material-symbols-outlined text-emerald-500 text-[16px]">check_circle</span>Certified instructor 1-on-1</li>
                        <li class="flex items-center gap-2 text-sm text-slate-600"><span class="material-symbols-outlined text-emerald-500 text-[16px]">check_circle</span>City & residential training</li>
                        <li class="flex items-center gap-2 text-sm text-slate-600"><span class="material-symbols-outlined text-emerald-500 text-[16px]">check_circle</span>Parking & reversing practice</li>
                        <li class="flex items-center gap-2 text-sm text-slate-600"><span class="material-symbols-outlined text-emerald-500 text-[16px]">check_circle</span>Progress feedback per lesson</li>
                    </ul>
                    <div class="text-center py-2 rounded-lg bg-indigo-600 text-white text-xs font-bold uppercase tracking-wider select-label">Selected</div>
                </div>
            </div>

            <!-- VIP Package -->
            <div class="package-card bg-white rounded-2xl border-2 border-slate-200 shadow-premium overflow-hidden cursor-pointer motion-item relative" onclick="selectPackage('VIP', this)">
                <div class="absolute top-3 right-3 bg-amber-400 text-amber-900 text-[9px] font-black px-2 py-0.5 rounded-md uppercase tracking-wider shadow-sm">Premium</div>
                <div class="p-6">
                    <div class="flex items-center gap-2 mb-4">
                        <div class="w-10 h-10 rounded-lg bg-amber-50 border border-amber-100 flex items-center justify-center text-amber-600"><span class="material-symbols-outlined text-[22px]">star</span></div>
                        <div><h3 class="text-base font-bold text-slate-900">VIP Package</h3><p class="text-[10px] font-semibold text-slate-400 uppercase tracking-wider">Home Pickup & Drop</p></div>
                    </div>
                    <div class="mb-4"><span class="text-3xl font-bold text-slate-900">Rs. 35,000</span></div>
                    <ul class="space-y-2.5 mb-6">
                        <li class="flex items-center gap-2 text-sm text-slate-600"><span class="material-symbols-outlined text-emerald-500 text-[16px]">check_circle</span><span><b>10</b> driving lessons (1hr each)</span></li>
                        <li class="flex items-center gap-2 text-sm text-slate-600"><span class="material-symbols-outlined text-emerald-500 text-[16px]">check_circle</span><b>Home pickup & drop-off</b></li>
                        <li class="flex items-center gap-2 text-sm text-slate-600"><span class="material-symbols-outlined text-emerald-500 text-[16px]">check_circle</span>Certified instructor 1-on-1</li>
                        <li class="flex items-center gap-2 text-sm text-slate-600"><span class="material-symbols-outlined text-emerald-500 text-[16px]">check_circle</span>All road environments</li>
                        <li class="flex items-center gap-2 text-sm text-slate-600"><span class="material-symbols-outlined text-emerald-500 text-[16px]">check_circle</span>Priority scheduling</li>
                    </ul>
                    <div class="text-center py-2 rounded-lg bg-slate-100 text-slate-500 text-xs font-bold uppercase tracking-wider select-label">Select Plan</div>
                </div>
            </div>

            <!-- Refresher Package -->
            <div class="package-card bg-white rounded-2xl border-2 border-slate-200 shadow-premium overflow-hidden cursor-pointer motion-item" onclick="selectPackage('REFRESHER', this)">
                <div class="p-6">
                    <div class="flex items-center gap-2 mb-4">
                        <div class="w-10 h-10 rounded-lg bg-emerald-50 border border-emerald-100 flex items-center justify-center text-emerald-600"><span class="material-symbols-outlined text-[22px]">refresh</span></div>
                        <div><h3 class="text-base font-bold text-slate-900">Refresher</h3><p class="text-[10px] font-semibold text-slate-400 uppercase tracking-wider">Skill Renewal</p></div>
                    </div>
                    <div class="mb-4"><span class="text-3xl font-bold text-slate-900">Rs. 12,000</span></div>
                    <ul class="space-y-2.5 mb-6">
                        <li class="flex items-center gap-2 text-sm text-slate-600"><span class="material-symbols-outlined text-emerald-500 text-[16px]">check_circle</span><span><b>5</b> driving lessons (1hr each)</span></li>
                        <li class="flex items-center gap-2 text-sm text-slate-600"><span class="material-symbols-outlined text-emerald-500 text-[16px]">check_circle</span>Skill assessment & coaching</li>
                        <li class="flex items-center gap-2 text-sm text-slate-600"><span class="material-symbols-outlined text-emerald-500 text-[16px]">check_circle</span>Defensive driving techniques</li>
                        <li class="flex items-center gap-2 text-sm text-slate-600"><span class="material-symbols-outlined text-emerald-500 text-[16px]">check_circle</span>Already licensed? Perfect</li>
                        <li class="flex items-center gap-2 text-sm text-slate-600"><span class="material-symbols-outlined text-emerald-500 text-[16px]">check_circle</span>Flexible scheduling</li>
                    </ul>
                    <div class="text-center py-2 rounded-lg bg-slate-100 text-slate-500 text-xs font-bold uppercase tracking-wider select-label">Select Plan</div>
                </div>
            </div>
        </div>

        <!-- Schedule Preference & Payment Method -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8 motion-container">
            <div class="bg-white rounded-2xl p-6 shadow-premium border border-slate-200 motion-item">
                <div class="flex items-center gap-3 mb-5">
                    <div class="w-10 h-10 rounded-lg bg-indigo-50 flex items-center justify-center text-indigo-600 shadow-sm border border-indigo-100"><span class="material-symbols-outlined text-[20px]">calendar_month</span></div>
                    <h2 class="text-base font-bold text-slate-900">Schedule Preference</h2>
                </div>
                <div class="grid grid-cols-2 gap-3">
                    <label class="cursor-pointer"><input checked class="peer sr-only" name="session_type" type="radio" value="WEEKDAY"/>
                        <div class="p-4 rounded-xl border border-slate-200 peer-checked:border-indigo-600 peer-checked:bg-indigo-50/50 hover:bg-slate-50 transition-colors text-center">
                            <span class="material-symbols-outlined text-slate-400 peer-checked:text-indigo-600 mb-1">work</span>
                            <h3 class="text-sm font-bold text-slate-900">Weekday</h3><p class="text-[11px] text-slate-500">Mon – Fri</p>
                        </div>
                    </label>
                    <label class="cursor-pointer"><input class="peer sr-only" name="session_type" type="radio" value="WEEKEND"/>
                        <div class="p-4 rounded-xl border border-slate-200 peer-checked:border-indigo-600 peer-checked:bg-indigo-50/50 hover:bg-slate-50 transition-colors text-center">
                            <span class="material-symbols-outlined text-slate-400 peer-checked:text-indigo-600 mb-1">weekend</span>
                            <h3 class="text-sm font-bold text-slate-900">Weekend</h3><p class="text-[11px] text-slate-500">Sat – Sun</p>
                        </div>
                    </label>
                </div>
            </div>

            <div class="bg-white rounded-2xl p-6 shadow-premium border border-slate-200 motion-item">
                <div class="flex items-center gap-3 mb-5">
                    <div class="w-10 h-10 rounded-lg bg-emerald-50 flex items-center justify-center text-emerald-600 shadow-sm border border-emerald-100"><span class="material-symbols-outlined text-[20px]">account_balance_wallet</span></div>
                    <h2 class="text-base font-bold text-slate-900">Payment Method</h2>
                </div>
                <div class="space-y-3">
                    <label class="flex items-center gap-3 p-3 rounded-xl border border-slate-200 cursor-pointer hover:bg-slate-50 has-[:checked]:border-indigo-600 has-[:checked]:bg-indigo-50/30">
                        <input checked class="w-4 h-4 text-indigo-600" name="payment_method" type="radio" value="CARD"/>
                        <span class="text-sm font-bold text-slate-900">Credit / Debit Card</span>
                        <span class="material-symbols-outlined text-slate-400 ml-auto text-[20px]">credit_card</span>
                    </label>
                    <label class="flex items-center gap-3 p-3 rounded-xl border border-slate-200 cursor-pointer hover:bg-slate-50 has-[:checked]:border-indigo-600 has-[:checked]:bg-indigo-50/30">
                        <input class="w-4 h-4 text-indigo-600" name="payment_method" type="radio" value="CASH"/>
                        <span class="text-sm font-bold text-slate-900">Cash at Branch</span>
                        <span class="material-symbols-outlined text-slate-400 ml-auto text-[20px]">storefront</span>
                    </label>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-2xl p-6 shadow-premium border border-slate-200 flex flex-col sm:flex-row justify-between items-center gap-5 motion-pop motion-visible">
            <div class="flex items-center gap-2 text-slate-500 text-[11px] font-semibold uppercase tracking-wider"><span class="material-symbols-outlined text-emerald-500 text-[16px]">lock</span> 256-bit Secure Payment</div>
            <div class="flex items-center gap-4">
                <div class="text-right"><span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Total</span><span class="block text-xl font-bold text-indigo-600 tracking-tight" id="totalPrice">Rs. 25,000</span></div>
                <button type="submit" class="px-8 py-3 bg-slate-900 hover:bg-slate-800 text-white text-sm font-bold rounded-lg transition-colors shadow-sm flex items-center gap-2 magnetic-btn">
                    Confirm & Pay <span class="material-symbols-outlined text-[16px]">arrow_forward</span>
                </button>
            </div>
        </div>
        </form>
        </c:if>

        <!-- Payment History -->
        <c:if test="${not empty allPayments}">
        <div class="mt-10 bg-white rounded-2xl shadow-premium border border-slate-200 overflow-hidden motion-pop motion-visible">
            <div class="px-6 py-4 border-b border-slate-100 flex justify-between items-center">
                <h2 class="text-sm font-bold text-slate-900">Payment History</h2>
                <span class="text-xs font-bold text-slate-400 uppercase tracking-widest">${allPayments.size()} Records</span>
            </div>
            <div class="divide-y divide-slate-100">
                <c:forEach items="${allPayments}" var="p">
                    <c:set var="sc2" value="${p.paymentStatus == 'CONFIRMED' ? 'emerald' : p.paymentStatus == 'PENDING' ? 'amber' : 'red'}" />
                    <c:set var="si" value="${p.paymentStatus == 'CONFIRMED' ? 'check_circle' : p.paymentStatus == 'PENDING' ? 'hourglass_empty' : 'cancel'}" />
                <div class="px-6 py-4 flex items-center gap-4 hover:bg-slate-50 transition-colors">
                    <div class="w-10 h-10 rounded-lg bg-${sc2}-50 text-${sc2}-600 flex items-center justify-center border border-${sc2}-100"><span class="material-symbols-outlined text-[20px]">${si}</span></div>
                    <div class="flex-1">
                        <div class="flex items-center gap-2 mb-0.5">
                            <p class="text-sm font-bold text-slate-900">${not empty p.packageType ? p.packageType : 'Standard'} Package</p>
                            <span class="px-2 py-0.5 rounded-md text-[10px] font-bold uppercase tracking-wider bg-${sc2}-50 text-${sc2}-700 border border-${sc2}-200">${p.paymentStatus}</span>
                        </div>
                        <p class="text-xs text-slate-500 font-medium flex items-center gap-3">
                            <span>${p.sessionsIncluded} sessions</span>
                            <span>•</span>
                            <span>${p.paymentMethod}</span>
                            <span>•</span>
                            <span>${p.paymentDate}</span>
                        </p>
                    </div>
                    <span class="text-base font-bold text-slate-900">Rs. <fmt:formatNumber value="${p.amount}" pattern="#,##0"/></span>
                </div>
                </c:forEach>
            </div>
        </div>
        </c:if>
    </main>
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/js/motion.js"></script>
    <script>
        const prices = { INDIVIDUAL: 'Rs. 25,000', VIP: 'Rs. 35,000', REFRESHER: 'Rs. 12,000' };
        function selectPackage(type, el) {
            document.getElementById('selectedPackage').value = type;
            document.querySelectorAll('.package-card').forEach(c => { c.classList.remove('selected'); c.querySelector('.select-label').textContent = 'Select Plan'; c.querySelector('.select-label').className = 'text-center py-2 rounded-lg bg-slate-100 text-slate-500 text-xs font-bold uppercase tracking-wider select-label'; });
            el.classList.add('selected');
            el.querySelector('.select-label').textContent = 'Selected';
            el.querySelector('.select-label').className = 'text-center py-2 rounded-lg bg-indigo-600 text-white text-xs font-bold uppercase tracking-wider select-label';
            const tp = document.getElementById('totalPrice');
            if (tp) tp.textContent = prices[type];
        }
    </script>
</body>
</html>

