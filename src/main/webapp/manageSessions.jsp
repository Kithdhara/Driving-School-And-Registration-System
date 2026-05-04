<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.drivingschool.dao.*, com.drivingschool.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("INSTRUCTOR")) { response.sendRedirect("login.jsp"); return; }
    int userId = Integer.parseInt((String) session.getAttribute("userId"));
    Instructor instructor = new InstructorDAO().getInstructorByUserId(userId);
    request.setAttribute("instructor", instructor);
    if (instructor != null) {
        request.setAttribute("schedules", new ScheduleDAO().getSchedulesByInstructor(Integer.parseInt(instructor.getId())));
    }
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>My Sessions | DrivePro Instructor</title>
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
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="instructorDashboard.jsp">
                <span class="material-symbols-outlined text-[20px] group-hover:text-indigo-600 transition-colors">dashboard</span>
                <span>Dashboard Overview</span>
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 bg-slate-100 text-slate-900 rounded-lg font-semibold text-sm transition-colors" href="manageSessions.jsp">
                <span class="material-symbols-outlined text-[20px]">event_note</span>
                <span>My Sessions</span>
                <c:if test="${pendingSessions > 0}">
                    <span class="ml-auto bg-slate-200 text-slate-700 py-0.5 px-2 rounded-md text-[10px] font-bold">${pendingSessions}</span>
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
            <a href="LogoutServlet" class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-red-50 hover:text-red-600 rounded-lg font-medium text-sm transition-colors">
                <span class="material-symbols-outlined text-[20px]">logout</span> Logout
            </a>
        </div>
    </aside>


    <main class="ml-0 md:ml-64 flex-1 p-8 overflow-y-auto">
        <div class="max-w-6xl mx-auto pb-12">
            
            <div class="mb-8 flex justify-between items-end motion-pop motion-visible">
                <div>
                    <h1 class="text-2xl font-bold text-slate-900 tracking-tight">Session Agenda</h1>
                    <p class="text-slate-500 text-sm mt-1">Welcome back, ${not empty instructor ? instructor.fullName : 'Instructor'}. Manage your upcoming student lessons.</p>
                </div>
            </div>


            <div class="bg-white rounded-2xl border border-slate-200 shadow-premium overflow-hidden motion-item interactive-card">
                <div class="px-6 py-5 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                    <h2 class="text-sm font-bold text-slate-900">Your Master Schedule</h2>
                </div>
                <div class="overflow-x-auto motion-container">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-white border-b border-slate-100">
                                <th class="px-6 py-4 text-[11px] font-bold text-slate-400 uppercase tracking-wider">Date & Time</th>
                                <th class="px-6 py-4 text-[11px] font-bold text-slate-400 uppercase tracking-wider">Student Name</th>
                                <th class="px-6 py-4 text-[11px] font-bold text-slate-400 uppercase tracking-wider">Status</th>
                                <th class="px-6 py-4 text-[11px] font-bold text-slate-400 uppercase tracking-wider text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                            <c:choose>
                            <c:when test="${not empty schedules}">
                            <c:forEach items="${schedules}" var="sc">
                            <tr class="hover:bg-slate-50/50 transition-colors group motion-item">
                                <td class="px-6 py-4">
                                    <div class="text-sm font-bold text-slate-900">${sc.sessionDate}</div>
                                    <div class="text-xs font-semibold text-slate-500 flex items-center gap-1 mt-0.5"><span class="material-symbols-outlined text-[12px]">schedule</span> ${sc.sessionTime}</div>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="flex items-center gap-3">
                                        <div class="w-8 h-8 rounded-lg bg-indigo-50 border border-indigo-100 flex items-center justify-center text-indigo-600 font-bold text-xs shadow-sm">
                                            ${not empty sc.studentName ? sc.studentName.substring(0, 1).toUpperCase() : 'S'}
                                        </div>
                                        <p class="text-sm font-bold text-slate-700">${sc.studentName}</p>
                                    </div>
                                </td>
                                <td class="px-6 py-4">
                                    <c:choose>
                                    <c:when test="${sc.status == 'SCHEDULED'}">
                                        <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md text-[10px] font-bold border border-indigo-200 bg-indigo-50 text-indigo-700 uppercase tracking-wider shadow-sm">
                                            <span class="w-1.5 h-1.5 rounded-full bg-indigo-500 animate-pulse"></span> Confirmed
                                        </span>
                                    </c:when>
                                    <c:when test="${sc.status == 'COMPLETED'}">
                                        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-md text-[10px] font-bold border border-emerald-200 bg-emerald-50 text-emerald-700 uppercase tracking-wider shadow-sm">
                                            <span class="material-symbols-outlined text-[12px]">check_circle</span> Completed
                                        </span>
                                    </c:when>
                                    <c:when test="${sc.status == 'RESCHEDULE_REQ'}">
                                        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-md text-[10px] font-bold border border-amber-200 bg-amber-50 text-amber-700 uppercase tracking-wider shadow-sm">
                                            <span class="material-symbols-outlined text-[12px]">swap_horiz</span> Reviewing Req
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="inline-flex items-center px-2.5 py-1 rounded-md text-[10px] font-bold border border-red-200 bg-red-50 text-red-700 uppercase tracking-wider shadow-sm">${sc.status}</span>
                                    </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-6 py-4 text-right">
                                    <c:choose>
                                    <c:when test="${sc.status == 'SCHEDULED'}">
                                    <div class="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition-all duration-300 transform translate-x-2 group-hover:translate-x-0">
                                        <a href="ScheduleServlet?action=updateStatus&id=${sc.scheduleId}&status=COMPLETED" class="px-3 py-1.5 bg-slate-900 text-white rounded-md text-[11px] font-semibold hover:bg-slate-800 transition-colors btn-press shadow-sm flex items-center gap-1" title="Mark as Completed">
                                            <span class="material-symbols-outlined text-[14px]">done_all</span> Complete Lesson
                                        </a>
                                        <a href="ScheduleServlet?action=updateStatus&id=${sc.scheduleId}&status=RESCHEDULE_REQ" class="p-1.5 border border-slate-200 text-slate-400 hover:text-amber-600 hover:bg-amber-50 hover:border-amber-200 rounded-md transition-colors btn-press shadow-sm" title="Request Reschedule">
                                            <span class="material-symbols-outlined text-[16px]">event_busy</span>
                                        </a>
                                    </div>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-slate-300 text-xs font-semibold uppercase tracking-wider">Locked</span>
                                    </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            </c:forEach>
                            </c:when>
                            <c:otherwise>
                            <tr>
                                <td colspan="4" class="px-6 py-16 text-center text-slate-400">
                                    <span class="material-symbols-outlined text-4xl mb-3 opacity-50">event_note</span>
                                    <p class="font-medium text-sm">No sessions scheduled at the moment.</p>
                                </td>
                            </tr>
                            </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/motion.js"></script>
</body>
</html>


