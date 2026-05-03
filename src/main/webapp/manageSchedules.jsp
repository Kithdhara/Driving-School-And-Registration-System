<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.drivingschool.dao.*, com.drivingschool.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("ADMIN")) { response.sendRedirect("login.jsp"); return; }
    request.setAttribute("schedules", new ScheduleDAO().getAllSchedules());
    List<Student> students = new StudentDAO().getAllStudents();
    request.setAttribute("students", students);
    request.setAttribute("instructors", new InstructorDAO().getAllInstructors());
    
    Map<String, Payment> studentPaymentMap = new java.util.HashMap<>();
    PaymentDAO paymentDAO = new PaymentDAO();
    for(Student s : students) {
        Payment p = paymentDAO.getPaymentByStudentId(Integer.parseInt(s.getId()));
        if(p != null && "CONFIRMED".equals(p.getPaymentStatus())) {
            studentPaymentMap.put(s.getId(), p);
        }
    }
    request.setAttribute("studentPaymentMap", studentPaymentMap);
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Master Schedule | DrivePro Admin</title>
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
            <c:if test="${pendingPayments > 0}">
                <span class="absolute top-1.5 right-1.5 w-2.5 h-2.5 bg-red-500 border-2 border-white rounded-full"></span>
            </c:if>
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
            <a class="flex items-center gap-3 px-4 py-2.5 bg-slate-100 text-slate-900 rounded-lg font-semibold text-sm transition-colors" href="manageSchedules.jsp">
                <span class="material-symbols-outlined text-[20px]">calendar_month</span>
                <span>Master Schedule</span>
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="sessionRequests.jsp">
                <span class="material-symbols-outlined text-[20px] group-hover:text-indigo-600 transition-colors">pending_actions</span>
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
        <div class="max-w-6xl mx-auto pb-12">
            <div class="mb-8 flex flex-col md:flex-row md:items-end justify-between gap-4 motion-pop motion-visible">
                <div>
                    <h1 class="text-2xl font-bold text-slate-900 tracking-tight mb-1">Master Schedule</h1>
                    <p class="text-slate-500 text-sm">Coordinate driving sessions across all instructors and students.</p>
                </div>
            </div>


            <section class="bg-white rounded-2xl border border-slate-200 shadow-premium overflow-hidden mb-8 motion-item interactive-card">
                <div class="px-6 py-4 border-b border-slate-100 bg-slate-50/50 flex justify-between items-center">
                    <h2 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                        <span class="material-symbols-outlined text-[18px] text-indigo-600">event_available</span>
                        Book New Session
                    </h2>
                </div>
                <div class="p-6">
                    <form action="ScheduleServlet" method="POST" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="space-y-1.5">
                            <label class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Select Student</label>
                            <select name="studentId" required class="w-full bg-white border border-slate-200 rounded-lg text-sm font-medium px-3 py-2 focus:ring-2 focus:ring-indigo-600 focus:border-transparent outline-none transition-all shadow-sm">
                                <option value="">Select Student...</option>
                                <c:forEach items="${students}" var="s">
                                    <c:set var="payment" value="${studentPaymentMap[s.id]}"/>
                                    <c:if test="${not empty payment}">
                                        <option value="${s.id}">${s.fullName} — ${payment.sessionPreference} Only</option>
                                    </c:if>
                                    <c:if test="${empty payment}">
                                        <option value="${s.id}" disabled>${s.fullName} (No Active Package)</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="space-y-1.5">
                            <label class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Assign Instructor</label>
                            <select name="instructorId" required class="w-full bg-white border border-slate-200 rounded-lg text-sm font-medium px-3 py-2 focus:ring-2 focus:ring-indigo-600 focus:border-transparent outline-none transition-all shadow-sm">
                                <option value="">Select Instructor...</option>
                                <c:forEach items="${instructors}" var="i">
                                    <option value="${i.id}">${i.fullName} (${i.licenseType})</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="space-y-1.5">
                            <label class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Date</label>
                            <input type="date" name="sessionDate" required class="w-full bg-white border border-slate-200 rounded-lg text-sm font-medium px-3 py-2 focus:ring-2 focus:ring-indigo-600 focus:border-transparent outline-none transition-all shadow-sm"/>
                        </div>
                        
                        <div class="space-y-1.5">
                            <label class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Time Slot</label>
                            <select name="sessionTime" required class="w-full bg-white border border-slate-200 rounded-lg text-sm font-medium px-3 py-2 focus:ring-2 focus:ring-indigo-600 focus:border-transparent outline-none transition-all shadow-sm">
                                <option value="">Select Time...</option>
                                <option value="08:00 AM - 10:00 AM">08:00 AM - 10:00 AM</option>
                                <option value="10:30 AM - 12:30 PM">10:30 AM - 12:30 PM</option>
                                <option value="01:30 PM - 03:30 PM">01:30 PM - 03:30 PM</option>
                                <option value="04:00 PM - 06:00 PM">04:00 PM - 06:00 PM</option>
                            </select>
                        </div>
                        
                        <div class="md:col-span-2 lg:col-span-4 flex items-end justify-end mt-2">
                            <button class="w-full sm:w-auto px-6 py-2.5 bg-slate-900 text-white rounded-lg text-xs font-semibold hover:bg-slate-800 transition-colors btn-press shadow-sm flex items-center justify-center gap-1.5 magnetic-btn" type="submit">
                                <span class="material-symbols-outlined text-[18px]">add_task</span> Confirm Booking
                            </button>
                        </div>
                    </form>
                </div>
            </section>


            <section class="bg-white rounded-2xl border border-slate-200 shadow-premium overflow-hidden motion-item interactive-card">
                <div class="px-6 py-4 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                    <h2 class="text-sm font-bold text-slate-900">Active Bookings</h2>
                    <span class="px-2.5 py-1 bg-slate-100 text-slate-600 text-[10px] font-bold uppercase tracking-wider rounded-md border border-slate-200 shadow-sm">${schedules.size()} Total</span>
                </div>
                <div class="overflow-x-auto motion-container">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-white border-b border-slate-100">
                                <th class="px-6 py-4 text-[11px] font-bold text-slate-400 uppercase tracking-wider">Date & Time</th>
                                <th class="px-6 py-4 text-[11px] font-bold text-slate-400 uppercase tracking-wider">Student</th>
                                <th class="px-6 py-4 text-[11px] font-bold text-slate-400 uppercase tracking-wider">Instructor</th>
                                <th class="px-6 py-4 text-[11px] font-bold text-slate-400 uppercase tracking-wider">Status</th>
                                <th class="px-6 py-4 text-[11px] font-bold text-slate-400 uppercase tracking-wider text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                            <c:forEach items="${schedules}" var="sc">
                            <tr class="hover:bg-slate-50/50 transition-colors group motion-item">
                                <td class="px-6 py-4">
                                    <div class="text-sm font-bold text-slate-900">${sc.sessionDate}</div>
                                    <div class="text-xs font-semibold text-slate-500 flex items-center gap-1 mt-0.5"><span class="material-symbols-outlined text-[12px]">schedule</span> ${sc.sessionTime}</div>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="text-sm font-bold text-slate-700">${sc.studentName}</div>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="text-sm font-bold text-indigo-600">${sc.instructorName}</div>
                                </td>
                                <td class="px-6 py-4">
                                    <c:choose>
                                        <c:when test="${sc.status == 'SCHEDULED'}">
                                            <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md text-[10px] font-bold border border-indigo-200 bg-indigo-50 text-indigo-700 uppercase tracking-wider shadow-sm">
                                                <span class="w-1.5 h-1.5 rounded-full bg-indigo-500 animate-pulse"></span> Scheduled
                                            </span>
                                        </c:when>
                                        <c:when test="${sc.status == 'COMPLETED'}">
                                            <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md text-[10px] font-bold border border-emerald-200 bg-emerald-50 text-emerald-700 uppercase tracking-wider shadow-sm">
                                                <span class="material-symbols-outlined text-[12px]">check_circle</span> Completed
                                            </span>
                                        </c:when>
                                        <c:when test="${sc.status == 'RESCHEDULE_REQ'}">
                                            <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md text-[10px] font-bold border border-amber-200 bg-amber-50 text-amber-700 uppercase tracking-wider shadow-sm">
                                                <span class="material-symbols-outlined text-[12px]">swap_horiz</span> Review Req
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex items-center px-2.5 py-1 rounded-md text-[10px] font-bold border border-red-200 bg-red-50 text-red-700 uppercase tracking-wider shadow-sm">${sc.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-6 py-4 text-right">
                                    <div class="flex items-center justify-end gap-1.5 opacity-0 group-hover:opacity-100 transition-all duration-300 transform translate-x-2 group-hover:translate-x-0">
                                        <c:choose>
                                            <c:when test="${sc.status == 'SCHEDULED'}">
                                                <a href="javascript:void(0)" onclick="confirmAction('ScheduleServlet?action=updateStatus&id=${sc.scheduleId}&status=COMPLETED', 'Mark as Completed?', 'This session will be marked as done.', 'Complete', 'question')" class="text-emerald-600 bg-emerald-50 hover:bg-emerald-100 p-1.5 rounded-md transition-colors border border-emerald-200 shadow-sm btn-press" title="Mark Completed"><span class="material-symbols-outlined text-[16px]">done_all</span></a>
                                                <a href="javascript:void(0)" onclick="confirmAction('ScheduleServlet?action=updateStatus&id=${sc.scheduleId}&status=CANCELLED', 'Cancel This Session?', 'The booking will be cancelled.', 'Cancel Booking', 'warning')" class="text-red-600 bg-red-50 hover:bg-red-100 p-1.5 rounded-md transition-colors border border-red-200 shadow-sm btn-press" title="Cancel Booking"><span class="material-symbols-outlined text-[16px]">event_busy</span></a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-slate-300 text-[10px] font-semibold uppercase tracking-wider">Locked</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                            </tr>
                            </c:forEach>
                            <c:if test="${empty schedules}">
                            <tr>
                                <td colspan="5" class="px-6 py-16 text-center text-slate-400">
                                    <span class="material-symbols-outlined text-4xl mb-3 opacity-50">event_note</span>
                                    <p class="font-medium text-sm">No sessions scheduled.</p>
                                </td>
                            </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/motion.js"></script>
</body>
</html>

