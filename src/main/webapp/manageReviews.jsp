<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.drivingschool.dao.*, com.drivingschool.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("ADMIN")) { response.sendRedirect("login.jsp"); return; }
    request.setAttribute("reviews", new ReviewDAO().getAllReviews());
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Manage Reviews | DrivePro Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/premium.css">
</head>
<body class="bg-slate-50 text-slate-900 antialiased min-h-screen bg-grid-pattern selection:bg-indigo-500 selection:text-white">

<header class="fixed top-0 w-full z-50 flex justify-between items-center px-6 h-16 bg-white/80 backdrop-blur-md border-b border-slate-200/60 shadow-sm">
    <div class="flex items-center gap-3 w-64">
        <div class="w-8 h-8 bg-slate-900 rounded-md flex items-center justify-center text-white shadow-sm">
            <span class="material-symbols-outlined text-[18px]">directions_car</span>
        </div>
        <h2 class="text-lg font-bold text-slate-900 tracking-tight">DrivePro Admin</h2>
    </div>
    <div class="flex items-center gap-4">
        <div class="h-8 w-8 rounded-full bg-indigo-600 flex items-center justify-center text-white text-xs font-bold shadow-sm cursor-pointer hover:bg-indigo-700 transition-colors">A</div>
    </div>
</header>

<div class="flex pt-16 h-screen">
    <aside class="fixed left-0 top-16 h-[calc(100vh-64px)] w-64 py-6 px-4 bg-white/60 backdrop-blur-xl border-r border-slate-200/60 hidden md:flex flex-col z-40">
        <nav class="space-y-1 flex-1">
            <p class="px-4 text-[11px] font-bold uppercase tracking-wider text-slate-400 mb-2">Menu</p>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="adminDashboard.jsp">
                <span class="material-symbols-outlined text-[20px]">dashboard</span> Dashboard
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="manageStudents.jsp">
                <span class="material-symbols-outlined text-[20px]">group</span> Students & Payments
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="manageInstructors.jsp">
                <span class="material-symbols-outlined text-[20px]">badge</span> Instructors
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="manageSchedules.jsp">
                <span class="material-symbols-outlined text-[20px]">calendar_month</span> Master Schedule
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="sessionRequests.jsp">
                <span class="material-symbols-outlined text-[20px]">pending_actions</span> Session Requests
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 bg-slate-100 text-slate-900 rounded-lg font-semibold text-sm transition-colors" href="manageReviews.jsp">
                <span class="material-symbols-outlined text-[20px]">reviews</span> Reviews
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors group" href="adminSettings.jsp">
                <span class="material-symbols-outlined text-[20px]">settings</span> Settings
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
                    <h1 class="text-2xl font-bold text-slate-900 tracking-tight">Student Reviews</h1>
                    <p class="text-slate-500 text-sm mt-1">Manage and moderate instructor reviews submitted by students.</p>
                </div>
                <span class="text-xs font-bold text-slate-400 bg-white px-3 py-1.5 rounded-md border border-slate-200 shadow-sm uppercase tracking-widest">${reviews.size()} Total Reviews</span>
            </div>

            <c:if test="${empty reviews}">
            <div class="empty-state motion-pop motion-visible">
                <span class="material-symbols-outlined empty-icon">rate_review</span>
                <h3>No Reviews Yet</h3>
                <p>No students have submitted reviews yet. Reviews will appear here once students rate their instructors.</p>
            </div>
            </c:if>
            <c:if test="${not empty reviews}">
            <div class="bg-white rounded-2xl shadow-premium border border-slate-200 overflow-hidden motion-pop motion-visible">
                <div class="divide-y divide-slate-100">
                    <c:forEach items="${reviews}" var="r">
                    <div class="px-6 py-5 flex items-start gap-4 hover:bg-slate-50 transition-colors group">
                        <div class="w-10 h-10 bg-slate-100 rounded-full flex items-center justify-center shrink-0">
                            <span class="material-symbols-outlined text-[20px] text-slate-500">person</span>
                        </div>
                        <div class="flex-1 min-w-0">
                            <div class="flex items-center gap-2 mb-1">
                                <p class="text-sm font-bold text-slate-900">${r.studentName}</p>
                                <span class="text-slate-300">&rarr;</span>
                                <p class="text-sm font-semibold text-indigo-600">${r.instructorName}</p>
                            </div>
                            <div class="star-display mb-2">
                                <c:forEach begin="1" end="5" var="i">
                                    <span class="material-symbols-outlined text-[14px] ${i <= r.rating ? 'star-filled' : 'star-empty'}">star</span>
                                </c:forEach>
                                <span class="text-xs text-slate-400 ml-1">${r.reviewDate}</span>
                            </div>
                            <p class="text-sm text-slate-600 leading-relaxed">${r.comment}</p>
                        </div>
                        <button onclick="confirmDelete('ReviewServlet?action=delete&id=${r.reviewId}', 'review')" class="opacity-0 group-hover:opacity-100 transition-opacity p-2 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded-lg shrink-0">
                            <span class="material-symbols-outlined text-[18px]">delete</span>
                        </button>
                    </div>
                    </c:forEach>
                </div>
            </div>
            </c:if>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/motion.js"></script>
</body>
</html>

