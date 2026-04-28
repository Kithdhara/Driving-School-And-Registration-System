<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- OOP/MVC CONCEPT: View Layer - Renders the UI and sends inputs to the Spring Boot Controller --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>DrivePro Academy | Secure Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link rel="stylesheet" href="assets/css/premium.css">
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
        .bg-grid-pattern {
            background-image: linear-gradient(to right, rgba(15, 23, 42, 0.03) 1px, transparent 1px),
                              linear-gradient(to bottom, rgba(15, 23, 42, 0.03) 1px, transparent 1px);
            background-size: 40px 40px;
        }
    </style>
</head>
<body class="bg-slate-50 text-slate-900 min-h-screen flex flex-col antialiased bg-grid-pattern selection:bg-indigo-500 selection:text-white">
    
    <header class="w-full z-50 bg-transparent pt-4 mb-4">
        <div class="flex justify-between items-center h-16 px-6 lg:px-12 w-full max-w-7xl mx-auto motion-pop motion-visible">
            <div class="flex items-center gap-3">
                <div class="w-8 h-8 bg-slate-900 rounded-md flex items-center justify-center text-white shadow-sm">
                    <span class="material-symbols-outlined text-[18px]">directions_car</span>
                </div>
                <span class="text-xl font-bold tracking-tight text-slate-900">DrivePro</span>
            </div>
            <a href="register.jsp" class="text-sm font-semibold text-slate-500 hover:text-slate-900 transition-colors">Register as Student</a>
        </div>
    </header>

    <main class="flex-grow flex items-center justify-center p-6 lg:p-12 relative z-10">
        <div class="w-full max-w-5xl grid grid-cols-1 lg:grid-cols-2 bg-white rounded-2xl overflow-hidden shadow-premium border border-slate-200/60 motion-pop">
            
            <div class="hidden lg:flex flex-col justify-between p-12 relative overflow-hidden bg-slate-900">
                <img alt="Modern driving school" class="absolute inset-0 w-full h-full object-cover" src="assets/images/driving_hero.png">
                <div class="absolute inset-0 bg-gradient-to-t from-slate-950 via-slate-900/40 to-slate-900/10"></div>
                
                <div class="relative z-10 motion-container">
                    <div class="w-12 h-12 bg-white/10 backdrop-blur-md rounded-xl border border-white/20 flex items-center justify-center text-white mb-8 motion-item">
                        <span class="material-symbols-outlined">security</span>
                    </div>
                </div>

                <div class="relative z-10 motion-container">
                    <h1 class="text-3xl font-bold text-white tracking-tight mb-4 leading-tight motion-item">Industry-leading driving instruction.</h1>
                    <p class="text-slate-400 text-sm leading-relaxed max-w-md motion-item">Access your personalized dashboard, manage schedules, and track progress with absolute precision.</p>
                </div>
            </div>
            
            <div class="p-10 md:p-16 flex flex-col justify-center bg-white relative motion-container">
                <div class="mb-10 motion-item">
                    <h2 class="text-2xl font-bold text-slate-900 tracking-tight mb-1">Welcome back</h2>
                    <p class="text-slate-500 text-sm">Enter your credentials to access your account.</p>
                </div>
                
                <%
                    String success = request.getParameter("success");
                    if (success != null && !success.isEmpty()) {
                %>
                    <div class="mb-8 p-4 flex gap-3 text-sm text-green-700 rounded-lg bg-green-50/50 border border-green-100 motion-item" role="alert">
                        <span class="material-symbols-outlined text-green-500 text-[20px]">check_circle</span>
                        <p class="font-medium"><%= success %></p>
                    </div>
                <%
                    }
                %>

                <%
                    String error = (String) request.getAttribute("error");
                    if (error != null) {
                %>
                    <div class="mb-8 p-4 flex gap-3 text-sm text-red-700 rounded-lg bg-red-50/50 border border-red-100 motion-item" role="alert">
                        <span class="material-symbols-outlined text-red-500 text-[20px]">error</span>
                        <p class="font-medium"><%= error %></p>
                    </div>
                <%
                    }
                %>

                <form action="LoginServlet" class="space-y-5" method="POST">
                    <div class="space-y-1.5 motion-item">
                        <label class="block text-sm font-semibold text-slate-700" for="username">Username / ID</label>
                        <div class="relative">
                            <span class="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 text-[20px]">person</span>
                            <input class="w-full pl-11 pr-4 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all outline-none text-slate-900 text-sm shadow-sm placeholder:text-slate-400" id="username" name="username" placeholder="Enter your account ID or username" required="" type="text">
                        </div>
                    </div>
                    <div class="space-y-1.5 motion-item">
                        <div class="flex justify-between items-center">
                            <label class="block text-sm font-semibold text-slate-700" for="password">Password</label>
                            <a href="#" class="text-xs font-semibold text-indigo-600 hover:text-indigo-700 transition-colors">Forgot password?</a>
                        </div>
                        <div class="relative">
                            <span class="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 text-[20px]">lock</span>
                            <input class="w-full pl-11 pr-12 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all outline-none text-slate-900 text-sm shadow-sm placeholder:text-slate-400" id="password" name="password" placeholder="••••••••" required="" type="password">
                            <button type="button" class="password-toggle"><span class="material-symbols-outlined text-[18px]">visibility_off</span></button>
                        </div>
                    </div>
                    
                    <div class="pt-2 motion-item">
                        <button class="magnetic-btn btn-press w-full py-2.5 bg-slate-900 hover:bg-slate-800 text-white text-sm font-semibold rounded-lg shadow-sm transition-colors flex items-center justify-center gap-2" type="submit">
                            <span>Sign in to account</span>
                        </button>
                    </div>
                </form>
                
                <div class="mt-8 text-center motion-item">
                    <p class="text-sm text-slate-500">
                        Don't have an account? <a class="text-slate-900 font-semibold hover:underline" href="register.jsp">Register here</a>
                    </p>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="assets/js/motion.js"></script>
</body>
</html>


