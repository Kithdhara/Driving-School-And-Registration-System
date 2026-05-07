<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.drivingschool.dao.*, com.drivingschool.model.*, java.util.*" %>
<%
    String userIdStr = (String) session.getAttribute("userId");
    if (userIdStr == null) { response.sendRedirect("login.jsp"); return; }
    int userId = Integer.parseInt(userIdStr);
    Student student = new StudentDAO().getStudentByUserId(userId);
    if (student != null) {
        List<Payment> payments = new PaymentDAO().getPaymentsByStudentId(Integer.parseInt(student.getId()));
        request.setAttribute("payments", payments);
        double totalPaid = 0.0;
        for (Payment p : payments) {
            if ("CONFIRMED".equals(p.getPaymentStatus())) totalPaid += p.getAmount();
        }
        request.setAttribute("totalPaid", totalPaid);
    }
    request.setAttribute("student", student);
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Payment History | DrivePro Academy</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/premium.css">
</head>
<body class="bg-slate-50 text-slate-900 min-h-screen bg-grid-pattern selection:bg-indigo-500 selection:text-white">

    <header class="sticky top-0 z-50 bg-white/80 backdrop-blur-md border-b border-slate-200/60 shadow-sm">
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
                    <a class="font-medium text-slate-500 hover:text-slate-900 h-full flex items-center px-1 text-sm transition-colors" href="sessionAndPayment.jsp">Payments & Schedule</a>
                    <a class="font-medium text-slate-500 hover:text-slate-900 h-full flex items-center px-1 text-sm transition-colors" href="studentProfile.jsp">My Profile</a>
                    <a class="font-semibold text-indigo-600 border-b-2 border-indigo-600 h-full flex items-center px-1 text-sm transition-colors" href="paymentHistory.jsp">Payment History</a>
                </nav>
            </div>
            <a href="javascript:void(0)" onclick="confirmLogout()" class="flex items-center gap-2 px-3 py-1.5 bg-slate-100 text-slate-700 font-semibold text-xs rounded-md hover:bg-slate-200 transition-colors btn-press">
                Logout <span class="material-symbols-outlined text-[16px]">logout</span>
            </a>
        </div>
    </header>

    <main class="max-w-5xl mx-auto px-6 lg:px-12 py-10">
        <div class="mb-8 flex flex-col md:flex-row md:items-end justify-between gap-6 motion-pop motion-visible">
            <div>
                <h1 class="text-2xl font-bold text-slate-900 tracking-tight mb-1">Payment History</h1>
                <p class="text-slate-500 text-sm">Complete record of all your transactions with DrivePro Academy.</p>
            </div>
            <div class="flex items-center gap-4 bg-white p-3.5 rounded-xl shadow-premium border border-slate-200">
                <div class="flex flex-col">
                    <span class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Total Paid</span>
                    <span class="text-lg font-bold text-emerald-600 tracking-tight">Rs. <fmt:formatNumber value="${totalPaid}" pattern="#,##0"/></span>
                </div>
                <div class="w-10 h-10 rounded-lg bg-emerald-50 border border-emerald-100 text-emerald-600 flex items-center justify-center">
                    <span class="material-symbols-outlined text-[20px]">payments</span>
                </div>
            </div>
        </div>

        <c:if test="${empty payments}">
        <div class="empty-state motion-pop motion-visible">
            <span class="material-symbols-outlined empty-icon">receipt_long</span>
            <h3>No Payments Yet</h3>
            <p>You haven't made any payments. Head to the payments page to submit your enrollment payment.</p>
            <a href="sessionAndPayment.jsp" class="mt-4 px-4 py-2 bg-slate-900 text-white text-xs font-semibold rounded-lg hover:bg-slate-800 transition-colors btn-press inline-flex items-center gap-1">
                Go to Payments <span class="material-symbols-outlined text-[14px]">arrow_forward</span>
            </a>
        </div>
        </c:if>

        <c:if test="${not empty payments}">
        <div class="bg-white rounded-2xl shadow-premium border border-slate-200 overflow-hidden motion-pop motion-visible">
            <div class="px-6 py-4 border-b border-slate-100 flex justify-between items-center">
                <h2 class="text-sm font-bold text-slate-900">All Transactions</h2>
                <span class="text-xs font-bold text-slate-400 uppercase tracking-widest">${payments.size()} Records</span>
            </div>
            <div class="divide-y divide-slate-100">
                <c:forEach items="${payments}" var="p">
                    <c:set var="statusColor" value="${p.paymentStatus == 'CONFIRMED' ? 'emerald' : p.paymentStatus == 'PENDING' ? 'amber' : 'red'}" />
                    <c:set var="statusIcon" value="${p.paymentStatus == 'CONFIRMED' ? 'check_circle' : p.paymentStatus == 'PENDING' ? 'hourglass_empty' : 'cancel'}" />
                <div class="px-6 py-5 flex items-center gap-5 hover:bg-slate-50 transition-colors">
                    <div class="w-12 h-12 rounded-xl bg-${statusColor}-50 text-${statusColor}-600 flex items-center justify-center border border-${statusColor}-100/50">
                        <span class="material-symbols-outlined text-[22px]">${statusIcon}</span>
                    </div>
                    <div class="flex-1">
                        <div class="flex items-center gap-2 mb-0.5">
                            <p class="text-base font-bold text-slate-900">${not empty p.packageType ? p.packageType : 'Standard'} Package</p>
                            <span class="px-2 py-0.5 rounded-md text-[10px] font-bold uppercase tracking-wider bg-${statusColor}-50 text-${statusColor}-700 border border-${statusColor}-200">
                                ${p.paymentStatus}
                            </span>
                        </div>
                        <p class="text-xs text-slate-500 font-medium flex items-center gap-3">
                            <span>Rs. <fmt:formatNumber value="${p.amount}" pattern="#,##0"/></span>
                            <span>•</span>
                            <span>${p.sessionsIncluded} sessions</span>
                            <span>•</span>
                            <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[12px]">credit_card</span> ${p.paymentMethod}</span>
                            <span>•</span>
                            <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[12px]">calendar_today</span> ${p.paymentDate}</span>
                        </p>
                    </div>
                </div>
                </c:forEach>
            </div>
        </div>
        </c:if>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/js/motion.js"></script>
</body>
</html>




