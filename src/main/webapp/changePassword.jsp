<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- OOP/MVC CONCEPT: View Layer - Renders the UI and sends inputs to the Spring Boot Controller --%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Change Password | DrivePro Academy</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link rel="stylesheet" href="assets/css/premium.css">
</head>
<body class="bg-slate-50 text-slate-900 min-h-screen bg-grid-pattern selection:bg-indigo-500 selection:text-white">

    <header class="sticky top-0 z-50 bg-white/80 backdrop-blur-md border-b border-slate-200/60 shadow-sm">
        <div class="flex justify-between items-center h-16 px-6 lg:px-12 w-full max-w-7xl mx-auto">
            <div class="flex items-center gap-2 text-slate-900">
                <div class="w-8 h-8 bg-slate-900 rounded-md flex items-center justify-center text-white shadow-sm">
                    <span class="material-symbols-outlined text-[18px]">directions_car</span>
                </div>
                <span class="text-lg font-bold tracking-tight">DrivePro</span>
            </div>
            <%
                String backUrl = "STUDENT".equals(role) ? "studentProfile.jsp" : "INSTRUCTOR".equals(role) ? "instructorProfile.jsp" : "adminSettings.jsp";
            %>
            <a href="<%= backUrl %>" class="text-sm font-semibold text-slate-500 hover:text-slate-900 transition-colors flex items-center gap-1">
                <span class="material-symbols-outlined text-[16px]">arrow_back</span> Back
            </a>
        </div>
    </header>

    <main class="max-w-lg mx-auto px-6 py-10">
        <div class="mb-8 motion-pop motion-visible">
            <h1 class="text-2xl font-bold text-slate-900 tracking-tight mb-1">Change Password</h1>
            <p class="text-slate-500 text-sm">Keep your account secure with a strong password.</p>
        </div>

        <form action="ProfileServlet" method="POST" onsubmit="return validatePasswordChange()" id="passwordForm" class="bg-white rounded-2xl p-8 shadow-premium border border-slate-200 space-y-5 motion-pop motion-visible">
            <input type="hidden" name="action" value="changePassword">

            <div class="space-y-1.5">
                <label class="block text-sm font-semibold text-slate-700">Current Password</label>
                <div class="relative">
                    <span class="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 text-[20px]">lock</span>
                    <input class="w-full pl-11 pr-12 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-slate-900 text-sm shadow-sm" id="oldPassword" name="oldPassword" type="password" placeholder="••••••••" required/>
                    <button type="button" class="password-toggle"><span class="material-symbols-outlined text-[18px]">visibility_off</span></button>
                </div>
                <div id="oldPasswordError" class="error-message"></div>
            </div>

            <div class="space-y-1.5">
                <label class="block text-sm font-semibold text-slate-700">New Password</label>
                <div class="relative">
                    <span class="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 text-[20px]">key</span>
                    <input class="w-full pl-11 pr-12 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-slate-900 text-sm shadow-sm" id="newPassword" name="newPassword" type="password" placeholder="••••••••" required/>
                    <button type="button" class="password-toggle"><span class="material-symbols-outlined text-[18px]">visibility_off</span></button>
                </div>
                <div id="newPasswordError" class="error-message"></div>
                <p class="text-xs text-slate-400 mt-1">6+ characters with a mix of letters, numbers, and symbols</p>
            </div>

            <div class="space-y-1.5">
                <label class="block text-sm font-semibold text-slate-700">Confirm New Password</label>
                <div class="relative">
                    <span class="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 text-[20px]">check_circle</span>
                    <input class="w-full pl-11 pr-4 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-slate-900 text-sm shadow-sm" id="confirmPassword" type="password" placeholder="••••••••" required/>
                </div>
                <div id="confirmPasswordError" class="error-message"></div>
            </div>

            <button type="submit" class="w-full py-2.5 bg-slate-900 text-white text-sm font-semibold rounded-lg hover:bg-slate-800 transition-colors btn-press shadow-sm flex items-center justify-center gap-2 mt-2">
                <span class="material-symbols-outlined text-[16px]">lock_reset</span> Update Password
            </button>
        </form>
    </main>

    <script src="assets/js/motion.js"></script>
    <script>
        function validatePasswordChange() {
            Validator.clearErrors('passwordForm');
            let isValid = true;
            const oldPwd = document.getElementById('oldPassword').value;
            const newPwd = document.getElementById('newPassword').value;
            const confirmPwd = document.getElementById('confirmPassword').value;

            if (!oldPwd) { Validator.showError('oldPassword', 'Please enter your current password'); isValid = false; }
            if (!Validator.isValidPassword(newPwd)) { Validator.showError('newPassword', '6+ chars with letters, numbers, and symbols'); isValid = false; }
            if (newPwd !== confirmPwd) { Validator.showError('confirmPassword', 'Passwords do not match'); isValid = false; }
            if (oldPwd === newPwd && oldPwd.length > 0) { Validator.showError('newPassword', 'New password must be different'); isValid = false; }
            return isValid;
        }
    </script>
</body>
</html>
