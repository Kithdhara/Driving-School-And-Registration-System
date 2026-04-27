<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- OOP/MVC CONCEPT: View Layer - Renders the UI and sends inputs to the Spring Boot Controller --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty sessionScope.role or sessionScope.role ne 'ADMIN'}">
    <c:redirect url="login.jsp"/>
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Admin Settings | DrivePro</title>
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
        <div class="h-8 w-8 rounded-full bg-indigo-600 flex items-center justify-center text-white text-xs font-bold shadow-sm">A</div>
    </div>
</header>

<div class="flex pt-16 h-screen">
    <aside class="fixed left-0 top-16 h-[calc(100vh-64px)] w-64 py-6 px-4 bg-white/60 backdrop-blur-xl border-r border-slate-200/60 hidden md:flex flex-col z-40">
        <nav class="space-y-1 flex-1">
            <p class="px-4 text-[11px] font-bold uppercase tracking-wider text-slate-400 mb-2">Menu</p>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors" href="adminDashboard.jsp">
                <span class="material-symbols-outlined text-[20px]">dashboard</span> Dashboard
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors" href="manageStudents.jsp">
                <span class="material-symbols-outlined text-[20px]">group</span> Students & Payments
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors" href="manageInstructors.jsp">
                <span class="material-symbols-outlined text-[20px]">badge</span> Instructors
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors" href="manageSchedules.jsp">
                <span class="material-symbols-outlined text-[20px]">calendar_month</span> Master Schedule
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors" href="sessionRequests.jsp">
                <span class="material-symbols-outlined text-[20px]">pending_actions</span> Session Requests
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 text-slate-500 hover:bg-slate-100/50 hover:text-slate-900 rounded-lg font-medium text-sm transition-colors" href="manageReviews.jsp">
                <span class="material-symbols-outlined text-[20px]">reviews</span> Reviews
            </a>
            <a class="flex items-center gap-3 px-4 py-2.5 bg-slate-100 text-slate-900 rounded-lg font-semibold text-sm transition-colors" href="adminSettings.jsp">
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
        <div class="max-w-2xl mx-auto pb-12">
            <div class="mb-8 motion-pop motion-visible">
                <h1 class="text-2xl font-bold text-slate-900 tracking-tight">Account Settings</h1>
                <p class="text-slate-500 text-sm mt-1">Manage your admin account and security preferences.</p>
            </div>

            <div class="space-y-6 motion-container">
                <!-- Account Info -->
                <div class="bg-white rounded-2xl p-8 shadow-premium border border-slate-200 motion-item">
                    <h2 class="text-base font-bold text-slate-900 mb-4 flex items-center gap-2">
                        <span class="material-symbols-outlined text-indigo-600 text-[20px]">admin_panel_settings</span> Admin Account
                    </h2>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="space-y-1">
                            <span class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Username</span>
                            <p class="text-sm font-semibold text-slate-900">${sessionScope.username}</p>
                        </div>
                        <div class="space-y-1">
                            <span class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Role</span>
                            <span class="inline-flex px-3 py-1 bg-indigo-50 text-indigo-700 text-xs font-bold rounded-md border border-indigo-100">Administrator</span>
                        </div>
                    </div>
                </div>

                <!-- Change Password -->
                <div class="bg-white rounded-2xl p-8 shadow-premium border border-slate-200 motion-item">
                    <h2 class="text-base font-bold text-slate-900 mb-2 flex items-center gap-2">
                        <span class="material-symbols-outlined text-indigo-600 text-[20px]">lock</span> Change Password
                    </h2>
                    <p class="text-slate-500 text-sm mb-6">Use a strong password that you don't use elsewhere.</p>
                    
                    <form action="ProfileServlet" method="POST" onsubmit="return validatePasswordChange()" id="passwordForm" class="space-y-4">
                        <input type="hidden" name="action" value="changePassword">
                        <div class="space-y-1.5">
                            <label class="block text-sm font-semibold text-slate-700">Current Password</label>
                            <div class="relative">
                                <input class="w-full px-3.5 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-sm shadow-sm" id="oldPassword" name="oldPassword" type="password" required/>
                                <button type="button" class="password-toggle"><span class="material-symbols-outlined text-[18px]">visibility_off</span></button>
                            </div>
                            <div id="oldPasswordError" class="error-message"></div>
                        </div>
                        <div class="space-y-1.5">
                            <label class="block text-sm font-semibold text-slate-700">New Password</label>
                            <div class="relative">
                                <input class="w-full px-3.5 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-sm shadow-sm" id="newPassword" name="newPassword" type="password" required/>
                                <button type="button" class="password-toggle"><span class="material-symbols-outlined text-[18px]">visibility_off</span></button>
                            </div>
                            <div id="newPasswordError" class="error-message"></div>
                        </div>
                        <div class="space-y-1.5">
                            <label class="block text-sm font-semibold text-slate-700">Confirm New Password</label>
                            <input class="w-full px-3.5 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-sm shadow-sm" id="confirmPassword" type="password" required/>
                            <div id="confirmPasswordError" class="error-message"></div>
                        </div>
                        <button type="submit" class="px-6 py-2.5 bg-slate-900 text-white text-sm font-semibold rounded-lg hover:bg-slate-800 transition-colors btn-press shadow-sm">
                            Update Password
                        </button>
                    </form>
                </div>

                <!-- Platform Stats -->
                <div class="bg-white rounded-2xl p-8 shadow-premium border border-slate-200 motion-item">
                    <h2 class="text-base font-bold text-slate-900 mb-4 flex items-center gap-2">
                        <span class="material-symbols-outlined text-indigo-600 text-[20px]">analytics</span> Platform Stats
                    </h2>
                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                        <div class="p-4 bg-slate-50 rounded-xl text-center">
                            <p class="text-2xl font-bold text-slate-900">${studentCount}</p>
                            <p class="text-[10px] font-bold text-slate-400 uppercase tracking-wider mt-1">Students</p>
                        </div>
                        <div class="p-4 bg-slate-50 rounded-xl text-center">
                            <p class="text-2xl font-bold text-slate-900">${instructorCount}</p>
                            <p class="text-[10px] font-bold text-slate-400 uppercase tracking-wider mt-1">Instructors</p>
                        </div>
                        <div class="p-4 bg-slate-50 rounded-xl text-center">
                            <p class="text-2xl font-bold text-slate-900">${scheduleCount}</p>
                            <p class="text-[10px] font-bold text-slate-400 uppercase tracking-wider mt-1">Sessions</p>
                        </div>
                        <div class="p-4 bg-slate-50 rounded-xl text-center">
                            <p class="text-2xl font-bold text-slate-900">${paymentCount}</p>
                            <p class="text-[10px] font-bold text-slate-400 uppercase tracking-wider mt-1">Payments</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/motion.js"></script>
<script>
    function validatePasswordChange() {
        let isValid = true;
        const newPwd = document.getElementById('newPassword').value;
        const confirmPwd = document.getElementById('confirmPassword').value;
        if (newPwd !== confirmPwd) { alert('Passwords do not match'); isValid = false; }
        return isValid;
    }
</script>
</body>
</html>


