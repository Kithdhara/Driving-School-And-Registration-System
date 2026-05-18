<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.drivingschool.dao.*, com.drivingschool.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("ADMIN")) { response.sendRedirect("login.jsp"); return; }
    List<Student> students = new StudentDAO().getAllStudents();
    List<Payment> allPayments = new PaymentDAO().getAllPayments();
    request.setAttribute("students", students);
    request.setAttribute("payments", allPayments);
    java.util.Map<String, Payment> studentPaymentMap = new java.util.HashMap<>();
    for (Payment p : allPayments) { studentPaymentMap.put(String.valueOf(p.getStudentId()), p); }
    request.setAttribute("studentPaymentMap", studentPaymentMap);
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Manage Students | DrivePro Admin</title>
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
            <a class="flex items-center gap-3 px-4 py-2.5 bg-slate-100 text-slate-900 rounded-lg font-semibold text-sm transition-colors" href="manageStudents.jsp">
                <span class="material-symbols-outlined text-[20px]">group</span>
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
                    <h1 class="text-2xl font-bold text-slate-900 tracking-tight mb-1">Student Management</h1>
                    <p class="text-slate-500 text-sm">Monitor enrollment, progress, and financial status.</p>
                </div>
                <div class="flex items-center gap-3">
                    <button class="bg-white hover:bg-slate-50 text-slate-700 border border-slate-300 px-4 py-2 rounded-lg text-xs font-semibold flex items-center gap-1.5 transition-colors shadow-sm btn-press">
                        <span class="material-symbols-outlined text-[18px]">filter_list</span> Filter
                    </button>
                    <button class="bg-slate-900 hover:bg-slate-800 text-white px-4 py-2 rounded-lg text-xs font-semibold flex items-center gap-1.5 transition-colors shadow-sm btn-press magnetic-btn">
                        <span class="material-symbols-outlined text-[18px]">download</span> Export CSV
                    </button>
                </div>
            </div>

            <div class="bg-white rounded-2xl border border-slate-200 shadow-premium overflow-hidden motion-item interactive-card">
                <div class="overflow-x-auto motion-container">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-slate-50 border-b border-slate-200">
                                <th class="px-6 py-4 text-[11px] font-bold text-slate-400 uppercase tracking-wider">Student Profile</th>
                                <th class="px-6 py-4 text-[11px] font-bold text-slate-400 uppercase tracking-wider">Contact Info</th>
                                <th class="px-6 py-4 text-[11px] font-bold text-slate-400 uppercase tracking-wider text-center">Package</th>
                                <th class="px-6 py-4 text-[11px] font-bold text-slate-400 uppercase tracking-wider">Payment Status</th>
                                <th class="px-6 py-4 text-[11px] font-bold text-slate-400 uppercase tracking-wider text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                            <c:forEach items="${students}" var="s">
                                <c:set var="p" value="${studentPaymentMap[s.id]}"/>
                                <c:set var="status" value="${not empty p ? p.paymentStatus : 'NO PAYMENT'}"/>
                                <tr class="hover:bg-slate-50/50 transition-colors group motion-item">
                                    <td class="px-6 py-4">
                                        <div class="flex items-center gap-3">
                                            <div class="w-10 h-10 rounded-full border-2 border-white bg-indigo-600 flex items-center justify-center text-white font-bold shadow-sm ring-2 ring-slate-100">
                                                ${not empty s.fullName ? s.fullName.substring(0,1).toUpperCase() : 'S'}
                                            </div>
                                            <div>
                                                <p class="text-sm font-bold text-slate-900">${s.fullName}</p>
                                                <p class="text-xs text-slate-500 font-medium">ID: ${s.nic}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <p class="text-sm text-slate-700 font-semibold">${s.email}</p>
                                        <p class="text-xs text-slate-500 font-medium">${s.phone}</p>
                                    </td>
                                    <td class="px-6 py-4 text-center">
                                        <c:choose>
                                            <c:when test="${not empty p and not empty p.packageType}">
                                                <span class="inline-flex px-2 py-1 bg-indigo-50 text-indigo-700 border border-indigo-200 rounded-md text-[10px] font-bold uppercase tracking-widest shadow-sm">${p.packageType}</span>
                                                <p class="text-[10px] text-slate-500 font-semibold mt-1">
                                                    Rs. <fmt:formatNumber value="${p.amount}" pattern="#,###"/> · ${p.sessionsIncluded} sessions
                                                </p>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex px-2 py-1 bg-slate-100 text-slate-500 border border-slate-200 rounded-md text-[10px] font-bold uppercase tracking-widest shadow-sm">No Package</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4">
                                        <c:choose>
                                            <c:when test="${status == 'PENDING'}">
                                                <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md text-[10px] font-bold border border-amber-200 bg-amber-50 text-amber-700 uppercase tracking-wider shadow-sm">
                                                    <span class="material-symbols-outlined text-[12px]">hourglass_empty</span> PENDING
                                                </span>
                                            </c:when>
                                            <c:when test="${status == 'CONFIRMED'}">
                                                <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md text-[10px] font-bold border border-emerald-200 bg-emerald-50 text-emerald-700 uppercase tracking-wider shadow-sm">
                                                    <span class="material-symbols-outlined text-[12px]">check_circle</span> ACTIVE
                                                </span>
                                            </c:when>
                                            <c:when test="${status == 'REJECTED'}">
                                                <span class="inline-flex px-2.5 py-1 rounded-md text-[10px] font-bold border border-red-200 bg-red-50 text-red-700 uppercase tracking-wider shadow-sm">REJECTED</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex px-2.5 py-1 rounded-md text-[10px] font-bold border border-slate-200 bg-slate-100 text-slate-500 uppercase tracking-wider shadow-sm">INCOMPLETE</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 text-right">
                                        <div class="flex items-center justify-end gap-1.5 opacity-0 group-hover:opacity-100 transition-all duration-300 transform translate-x-2 group-hover:translate-x-0">
                                            <c:if test="${status == 'PENDING'}">
                                                <a href="javascript:void(0)" onclick="confirmAction('PaymentServlet?action=updateStatus&id=${p.paymentId}&status=CONFIRMED', 'Confirm Payment?', 'This will mark the payment as confirmed.', 'Confirm', 'question')" class="text-emerald-600 bg-emerald-50 hover:bg-emerald-100 p-1.5 rounded-md border border-emerald-200 transition-colors shadow-sm btn-press" title="Confirm Payment"><span class="material-symbols-outlined text-[16px]">check</span></a>
                                                <a href="javascript:void(0)" onclick="confirmAction('PaymentServlet?action=updateStatus&id=${p.paymentId}&status=REJECTED', 'Reject Payment?', 'This will reject the student payment.', 'Reject', 'warning')" class="text-red-600 bg-red-50 hover:bg-red-100 p-1.5 rounded-md border border-red-200 transition-colors shadow-sm btn-press" title="Reject Payment"><span class="material-symbols-outlined text-[16px]">close</span></a>
                                            </c:if>
                                            <a href="editAdminStudentProfile.jsp?id=${s.id}" class="p-1.5 text-slate-400 hover:text-indigo-600 hover:bg-indigo-50 rounded-md transition-colors btn-press ml-1" title="Edit Student">
                                                <span class="material-symbols-outlined text-[18px]">edit</span>
                                            </a>
                                            <a href="javascript:void(0)" onclick="confirmDelete('StudentServlet?action=delete&id=${s.id}', 'student')" class="p-1.5 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded-md transition-colors btn-press" title="Remove Student">
                                                <span class="material-symbols-outlined text-[18px]">delete</span>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty students}">
                                <tr>
                                    <td colspan="5" class="px-6 py-16 text-center">
                                        <div class="flex flex-col items-center justify-center text-slate-400">
                                            <span class="material-symbols-outlined text-4xl mb-3 opacity-50">sentiment_dissatisfied</span>
                                            <p class="font-medium text-sm">No students registered yet.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/motion.js"></script>
</body>
</html>



