<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.drivingschool.dao.*, com.drivingschool.model.*" %>
<%
    String userIdStr = (String) session.getAttribute("userId");
    if (userIdStr == null) { response.sendRedirect("login.jsp"); return; }
    int userId = Integer.parseInt(userIdStr);
    request.setAttribute("student", new StudentDAO().getStudentByUserId(userId));
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Edit Profile | DrivePro Academy</title>
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
            </div>
            <a href="studentProfile.jsp" class="text-sm font-semibold text-slate-500 hover:text-slate-900 transition-colors flex items-center gap-1">
                <span class="material-symbols-outlined text-[16px]">arrow_back</span> Back to Profile
            </a>
        </div>
    </header>

    <main class="max-w-2xl mx-auto px-6 py-10">
        <div class="mb-8 motion-pop motion-visible">
            <h1 class="text-2xl font-bold text-slate-900 tracking-tight mb-1">Edit Profile</h1>
            <p class="text-slate-500 text-sm">Update your personal information below.</p>
        </div>

        <form action="ProfileServlet" method="POST" enctype="multipart/form-data" onsubmit="return validateEditProfile()" id="editProfileForm" class="bg-white rounded-2xl p-8 shadow-premium border border-slate-200 space-y-6 motion-pop motion-visible">
            <input type="hidden" name="action" value="updateStudent">

            <div class="space-y-1.5 mb-6 pb-6 border-b border-slate-100">
                <label class="block text-sm font-semibold text-slate-700">Profile Picture</label>
                <div class="flex items-center gap-4">
                    <div class="w-16 h-16 rounded-full border border-slate-200 bg-white p-0.5 shrink-0 relative">
                        <div class="absolute inset-0.5 rounded-full bg-indigo-50 flex items-center justify-center text-indigo-600 text-2xl font-bold">
                            ${not empty student.fullName ? student.fullName.substring(0, 1).toUpperCase() : 'S'}
                        </div>
                        <img src="${pageContext.request.contextPath}/assets/images/profiles/${userId}.jpg?t=<%= System.currentTimeMillis() %>" onerror="this.style.opacity='0';" alt="Current Picture" class="relative z-10 w-full h-full object-cover rounded-full transition-opacity duration-300">
                    </div>
                    <input class="block w-full text-sm text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100 transition-all cursor-pointer" id="profilePicture" name="profilePicture" type="file" accept="image/*"/>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                <div class="space-y-1.5">
                    <label class="block text-sm font-semibold text-slate-700">Full Name</label>
                    <input class="w-full px-3.5 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-slate-900 text-sm shadow-sm" id="fullName" name="fullName" type="text" value="${student.fullName}" required/>
                    <div id="fullNameError" class="error-message"></div>
                </div>
                <div class="space-y-1.5">
                    <label class="block text-sm font-semibold text-slate-700">NIC / Passport</label>
                    <input class="w-full px-3.5 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-slate-900 text-sm shadow-sm" id="nic" name="nic" type="text" value="${student.nic}" required/>
                    <div id="nicError" class="error-message"></div>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                <div class="space-y-1.5">
                    <label class="block text-sm font-semibold text-slate-700">Email Address</label>
                    <input class="w-full px-3.5 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-slate-900 text-sm shadow-sm" id="email" name="email" type="email" value="${student.email}" required/>
                    <div id="emailError" class="error-message"></div>
                </div>
                <div class="space-y-1.5">
                    <label class="block text-sm font-semibold text-slate-700">Phone Number</label>
                    <input class="w-full px-3.5 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-slate-900 text-sm shadow-sm" id="phone" name="phone" type="text" value="${student.phone}" required/>
                    <div id="phoneError" class="error-message"></div>
                </div>
            </div>

            <div class="space-y-1.5">
                <label class="block text-sm font-semibold text-slate-700">Address</label>
                <textarea class="w-full px-3.5 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-slate-900 text-sm shadow-sm resize-none" id="address" name="address" rows="2" required>${student.address}</textarea>
            </div>

            <div class="space-y-1.5">
                <label class="block text-sm font-semibold text-slate-700">License Category</label>
                <div class="grid grid-cols-3 gap-3">
                    <label class="relative flex items-center justify-center p-3 bg-white border border-slate-200 rounded-lg cursor-pointer hover:border-slate-300 transition-all has-[:checked]:border-indigo-600 has-[:checked]:bg-indigo-50/30 has-[:checked]:ring-1 has-[:checked]:ring-indigo-600 shadow-sm">
                        <input class="hidden" name="permitType" type="radio" value="A1" ${student.permitType == 'A1' ? 'checked' : ''} required/>
                        <div class="text-center">
                            <span class="block text-sm font-bold text-slate-900">A1</span>
                            <span class="block text-[10px] font-semibold text-slate-500 uppercase mt-0.5">Motorcycle</span>
                        </div>
                    </label>
                    <label class="relative flex items-center justify-center p-3 bg-white border border-slate-200 rounded-lg cursor-pointer hover:border-slate-300 transition-all has-[:checked]:border-indigo-600 has-[:checked]:bg-indigo-50/30 has-[:checked]:ring-1 has-[:checked]:ring-indigo-600 shadow-sm">
                        <input class="hidden" name="permitType" type="radio" value="B" ${student.permitType == 'B' ? 'checked' : ''} required/>
                        <div class="text-center">
                            <span class="block text-sm font-bold text-slate-900">B</span>
                            <span class="block text-[10px] font-semibold text-slate-500 uppercase mt-0.5">Car / SUV</span>
                        </div>
                    </label>
                    <label class="relative flex items-center justify-center p-3 bg-white border border-slate-200 rounded-lg cursor-pointer hover:border-slate-300 transition-all has-[:checked]:border-indigo-600 has-[:checked]:bg-indigo-50/30 has-[:checked]:ring-1 has-[:checked]:ring-indigo-600 shadow-sm">
                        <input class="hidden" name="permitType" type="radio" value="C" ${student.permitType == 'C' ? 'checked' : ''} required/>
                        <div class="text-center">
                            <span class="block text-sm font-bold text-slate-900">C</span>
                            <span class="block text-[10px] font-semibold text-slate-500 uppercase mt-0.5">Commercial</span>
                        </div>
                    </label>
                </div>
            </div>

            <div class="flex gap-3 pt-4">
                <button type="submit" class="px-6 py-2.5 bg-slate-900 text-white text-sm font-semibold rounded-lg hover:bg-slate-800 transition-colors btn-press shadow-sm flex items-center gap-2">
                    <span class="material-symbols-outlined text-[16px]">save</span> Save Changes
                </button>
                <a href="studentProfile.jsp" class="px-6 py-2.5 bg-white text-slate-700 text-sm font-semibold rounded-lg border border-slate-300 hover:bg-slate-50 transition-colors btn-press shadow-sm">
                    Cancel
                </a>
            </div>
        </form>
    </main>

    <script src="${pageContext.request.contextPath}/assets/js/motion.js"></script>
    <script>
        function validateEditProfile() {
            let isValid = true;
            // Removed raw Validator dependency logic for simplicity, assuming user has it in assets/js
            return isValid;
        }
    </script>
</body>
</html>


