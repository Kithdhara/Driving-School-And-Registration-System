<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.drivingschool.dao.*, com.drivingschool.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("INSTRUCTOR")) { response.sendRedirect("login.jsp"); return; }
    int userId = Integer.parseInt((String) session.getAttribute("userId"));
    Instructor instructor = new InstructorDAO().getInstructorByUserId(userId);
    request.setAttribute("instructor", instructor);
    if (instructor != null) {
        int iid = Integer.parseInt(instructor.getId());
        List<Schedule> schedules = new ScheduleDAO().getSchedulesByInstructor(iid);
        request.setAttribute("schedules", schedules);
        List<Schedule> upcoming = new java.util.ArrayList<>();
        int completed = 0;
        for (Schedule sc : schedules) {
            if ("COMPLETED".equals(sc.getStatus())) completed++;
            else if ("SCHEDULED".equals(sc.getStatus())) upcoming.add(sc);
        }
        request.setAttribute("upcoming", upcoming);
        request.setAttribute("completedCount", completed);
        request.setAttribute("totalStudents", new StudentDAO().getAllStudents().size());
    }
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Instructor Dashboard | DrivePro Staff</title>
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
        <h2 class="text-lg font-bold text-slate-900 tracking-tight">DrivePro Staff</h2>
    </div>
    <div class="flex items-center gap-4">
        <a href="instructorProfile.jsp" class="h-8 w-8 rounded-full bg-indigo-600 relative cursor-pointer shadow-sm ring-2 ring-transparent hover:ring-indigo-200 transition-all block">
            <div class="absolute inset-0 rounded-full flex items-center justify-center text-white text-xs font-bold">
                ${not empty instructor.fullName ? instructor.fullName.substring(0,1).toUpperCase() : 'I'}
            </div>
            <img src="${pageContext.request.contextPath}/assets/images/profiles/${userId}.jpg?t=<%= System.currentTimeMillis() %>" onerror="this.style.opacity='0';" class="relative z-10 w-full h-full object-cover rounded-full transition-opacity duration-300">
        </a>
    </div>
</header>

<div class="flex pt-16 h-screen">
    <aside class="fixed left-0 top-16 h-[calc(100vh-64px)] w-64 py-6 px-4 bg-white/60 backdrop-blur-xl border-r border-slate-200/60 hidden md:flex flex-col z-40">
        <nav class="space-y-1 flex-1">
            <p class="px-4 text-[11px] font-bold uppercase tracking-wider text-slate-400 mb-2">Menu</p>
            <a class="flex items-center gap-3 px-4 py-2.5 bg-slate-100 text-slate-900 rounded-lg font-semibold text-sm transition-colors" href="instructorDashboard.jsp">
                <span class="material-symbols-outlined text-[20px]">dashboard</span>
                <span>Dashboard Overview</span>
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="manageSessions.jsp">
                <span class="material-symbols-outlined text-[20px] group-hover:text-indigo-600 transition-colors">event_note</span>
                <span>My Sessions</span>
                <c:if test="${upcoming.size() > 0}">
                    <span class="ml-auto bg-slate-200 text-slate-700 py-0.5 px-2 rounded-md text-[10px] font-bold">${upcoming.size()}</span>
                </c:if>
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="#">
                <span class="material-symbols-outlined text-[20px] group-hover:text-indigo-600 transition-colors">payments</span>
                <span>Payroll & Earnings</span>
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="instructorProfile.jsp">
                <span class="material-symbols-outlined text-[20px] group-hover:text-indigo-600 transition-colors">person</span>
                <span>My Profile</span>
            </a>
        </nav>
        
        <div class="mt-auto pt-4 border-t border-slate-200/60">
            <a href="javascript:void(0)" onclick="confirmLogout()" class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-red-50 hover:text-red-600 rounded-lg font-medium text-sm transition-colors">
                <span class="material-symbols-outlined text-[20px]">logout</span> Logout
            </a>
        </div>
    </aside>

    <main class="ml-0 md:ml-64 flex-1 p-8 overflow-y-auto">
        <div class="max-w-6xl mx-auto pb-12">
            
            <div class="mb-8 flex flex-col md:flex-row md:items-end justify-between gap-4 motion-pop motion-visible">
                <div>
                    <h1 class="text-2xl font-bold text-slate-900 tracking-tight mb-1">Welcome back, ${not empty instructor.fullName ? instructor.fullName : sessionScope.username}</h1>
                    <p class="text-slate-500 text-sm">Here's your teaching activity and schedule for today.</p>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-12 gap-5 mb-8 motion-container">
                
                <div class="md:col-span-8 bg-white rounded-2xl p-6 border border-slate-200 shadow-premium flex flex-col justify-between motion-item interactive-card">
                    <div class="flex items-center justify-between mb-6">
                        <div>
                            <h2 class="text-lg font-bold text-slate-900">Teaching Activity</h2>
                            <p class="text-xs text-slate-500 font-medium mt-0.5">Your overall performance and load</p>
                        </div>
                    </div>
                    
                    <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mt-auto">
                        <div class="p-4 bg-slate-50 rounded-xl border border-slate-100 group hover:border-slate-300 transition-colors">
                            <span class="material-symbols-outlined text-indigo-500 mb-2">calendar_month</span>
                            <span class="block text-2xl font-bold text-slate-900 tracking-tight">${upcoming.size()}</span>
                            <span class="text-[10px] font-bold text-slate-500 uppercase mt-0.5 tracking-wider">Upcoming Lessons</span>
                        </div>
                        <div class="p-4 bg-slate-50 rounded-xl border border-slate-100 group hover:border-slate-300 transition-colors">
                            <span class="material-symbols-outlined text-emerald-500 mb-2">check_circle</span>
                            <span class="block text-2xl font-bold text-slate-900 tracking-tight">${completedCount}</span>
                            <span class="text-[10px] font-bold text-slate-500 uppercase mt-0.5 tracking-wider">Lessons Completed</span>
                        </div>
                        <div class="p-4 bg-slate-50 rounded-xl border border-slate-100 group hover:border-slate-300 transition-colors">
                            <span class="material-symbols-outlined text-purple-500 mb-2">school</span>
                            <span class="block text-2xl font-bold text-slate-900 tracking-tight">${not empty allSchedules ? allSchedules.size() : 0}</span>
                            <span class="text-[10px] font-bold text-slate-500 uppercase mt-0.5 tracking-wider">Total Assignments</span>
                        </div>
                        <div class="p-4 bg-slate-900 rounded-xl border border-slate-800 flex flex-col justify-center items-center text-center cursor-pointer hover:bg-slate-800 transition-colors btn-press" onclick="window.location.href='manageSessions.jsp'">
                            <span class="material-symbols-outlined text-white text-[24px] mb-2">arrow_forward</span>
                            <span class="text-[10px] font-bold text-white uppercase tracking-wider">View Agenda</span>
                        </div>
                    </div>
                </div>

                <div class="md:col-span-4 bg-slate-900 rounded-2xl p-6 text-white shadow-premium flex flex-col items-center justify-center text-center motion-item interactive-card border border-slate-800 relative overflow-hidden">
                    <div class="absolute inset-0 bg-grid-pattern opacity-10"></div>
                    <div class="relative z-10 w-full flex flex-col items-center">
                        <div class="relative mb-4">
                            <div class="w-16 h-16 rounded-full border-2 border-slate-800 bg-indigo-600 relative overflow-hidden shadow-sm">
                                <div class="absolute inset-0 flex items-center justify-center text-white text-2xl font-bold">
                                    ${not empty instructor.fullName ? instructor.fullName.substring(0,1).toUpperCase() : 'I'}
                                </div>
                                <img src="${pageContext.request.contextPath}/assets/images/profiles/${userId}.jpg?t=<%= System.currentTimeMillis() %>" onerror="this.style.opacity='0';" class="relative z-10 w-full h-full object-cover rounded-full transition-opacity duration-300">
                            </div>
                            <div class="absolute bottom-0 right-0 w-4 h-4 bg-emerald-500 border-2 border-slate-900 rounded-full"></div>
                        </div>
                        <h3 class="text-xl font-bold mb-0.5 tracking-tight">${not empty instructor ? instructor.fullName : sessionScope.username}</h3>
                        <p class="text-slate-400 text-[11px] font-semibold uppercase tracking-wider mb-5">Class ${not empty instructor ? instructor.licenseType : 'Standard'} Instructor</p>
                        
                        <div class="w-full space-y-2.5 mt-auto pt-4 border-t border-slate-800/60">
                            <div class="flex justify-between items-center text-xs">
                                <span class="text-slate-400 font-medium">Experience</span>
                                <span class="font-bold bg-slate-800 px-2 py-1 rounded-md">${not empty instructor ? instructor.experienceYears : '0'} Years</span>
                            </div>
                            <div class="flex justify-between items-center text-xs">
                                <span class="text-slate-400 font-medium">Contact</span>
                                <span class="font-bold">${not empty instructor ? instructor.phone : '-'}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-2xl border border-slate-200 shadow-premium overflow-hidden motion-item interactive-card">
                <div class="px-6 py-4 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                    <h2 class="text-sm font-bold text-slate-900">Next Upcoming Lessons</h2>
                    <a href="manageSessions.jsp" class="text-xs font-semibold text-indigo-600 hover:text-indigo-700 transition-colors">View All</a>
                </div>
                <div class="p-2 motion-container">
                    <c:choose>
                    <c:when test="${not empty upcoming}">
                        <c:forEach items="${upcoming}" var="sc" end="2">
                    <div class="p-3 m-2 bg-white rounded-xl border border-slate-200 flex items-center justify-between group hover:border-slate-300 hover:bg-slate-50 transition-colors motion-item cursor-pointer shadow-sm" onclick="window.location.href='manageSessions.jsp'">
                        <div class="flex items-center gap-4">
                            <div class="w-10 h-10 bg-indigo-50 rounded-lg flex flex-col items-center justify-center text-indigo-600">
                                <span class="material-symbols-outlined text-[18px]">calendar_month</span>
                            </div>
                            <div>
                                <h4 class="font-bold text-slate-900 text-sm">${sc.studentName}</h4>
                                <p class="text-xs text-slate-500 font-medium flex items-center gap-1 mt-0.5"><span class="material-symbols-outlined text-[12px]">schedule</span> ${sc.sessionDate} at ${sc.sessionTime}</p>
                            </div>
                        </div>
                        <div class="w-8 h-8 rounded-full bg-white border border-slate-200 flex items-center justify-center text-slate-400 group-hover:text-indigo-600 group-hover:border-indigo-200 transition-all">
                            <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
                        </div>
                    </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                    <div class="p-10 text-center flex flex-col items-center justify-center">
                        <div class="w-12 h-12 bg-slate-50 text-slate-400 rounded-full border border-slate-100 flex items-center justify-center mb-3">
                            <span class="material-symbols-outlined text-[20px]">event_available</span>
                        </div>
                        <h3 class="text-sm font-bold text-slate-900 mb-0.5">Clear Schedule</h3>
                        <p class="text-xs text-slate-500">You don't have any upcoming lessons scheduled right now.</p>
                    </div>
                    </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/motion.js"></script>
</body>
</html>


