<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- OOP/MVC CONCEPT: View Layer - Renders the UI and sends inputs to the Spring Boot Controller --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>DrivePro Academy | Student Registration</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link rel="stylesheet" href="assets/css/premium.css">
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24; vertical-align: middle; }
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
            <a href="login.jsp" class="text-sm font-semibold text-slate-500 hover:text-slate-900 transition-colors">Back to Login</a>
        </div>
    </header>

    <main class="flex-grow flex items-center justify-center p-6 lg:p-12 relative z-10 pt-4">
        <div class="w-full max-w-6xl grid grid-cols-1 lg:grid-cols-12 bg-white rounded-2xl overflow-hidden shadow-premium border border-slate-200/60 motion-pop">
            
            <div class="hidden lg:flex lg:col-span-4 flex-col justify-end p-10 relative overflow-hidden bg-slate-900">
                <img alt="Modern driving school" class="absolute inset-0 w-full h-full object-cover" src="assets/images/driving_hero.png">
                <div class="absolute inset-0 bg-gradient-to-t from-slate-950 via-slate-900/60 to-slate-900/10"></div>
                
                <div class="relative z-10 motion-container">
                    <h2 class="text-3xl font-bold text-white tracking-tight mb-4 leading-tight motion-item">Start Your Journey.</h2>
                    <p class="text-slate-400 text-sm leading-relaxed motion-item">Join the academy that has trained over 10,000 safe and professional drivers across the country.</p>
                </div>
            </div>
            
            <div class="lg:col-span-8 p-8 md:p-12">
                <div class="mb-8 border-b border-slate-200/60 pb-6 motion-container">
                    <h1 class="text-2xl font-bold text-slate-900 mb-1 tracking-tight motion-item">Student Enrollment</h1>
                    <p class="text-slate-500 text-sm motion-item">Create your account to book lessons and track your progress.</p>
                </div>

                <%
                    String error = request.getParameter("error");
                    if (error != null && !error.isEmpty()) {
                %>
                <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg flex items-center gap-3">
                    <span class="material-symbols-outlined text-red-500 text-xl">error</span>
                    <p class="text-sm font-medium text-red-700"><%= error %></p>
                </div>
                <% } %>

                <form action="RegisterServlet" method="POST" class="space-y-8 motion-container" onsubmit="return validateRegister()" id="registerForm">
                    
                    <div class="motion-item">
                        <h3 class="text-[11px] font-bold uppercase tracking-wider text-slate-400 mb-4">Personal Details</h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                            <div class="space-y-1.5">
                                <label class="block text-sm font-semibold text-slate-700" for="fullname">Full Name</label>
                                <input class="w-full px-3.5 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-slate-900 text-sm shadow-sm" id="fullname" name="fullname" placeholder="Alex Rivera" type="text" required/>
                                <div id="fullnameError" class="error-message"></div>
                            </div>
                            <div class="space-y-1.5">
                                <label class="block text-sm font-semibold text-slate-700" for="nic">National ID / Passport</label>
                                <input class="w-full px-3.5 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-slate-900 text-sm shadow-sm" id="nic" name="nic" placeholder="e.g. 199812345678" type="text" required/>
                                <div id="nicError" class="error-message"></div>
                            </div>
                        </div>
                    </div>

                    <div class="motion-item">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                            <div class="space-y-1.5">
                                <label class="block text-sm font-semibold text-slate-700" for="email">Email Address</label>
                                <input class="w-full px-3.5 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-slate-900 text-sm shadow-sm" id="email" name="email" placeholder="alex@example.com" type="email" required/>
                                <div id="emailError" class="error-message"></div>
                            </div>
                            <div class="space-y-1.5">
                                <label class="block text-sm font-semibold text-slate-700" for="phone">Phone Number</label>
                                <input class="w-full px-3.5 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-slate-900 text-sm shadow-sm" id="phone" name="phone" placeholder="0771234567" type="tel" required/>
                                <div id="phoneError" class="error-message"></div>
                            </div>
                            <div class="md:col-span-2 space-y-1.5">
                                <label class="block text-sm font-semibold text-slate-700" for="address">Residential Address</label>
                                <textarea class="w-full px-3.5 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-slate-900 text-sm shadow-sm resize-none" id="address" name="address" placeholder="123 Main St, City, Country" rows="2" required></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="bg-slate-50/50 rounded-xl p-5 border border-slate-200/60 motion-item">
                        <label class="block text-sm font-semibold text-slate-700 mb-3">Target License Category</label>
                        <div class="grid grid-cols-3 gap-4">
                            <label class="relative flex items-center justify-center p-3 bg-white border border-slate-200 rounded-lg cursor-pointer hover:border-slate-300 transition-all has-[:checked]:border-indigo-600 has-[:checked]:bg-indigo-50/30 has-[:checked]:ring-1 has-[:checked]:ring-indigo-600 shadow-sm">
                                <input class="hidden" name="permit_type" type="radio" value="A1" required/>
                                <div class="text-center">
                                    <span class="block text-sm font-bold text-slate-900">A1</span>
                                    <span class="block text-[10px] font-semibold text-slate-500 uppercase mt-0.5">Motorcycle</span>
                                </div>
                            </label>
                            <label class="relative flex items-center justify-center p-3 bg-white border border-slate-200 rounded-lg cursor-pointer hover:border-slate-300 transition-all has-[:checked]:border-indigo-600 has-[:checked]:bg-indigo-50/30 has-[:checked]:ring-1 has-[:checked]:ring-indigo-600 shadow-sm">
                                <input checked class="hidden" name="permit_type" type="radio" value="B" required/>
                                <div class="text-center">
                                    <span class="block text-sm font-bold text-slate-900">B</span>
                                    <span class="block text-[10px] font-semibold text-slate-500 uppercase mt-0.5">Car / SUV</span>
                                </div>
                            </label>
                            <label class="relative flex items-center justify-center p-3 bg-white border border-slate-200 rounded-lg cursor-pointer hover:border-slate-300 transition-all has-[:checked]:border-indigo-600 has-[:checked]:bg-indigo-50/30 has-[:checked]:ring-1 has-[:checked]:ring-indigo-600 shadow-sm">
                                <input class="hidden" name="permit_type" type="radio" value="C" required/>
                                <div class="text-center">
                                    <span class="block text-sm font-bold text-slate-900">C</span>
                                    <span class="block text-[10px] font-semibold text-slate-500 uppercase mt-0.5">Commercial</span>
                                </div>
                            </label>
                        </div>
                    </div>

                    <div class="pt-2 border-t border-slate-200/60 motion-item">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mt-4">
                            <div class="space-y-1.5">
                                <label class="block text-sm font-semibold text-slate-700" for="username">Create Username</label>
                                <input class="w-full px-3.5 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-slate-900 text-sm shadow-sm" id="username" name="username" placeholder="alexr_99" type="text" required/>
                            </div>
                            <div class="space-y-1.5">
                                <label class="block text-sm font-semibold text-slate-700" for="password">Create Password</label>
                                <div class="relative">
                                    <input class="w-full px-3.5 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-slate-900 text-sm shadow-sm pr-12" id="password" name="password" placeholder="••••••••" type="password" required/>
                                    <button type="button" class="password-toggle"><span class="material-symbols-outlined text-[18px]">visibility_off</span></button>
                                </div>
                                <div id="passwordError" class="error-message"></div>
                                <p class="text-xs text-slate-400 mt-1">6+ characters with letters, numbers, and symbols</p>
                            </div>
                        </div>
                    </div>

                    <div class="pt-4 motion-item">
                        <button class="magnetic-btn btn-press w-full bg-slate-900 hover:bg-slate-800 text-white font-semibold text-sm py-3 rounded-lg shadow-sm transition-colors flex items-center justify-center gap-2" type="submit">
                            <span>Register</span>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <script src="assets/js/motion.js"></script>
    <script>
        function validateRegister() {
            Validator.clearErrors('registerForm');
            let isValid = true;
            const name = document.getElementById('fullname').value.trim();
            const nic = document.getElementById('nic').value.trim();
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const password = document.getElementById('password').value;

            if (!name || !Validator.isLettersOnly(name)) {
                Validator.showError('fullname', 'Name must contain only letters');
                isValid = false;
            }
            if (!Validator.isValidNIC(nic)) {
                Validator.showError('nic', 'Enter valid NIC (old: 9 digits+V/X, new: 12 digits)');
                isValid = false;
            }
            if (!Validator.isValidEmail(email)) {
                Validator.showError('email', 'Enter a valid email address');
                isValid = false;
            }
            if (!Validator.isValidPhone(phone)) {
                Validator.showError('phone', 'Phone must be 10 digits starting with 0');
                isValid = false;
            }
            if (!Validator.isValidPassword(password)) {
                Validator.showError('password', '6+ chars with letters, numbers, and symbols');
                isValid = false;
            }
            return isValid;
        }
    </script>
</body>
</html>

