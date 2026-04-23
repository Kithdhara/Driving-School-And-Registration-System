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
        ScheduleDAO scheduleDAO = new ScheduleDAO();
        List<Schedule> allSch = scheduleDAO.getSchedulesByStudent(sid);
        List<Schedule> upcoming = new java.util.ArrayList<>();
        List<Schedule> cancelled = new java.util.ArrayList<>();
        int completedLessons = 0;
        for (Schedule sc : allSch) {
            if ("COMPLETED".equals(sc.getStatus())) completedLessons++;
            else if ("SCHEDULED".equals(sc.getStatus())) upcoming.add(sc);
            else if ("CANCELLED".equals(sc.getStatus())) cancelled.add(sc);
        }
        request.setAttribute("upcoming", upcoming);
        request.setAttribute("cancelled", cancelled);
        request.setAttribute("completedLessons", completedLessons);
        request.setAttribute("totalLessons", allSch.size());
    }
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Student Dashboard | DrivePro Academy</title>
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
    </style>
</head>
<body class="bg-slate-50 text-slate-900 min-h-screen relative overflow-x-hidden bg-grid-pattern selection:bg-indigo-500 selection:text-white">

    <header class="sticky top-0 z-50 bg-white/80 backdrop-blur-md border-b border-slate-200/60 shadow-sm transition-all">
        <div class="flex justify-between items-center h-16 px-6 lg:px-12 w-full max-w-7xl mx-auto motion-pop motion-visible">
            <div class="flex items-center gap-8">
                <div class="flex items-center gap-2 text-slate-900">
                    <div class="w-8 h-8 bg-slate-900 rounded-md flex items-center justify-center text-white shadow-sm">
                        <span class="material-symbols-outlined text-[18px]">directions_car</span>
                    </div>
                    <span class="text-lg font-bold tracking-tight">DrivePro</span>
                </div>
                <nav class="hidden md:flex items-center gap-6 h-16">
                    <a class="font-semibold text-indigo-600 border-b-2 border-indigo-600 h-full flex items-center px-1 text-sm transition-colors" href="studentDashboard.jsp">Dashboard</a>
                    <a class="font-medium text-slate-500 hover:text-slate-900 h-full flex items-center px-1 text-sm transition-colors" href="sessionAndPayment.jsp">Payments & Schedule</a>
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

    <main class="max-w-7xl mx-auto px-6 lg:px-12 py-10 relative z-10">

        <c:if test="${not empty cancelled}">
        <div class="mb-6 space-y-3 motion-pop motion-visible">
            <c:forEach items="${cancelled}" var="csc">
            <div class="bg-red-50 border border-red-200 rounded-xl p-4 flex items-center gap-3">
                <span class="material-symbols-outlined text-red-500 text-[20px]">event_busy</span>
                <div class="flex-1">
                    <p class="text-sm font-bold text-red-800">Session Cancelled — ${csc.sessionDate} at ${csc.sessionTime}</p>
                    <p class="text-xs text-red-600 mt-0.5">Instructor: ${csc.instructorName}</p>
                </div>
            </div>
            </c:forEach>
        </div>
        </c:if>

        <div class="mb-10 flex flex-col md:flex-row md:items-end justify-between gap-6 motion-pop motion-visible">
            <div>
                <h1 class="text-2xl font-bold text-slate-900 tracking-tight mb-1">Welcome back, ${sessionScope.username}</h1>
                <p class="text-slate-500 max-w-md text-sm">You're making excellent progress toward your driver's license.</p>
            </div>
            <div class="flex items-center gap-4 bg-white p-3.5 rounded-xl shadow-premium border border-slate-200 interactive-card">
                <div class="flex flex-col">
                    <span class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Next Milestone</span>
                    <span class="text-sm font-bold text-slate-900">
                        <c:choose>
                            <c:when test="${empty upcoming}">Session Assignment</c:when>
                            <c:otherwise>Next Lesson: ${upcoming[0].sessionDate}</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="w-10 h-10 rounded-lg bg-indigo-50 border border-indigo-100 text-indigo-600 flex items-center justify-center">
                    <span class="material-symbols-outlined text-[20px]">schedule</span>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-12 gap-5 motion-container">
            
            <div class="md:col-span-8 bg-white rounded-2xl p-6 relative overflow-hidden flex flex-col justify-between min-h-[280px] shadow-premium border border-slate-200 motion-item interactive-card">
                <div class="relative z-10 h-full flex flex-col">
                    <div class="flex items-center justify-between mb-8">
                        <div>
                            <h2 class="text-lg font-bold text-slate-900">Training Progress</h2>
                            <p class="text-xs text-slate-500 font-medium mt-0.5">Your journey at DrivePro Academy</p>
                        </div>
                        <c:if test="${totalLessons == 0}">
                        <div class="bg-amber-50 text-amber-700 px-3 py-1 rounded-md text-[11px] font-bold flex items-center gap-1 border border-amber-200/60 shadow-sm">
                            <span class="material-symbols-outlined text-[14px]">pending_actions</span> Action Required
                        </div>
                        </c:if>
                    </div>
                    
                    <div class="mt-auto">
                        <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
                            <div class="p-4 bg-slate-50 rounded-xl border border-slate-100 group hover:border-slate-300 transition-colors">
                                <span class="material-symbols-outlined text-indigo-500 mb-2 text-[22px]">menu_book</span>
                                <span class="block text-2xl font-bold text-slate-900 tracking-tight">${completedLessons} <span class="text-sm text-slate-400 font-semibold">/ ${totalLessons}</span></span>
                                <span class="text-[10px] font-bold text-slate-500 uppercase mt-0.5 tracking-wider">Lessons Done</span>
                            </div>
                            <div class="p-4 bg-slate-50 rounded-xl border border-slate-100 group hover:border-slate-300 transition-colors">
                                <span class="material-symbols-outlined text-emerald-500 mb-2 text-[22px]">directions_car</span>
                                <span class="block text-2xl font-bold text-slate-900 tracking-tight">${completedLessons * 2}<span class="text-sm text-slate-400 font-semibold">h</span></span>
                                <span class="text-[10px] font-bold text-slate-500 uppercase mt-0.5 tracking-wider">Driving Hours</span>
                            </div>
                            <div class="p-4 bg-slate-50 rounded-xl border border-slate-100 group hover:border-slate-300 transition-colors">
                                <span class="material-symbols-outlined text-purple-500 mb-2 text-[22px]">fact_check</span>
                                <span class="block text-2xl font-bold text-slate-900 tracking-tight">0 <span class="text-sm text-slate-400 font-semibold">/ 3</span></span>
                                <span class="text-[10px] font-bold text-slate-500 uppercase mt-0.5 tracking-wider">Mock Exams</span>
                            </div>
                            <div class="p-4 bg-slate-900 rounded-xl border border-slate-800 flex flex-col justify-center items-center text-center cursor-pointer hover:bg-slate-800 transition-colors btn-press shadow-sm" onclick="window.location.href='sessionAndPayment.jsp'">
                                <span class="material-symbols-outlined text-white text-[24px] mb-2">calendar_today</span>
                                <span class="text-[10px] font-bold text-white uppercase tracking-wider">Book Sessions</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="md:col-span-4 bg-slate-900 rounded-2xl p-6 text-white shadow-premium flex flex-col items-center justify-center text-center motion-item interactive-card border border-slate-800 relative overflow-hidden">
                <div class="absolute inset-0 bg-grid-pattern opacity-10"></div>
                <div class="relative z-10 w-full flex flex-col items-center h-full">
                    <div class="relative mb-4">
                        <div class="w-16 h-16 rounded-full border-2 border-slate-800 bg-indigo-600 relative overflow-hidden shadow-sm">
                            <div class="absolute inset-0 flex items-center justify-center text-white text-2xl font-bold">
                                ${not empty student.fullName ? student.fullName.substring(0,1).toUpperCase() : 'S'}
                            </div>
                            <img src="${pageContext.request.contextPath}/assets/images/profiles/${userId}.jpg?t=<%= System.currentTimeMillis() %>" onerror="this.style.opacity='0';" class="relative z-10 w-full h-full object-cover rounded-full transition-opacity duration-300">
                        </div>
                        <div class="absolute bottom-0 right-0 w-4 h-4 bg-emerald-500 border-2 border-slate-900 rounded-full"></div>
                    </div>
                    <h3 class="text-xl font-bold mb-0.5 tracking-tight">${not empty student ? student.fullName : sessionScope.username}</h3>
                    <p class="text-slate-400 text-[11px] font-semibold uppercase tracking-wider mb-6">Student ID: SL-${not empty student ? student.id : 'PENDING'}</p>
                    
                    <div class="w-full space-y-2 mt-auto">
                        <a href="sessionAndPayment.jsp" class="w-full py-2.5 px-4 bg-white text-slate-900 hover:bg-slate-100 transition-colors rounded-lg text-xs font-semibold flex items-center justify-center gap-1.5 shadow-sm btn-press">
                            <span class="material-symbols-outlined text-[16px]">payments</span>
                            Payment Status
                        </a>
                        <button class="w-full py-2.5 px-4 bg-slate-800 text-white hover:bg-slate-700 border border-slate-700 transition-colors rounded-lg text-xs font-semibold flex items-center justify-center gap-1.5 btn-press shadow-sm">
                            <span class="material-symbols-outlined text-[16px] text-indigo-400">badge</span>
                            View Digital ID
                        </button>
                    </div>
                </div>
            </div>

            <div class="md:col-span-12 bg-white rounded-2xl p-6 shadow-premium border border-slate-200 motion-item interactive-card">
                <div class="flex items-center justify-between mb-6 border-b border-slate-100 pb-4">
                    <h2 class="text-sm font-bold text-slate-900">Upcoming Schedule</h2>
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-widest">${upcoming.size()} Lessons Scheduled</span>
                </div>
                
                <div class="space-y-4">
                    <c:if test="${empty upcoming}">
                    <div class="flex items-center gap-5 p-5 rounded-xl border border-dashed border-slate-300 bg-slate-50/50">
                        <div class="w-12 h-12 bg-white border border-slate-200 rounded-lg flex items-center justify-center text-slate-400 shadow-sm">
                            <span class="material-symbols-outlined text-[24px]">event_busy</span>
                        </div>
                        <div class="flex-1">
                            <h4 class="text-sm font-bold text-slate-900">No Lessons Scheduled</h4>
                            <p class="text-slate-500 text-xs mt-0.5 max-w-md">Please complete your registration payment and session preference to get assigned an instructor and schedule.</p>
                        </div>
                        <a href="sessionAndPayment.jsp" class="px-4 py-2.5 bg-slate-900 text-white text-xs font-semibold rounded-lg hover:bg-slate-800 transition-colors hidden sm:block btn-press shadow-sm">
                            Go to Payments
                        </a>
                    </div>
                    </c:if>
                    
                    <c:forEach items="${upcoming}" var="sc">
                    <div class="flex flex-col sm:flex-row items-start sm:items-center gap-5 p-5 rounded-xl border border-slate-200 bg-white hover:border-indigo-300 transition-all group relative overflow-hidden">
                        <div class="absolute inset-y-0 left-0 w-1 bg-indigo-500 opacity-0 group-hover:opacity-100 transition-opacity"></div>
                        <div class="w-14 h-14 bg-indigo-50 rounded-xl flex flex-col items-center justify-center text-indigo-600 shadow-sm border border-indigo-100/50">
                            <!-- We can use string functions to parse the date, but since we're keeping it simple, we'll use a split workaround or just display full date if splitting is hard in JSTL -->
                            <c:set var="dateParts" value="${fn:split(sc.sessionDate, '-')}" />
                            <span class="text-[10px] font-black uppercase tracking-tighter leading-none mb-1">${dateParts[1]}</span>
                            <span class="text-xl font-black leading-none tracking-tighter">${dateParts[2]}</span>
                        </div>
                        <div class="flex-1">
                            <div class="flex items-center gap-2 mb-1">
                                <h4 class="text-base font-bold text-slate-900 leading-tight">Practical Driving Session</h4>
                                <span class="px-2 py-0.5 bg-emerald-50 text-emerald-600 text-[10px] font-bold rounded-md border border-emerald-100 shadow-sm uppercase tracking-wider">Confirmed</span>
                            </div>
                            <p class="text-slate-500 text-xs font-medium flex items-center gap-1.5">
                                <span class="material-symbols-outlined text-[14px]">person</span> Instructor: <span class="text-slate-900 font-bold">${sc.instructorName}</span>
                                <span class="mx-1 text-slate-300">|</span>
                                <span class="material-symbols-outlined text-[14px]">schedule</span> Time: <span class="text-slate-900 font-bold">${sc.sessionTime}</span>
                            </p>
                        </div>
                        <div class="flex flex-col items-end gap-2 shrink-0">
                        </div>
                    </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/js/motion.js"></script>
</body>
</html>

