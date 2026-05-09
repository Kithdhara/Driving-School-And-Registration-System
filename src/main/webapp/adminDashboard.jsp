<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.drivingschool.dao.*, com.drivingschool.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("ADMIN")) { response.sendRedirect("login.jsp"); return; }
    List<Student> students = new StudentDAO().getAllStudents();
    List<Instructor> instructors = new InstructorDAO().getAllInstructors();
    List<Payment> payments = new PaymentDAO().getAllPayments();
    List<Schedule> schedules = new ScheduleDAO().getAllSchedules();
    List<Review> reviews = new ReviewDAO().getAllReviews();
    request.setAttribute("students", students);
    request.setAttribute("instructors", instructors);
    request.setAttribute("payments", payments);
    request.setAttribute("schedules", schedules);
    request.setAttribute("reviews", reviews);
    double totalRevenue = 0;
    int pendingPayments = 0;
    for (Payment p : payments) {
        if ("CONFIRMED".equals(p.getPaymentStatus())) totalRevenue += p.getAmount();
        if ("PENDING".equals(p.getPaymentStatus())) pendingPayments++;
    }
    request.setAttribute("totalRevenue", totalRevenue);
    request.setAttribute("pendingPayments", pendingPayments);
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Admin Dashboard | DrivePro</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/premium.css">
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24; vertical-align: middle; }
        .bg-grid-pattern {
            background-image: linear-gradient(to right, rgba(15, 23, 42, 0.03) 1px, transparent 1px),
                              linear-gradient(to bottom, rgba(15, 23, 42, 0.03) 1px, transparent 1px);
            background-size: 40px 40px;
        }
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #e2e8f0; border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background: #cbd5e1; }
    </style>
</head>
<body class="bg-slate-50 text-slate-900 antialiased min-h-screen bg-grid-pattern selection:bg-indigo-500 selection:text-white">

<header class="fixed top-0 w-full z-50 flex justify-between items-center px-6 h-16 bg-white/80 backdrop-blur-md border-b border-slate-200/60 shadow-sm transition-all">
    <div class="flex items-center gap-3 w-64">
        <div class="w-8 h-8 bg-slate-900 rounded-md flex items-center justify-center text-white shadow-sm">
            <span class="material-symbols-outlined text-[18px]">directions_car</span>
        </div>
        <h2 class="text-lg font-bold text-slate-900 tracking-tight">DrivePro Admin</h2>
    </div>
    <div class="flex items-center gap-4">
        <button class="p-2 text-slate-400 hover:text-slate-900 rounded-full transition-colors relative magnetic-btn">
            <span class="material-symbols-outlined text-[22px]">notifications</span>
            <c:if test="${pendingPayments > 0 or rescheduleRequests > 0}">
                <span class="absolute top-1.5 right-1.5 w-2.5 h-2.5 bg-red-500 border-2 border-white rounded-full"></span>
            </c:if>
        </button>
        <div class="h-8 w-8 rounded-full bg-indigo-600 flex items-center justify-center text-white text-xs font-bold shadow-sm cursor-pointer hover:bg-indigo-700 transition-colors">
            A
        </div>
    </div>
</header>

<div class="flex pt-16 h-screen">
    <aside class="fixed left-0 top-16 h-[calc(100vh-64px)] w-64 py-6 px-4 bg-white/60 backdrop-blur-xl border-r border-slate-200/60 hidden md:flex flex-col z-40">
        <nav class="space-y-1 flex-1">
            <p class="px-4 text-[11px] font-bold uppercase tracking-wider text-slate-400 mb-2">Menu</p>
            <a class="flex items-center gap-3 px-4 py-2.5 bg-slate-100 text-slate-900 rounded-lg font-semibold text-sm transition-colors" href="adminDashboard.jsp">
                <span class="material-symbols-outlined text-[20px]">dashboard</span>
                <span>Dashboard Overview</span>
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="manageStudents.jsp">
                <span class="material-symbols-outlined text-[20px] group-hover:text-indigo-600 transition-colors">group</span>
                <span>Students & Payments</span>
                <c:if test="${pendingPayments > 0}">
                    <span class="ml-auto bg-amber-100 text-amber-700 py-0.5 px-2 rounded-md text-[10px] font-bold">${pendingPayments}</span>
                </c:if>
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="manageInstructors.jsp">
                <span class="material-symbols-outlined text-[20px] group-hover:text-indigo-600 transition-colors">badge</span>
                <span>Instructors</span>
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="manageSchedules.jsp">
                <span class="material-symbols-outlined text-[20px] group-hover:text-indigo-600 transition-colors">calendar_month</span>
                <span>Master Schedule</span>
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="sessionRequests.jsp">
                <span class="material-symbols-outlined text-[20px] group-hover:text-indigo-600 transition-colors">pending_actions</span>
                <span>Session Requests</span>
                <c:if test="${rescheduleRequests > 0}">
                    <span class="ml-auto bg-red-100 text-red-700 py-0.5 px-2 rounded-md text-[10px] font-bold">${rescheduleRequests}</span>
                </c:if>
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="manageReviews.jsp">
                <span class="material-symbols-outlined text-[20px] group-hover:text-indigo-600 transition-colors">reviews</span>
                <span>Reviews</span>
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="adminSettings.jsp">
                <span class="material-symbols-outlined text-[20px] group-hover:text-indigo-600 transition-colors">settings</span>
                <span>Settings</span>
            </a>
        </nav>
        
        <div class="mt-auto pt-4 border-t border-slate-200/60">
            <a href="javascript:void(0)" onclick="confirmLogout()" class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-red-50 hover:text-red-600 rounded-lg font-medium text-sm transition-colors">
                <span class="material-symbols-outlined text-[20px]">logout</span> Logout
            </a>
        </div>
    </aside>

    <main class="flex-1 md:ml-64 p-8 overflow-y-auto">
        <div class="max-w-6xl mx-auto pb-12">
            
            <div class="mb-8 flex justify-between items-end motion-pop motion-visible">
                <div>
                    <h1 class="text-2xl font-bold text-slate-900 tracking-tight">Dashboard Overview</h1>
                    <p class="text-slate-500 text-sm mt-1">Real-time summary of the DrivePro platform.</p>
                </div>
                <div class="text-xs font-semibold text-slate-400 bg-white px-3 py-1.5 rounded-md border border-slate-200 shadow-sm">
                    <jsp:useBean id="date" class="java.util.Date" />
                    <fmt:formatDate value="${date}" pattern="MMM dd, yyyy" />
                </div>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5 mb-8 motion-container">
                <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-premium interactive-card motion-item">
                    <div class="flex items-center justify-between mb-4">
                        <span class="w-8 h-8 flex items-center justify-center bg-slate-100 text-slate-600 rounded-lg">
                            <span class="material-symbols-outlined text-[18px]">group</span>
                        </span>
                    </div>
                    <p class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Total Students</p>
                    <h3 class="text-2xl font-bold text-slate-900 tracking-tight">${studentCount}</h3>
                </div>
                
                <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-premium interactive-card motion-item">
                    <div class="flex items-center justify-between mb-4">
                        <span class="w-8 h-8 flex items-center justify-center bg-slate-100 text-slate-600 rounded-lg">
                            <span class="material-symbols-outlined text-[18px]">badge</span>
                        </span>
                    </div>
                    <p class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Instructors</p>
                    <h3 class="text-2xl font-bold text-slate-900 tracking-tight">${instructorCount}</h3>
                </div>
                
                <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-premium interactive-card motion-item">
                    <div class="flex items-center justify-between mb-4">
                        <span class="w-8 h-8 flex items-center justify-center bg-amber-50 text-amber-600 rounded-lg">
                            <span class="material-symbols-outlined text-[18px]">calendar_month</span>
                        </span>
                    </div>
                    <p class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Scheduled Lessons</p>
                    <h3 class="text-2xl font-bold text-slate-900 tracking-tight">${scheduleCount}</h3>
                </div>
                
                <div class="bg-slate-900 p-5 rounded-2xl border border-slate-800 shadow-premium interactive-card motion-item relative overflow-hidden">
                    <div class="absolute top-0 right-0 w-32 h-32 bg-emerald-500/10 rounded-full blur-3xl -mr-10 -mt-10"></div>
                    <div class="relative z-10">
                        <div class="flex items-center justify-between mb-4">
                            <span class="w-8 h-8 flex items-center justify-center bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 rounded-lg">
                                <span class="material-symbols-outlined text-[18px]">payments</span>
                            </span>
                            <span class="text-[10px] font-bold text-emerald-400 bg-emerald-400/10 border border-emerald-400/20 px-2 py-0.5 rounded-md uppercase tracking-wider">YTD</span>
                        </div>
                        <p class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Confirmed Revenue</p>
                        <h3 class="text-2xl font-bold text-white tracking-tight">Rs. <fmt:formatNumber value="${totalRevenue}" pattern="#,###"/></h3>
                    </div>
                </div>
            </div>
            
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 motion-container">
                <div class="lg:col-span-2 bg-white rounded-2xl border border-slate-200 shadow-premium overflow-hidden flex flex-col motion-item interactive-card">
                    <div class="px-6 py-4 border-b border-slate-100 flex justify-between items-center">
                        <h2 class="text-sm font-bold text-slate-900">Platform Status</h2>
                        <div class="flex items-center gap-2">
                            <span class="relative flex h-2 w-2">
                              <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
                              <span class="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span>
                            </span>
                            <span class="text-[11px] font-semibold text-slate-500 uppercase tracking-wider">All Systems Normal</span>
                        </div>
                    </div>
                    <div class="p-8 flex-1 flex flex-col items-center justify-center text-center">
                        <div class="w-16 h-16 bg-slate-50 text-slate-400 rounded-2xl border border-slate-100 flex items-center justify-center mb-5 shadow-sm">
                            <span class="material-symbols-outlined text-3xl">rocket_launch</span>
                        </div>
                        <h3 class="text-lg font-bold text-slate-900 mb-1">DrivePro is Operational</h3>
                        <p class="text-slate-500 text-sm max-w-sm mb-6">The system is actively processing student registrations, managing payments, and keeping schedules synced.</p>
                        
                        <div class="flex gap-3 w-full max-w-xs">
                            <a href="manageStudents.jsp" class="flex-1 py-2 bg-slate-900 hover:bg-slate-800 text-white text-xs font-semibold rounded-lg transition-colors btn-press text-center shadow-sm">Manage Students</a>
                            <a href="manageSchedules.jsp" class="flex-1 py-2 bg-white border border-slate-300 text-slate-700 hover:bg-slate-50 text-xs font-semibold rounded-lg transition-colors btn-press text-center shadow-sm">View Schedule</a>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-2xl border border-slate-200 shadow-premium overflow-hidden motion-item interactive-card flex flex-col">
                    <div class="px-6 py-4 border-b border-slate-100">
                        <h2 class="text-sm font-bold text-slate-900">Action Items</h2>
                    </div>
                    <div class="p-4 flex-1 flex flex-col gap-3">
                        <c:if test="${pendingPayments > 0}">
                        <div class="p-4 bg-amber-50/50 rounded-xl border border-amber-200/50 flex items-start gap-3 relative overflow-hidden group">
                            <div class="absolute inset-0 bg-amber-50 opacity-0 group-hover:opacity-100 transition-opacity"></div>
                            <div class="mt-0.5 text-amber-500 relative z-10"><span class="material-symbols-outlined text-[20px]">notification_important</span></div>
                            <div class="relative z-10">
                                <h4 class="text-sm font-bold text-amber-900">Pending Payments</h4>
                                <p class="text-xs text-amber-700/80 mt-0.5 mb-3 leading-relaxed">${pendingPayments} student payments awaiting manual confirmation.</p>
                                <a href="manageStudents.jsp" class="inline-flex items-center gap-1 px-3 py-1.5 bg-white border border-amber-200 text-amber-700 hover:bg-amber-50 text-[11px] font-bold uppercase tracking-wider rounded-md transition-colors btn-press shadow-sm">
                                    Review Now <span class="material-symbols-outlined text-[14px]">arrow_forward</span>
                                </a>
                            </div>
                        </div>
                        </c:if>
                        
                        <c:if test="${rescheduleRequests > 0}">
                        <div class="p-4 bg-red-50/50 rounded-xl border border-red-200/50 flex items-start gap-3 relative overflow-hidden group">
                            <div class="absolute inset-0 bg-red-50 opacity-0 group-hover:opacity-100 transition-opacity"></div>
                            <div class="mt-0.5 text-red-500 relative z-10"><span class="material-symbols-outlined text-[20px]">swap_horiz</span></div>
                            <div class="relative z-10">
                                <h4 class="text-sm font-bold text-red-900">Session Requests</h4>
                                <p class="text-xs text-red-700/80 mt-0.5 mb-3 leading-relaxed">${rescheduleRequests} reschedule requests from instructors.</p>
                                <a href="sessionRequests.jsp" class="inline-flex items-center gap-1 px-3 py-1.5 bg-white border border-red-200 text-red-700 hover:bg-red-50 text-[11px] font-bold uppercase tracking-wider rounded-md transition-colors btn-press shadow-sm">
                                    Manage Requests <span class="material-symbols-outlined text-[14px]">arrow_forward</span>
                                </a>
                            </div>
                        </div>
                        </c:if>

                        <c:if test="${pendingPayments == 0 and rescheduleRequests == 0}">
                        <div class="p-8 text-center text-slate-400 flex-1 flex flex-col items-center justify-center">
                            <span class="material-symbols-outlined text-3xl mb-2 opacity-50">check_circle</span>
                            <p class="font-medium text-xs">No pending action items.<br>You're all caught up!</p>
                        </div>
                        </c:if>
                        
                        <div class="p-4 bg-slate-50/50 rounded-xl border border-slate-100 flex items-start gap-3 group hover:bg-slate-50 transition-colors cursor-pointer" onclick="window.location.href='manageSchedules.jsp'">
                            <div class="mt-0.5 text-slate-400 group-hover:text-slate-600 transition-colors"><span class="material-symbols-outlined text-[20px]">event_note</span></div>
                            <div>
                                <h4 class="text-sm font-bold text-slate-700">Master Schedule</h4>
                                <p class="text-xs text-slate-500 mt-0.5">Review schedule to ensure students have assigned sessions.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/motion.js"></script>
</body>
</html>


