<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.drivingschool.dao.*, com.drivingschool.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("ADMIN")) { response.sendRedirect("login.jsp"); return; }
    List<Schedule> allSchedules = new ScheduleDAO().getAllSchedules();
    List<Schedule> requests = new java.util.ArrayList<>();
    for (Schedule sc : allSchedules) {
        if ("RESCHEDULE_REQ".equals(sc.getStatus())) requests.add(sc);
    }
    request.setAttribute("requests", requests);
    request.setAttribute("allSchedules", allSchedules);
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Session Requests | DrivePro Admin</title>
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
        </button>
        <div class="h-8 w-8 rounded-full bg-indigo-600 flex items-center justify-center text-white text-xs font-bold shadow-sm cursor-pointer hover:bg-indigo-700 transition-colors">A</div>
    </div>
</header>

<div class="flex pt-16 h-screen">

    <aside class="fixed left-0 top-16 h-[calc(100vh-64px)] w-64 py-6 px-4 bg-white/60 backdrop-blur-xl border-r border-slate-200/60 hidden md:flex flex-col z-40">
        <nav class="space-y-1 flex-1">
            <p class="px-4 text-[11px] font-bold uppercase tracking-wider text-slate-400 mb-2">Menu</p>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="adminDashboard.jsp">
                <span class="material-symbols-outlined text-[20px] group-hover:text-indigo-600 transition-colors">dashboard</span>
                <span>Dashboard Overview</span>
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="manageStudents.jsp">
                <span class="material-symbols-outlined text-[20px] group-hover:text-indigo-600 transition-colors">group</span>
                <span>Students & Payments</span>
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="manageInstructors.jsp">
                <span class="material-symbols-outlined text-[20px] group-hover:text-indigo-600 transition-colors">badge</span>
                <span>Instructors</span>
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="manageSchedules.jsp">
                <span class="material-symbols-outlined text-[20px] group-hover:text-indigo-600 transition-colors">calendar_month</span>
                <span>Master Schedule</span>
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 bg-slate-100 text-slate-900 rounded-lg font-semibold text-sm transition-colors" href="sessionRequests.jsp">
                <span class="material-symbols-outlined text-[20px]">pending_actions</span>
                <span>Session Requests</span>
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

    <main class="ml-0 md:ml-64 flex-1 p-8 overflow-y-auto">
        <div class="max-w-4xl mx-auto pb-12">
            <div class="mb-8 flex flex-col md:flex-row md:items-end justify-between gap-4 motion-pop motion-visible">
                <div>
                    <h1 class="text-2xl font-bold text-slate-900 tracking-tight mb-1">Review Requests</h1>
                    <p class="text-slate-500 text-sm">Approve or deny scheduling modification requests from instructors.</p>
                </div>
            </div>

            <div class="space-y-5 motion-container">
                <c:set var="hasRequests" value="false" />
                <c:forEach items="${allSchedules}" var="sc">
                    <c:if test="${sc.status == 'RESCHEDULE_REQ'}">
                        <c:set var="hasRequests" value="true" />
                        <div class="bg-white rounded-2xl p-6 border border-amber-200 shadow-premium flex flex-col lg:flex-row gap-6 lg:items-center relative overflow-hidden motion-item interactive-card group">
                            <div class="absolute left-0 top-0 bottom-0 w-1.5 bg-amber-400"></div>
                            
                            <div class="flex-grow grid grid-cols-1 md:grid-cols-2 gap-6 pl-2">
                                <div class="space-y-3">
                                    <h3 class="font-bold text-lg text-slate-900 flex items-center gap-2">
                                        <span class="material-symbols-outlined text-amber-500 text-[20px]">warning</span>
                                        Reschedule Requested
                                    </h3>
                                    <div class="inline-flex items-center gap-1.5 text-[10px] font-bold text-amber-800 bg-amber-50 px-2.5 py-1 rounded-md border border-amber-200/60 shadow-sm uppercase tracking-wider">
                                        <span class="material-symbols-outlined text-[14px]">person</span>
                                        Inst: ${sc.instructorName}
                                    </div>
                                </div>
                                
                                <div class="space-y-2.5 bg-slate-50/50 p-4 rounded-xl border border-slate-100 group-hover:bg-slate-50 transition-colors">
                                    <div class="flex items-center justify-between text-xs">
                                        <span class="text-slate-500 font-medium">Original Date</span>
                                        <span class="font-bold text-slate-900">${sc.sessionDate}</span>
                                    </div>
                                    <div class="flex items-center justify-between text-xs">
                                        <span class="text-slate-500 font-medium">Time Slot</span>
                                        <span class="font-bold text-slate-900">${sc.sessionTime}</span>
                                    </div>
                                    <div class="flex items-center justify-between text-xs pt-2.5 border-t border-slate-200">
                                        <span class="text-slate-500 font-medium">Student</span>
                                        <span class="font-bold text-indigo-600">${sc.studentName}</span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="flex flex-col sm:flex-row lg:flex-col gap-2.5 shrink-0">
                                <a href="javascript:void(0)" onclick="confirmAction('ScheduleServlet?action=updateStatus&id=${sc.scheduleId}&status=CANCELLED', 'Approve Cancellation?', 'The session will be cancelled.', 'Approve', 'question')" class="flex items-center justify-center gap-1.5 px-5 py-2.5 bg-amber-500 text-white text-xs font-bold rounded-lg hover:bg-amber-600 shadow-sm transition-colors btn-press text-center">
                                    <span class="material-symbols-outlined text-[16px]">check</span>
                                    Approve Cancel
                                </a>
                                <a href="javascript:void(0)" onclick="confirmAction('ScheduleServlet?action=updateStatus&id=${sc.scheduleId}&status=SCHEDULED', 'Deny Request?', 'Session will remain as scheduled.', 'Deny', 'info')" class="flex items-center justify-center gap-1.5 px-5 py-2.5 bg-white border border-slate-200 text-slate-600 text-xs font-bold rounded-lg hover:bg-slate-50 hover:text-slate-900 transition-colors shadow-sm btn-press text-center">
                                    <span class="material-symbols-outlined text-[16px]">close</span>
                                    Deny Request
                                </a>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
                
                <c:if test="${!hasRequests}">
                    <div class="bg-white rounded-2xl p-16 border border-slate-200 text-center flex flex-col items-center justify-center min-h-[300px] shadow-premium motion-item interactive-card">
                        <div class="w-16 h-16 bg-emerald-50 text-emerald-500 rounded-full flex items-center justify-center mb-5 border border-emerald-100 shadow-sm">
                            <span class="material-symbols-outlined text-3xl">task_alt</span>
                        </div>
                        <h3 class="text-xl font-bold text-slate-900 mb-1 tracking-tight">You're all caught up!</h3>
                        <p class="text-slate-500 text-sm">There are no pending schedule modification requests from instructors.</p>
                    </div>
                </c:if>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/motion.js"></script>
</body>
</html>

