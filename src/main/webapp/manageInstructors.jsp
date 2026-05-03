<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.drivingschool.dao.*, com.drivingschool.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("ADMIN")) { response.sendRedirect("login.jsp"); return; }
    request.setAttribute("instructors", new InstructorDAO().getAllInstructors());
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Manage Instructors | DrivePro Admin</title>
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
            <a class="flex items-center gap-3 px-4 py-2.5 bg-slate-100 text-slate-900 rounded-lg font-semibold text-sm transition-colors" href="manageInstructors.jsp">
                <span class="material-symbols-outlined text-[20px]">badge</span>
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
                    <h1 class="text-2xl font-bold text-slate-900 tracking-tight mb-1">Instructor Fleet</h1>
                    <p class="text-slate-500 text-sm">Manage teaching staff, specializations, and credentials.</p>
                </div>
                <div class="flex items-center gap-3">
                    <button onclick="document.getElementById('addModal').classList.remove('hidden'); document.getElementById('addModal').classList.add('flex');" class="bg-slate-900 hover:bg-slate-800 text-white px-4 py-2 rounded-lg text-xs font-semibold flex items-center gap-1.5 transition-colors shadow-sm btn-press magnetic-btn">
                        <span class="material-symbols-outlined text-[18px]">person_add</span>
                        Onboard Instructor
                    </button>
                </div>
            </div>

            <div class="bg-white rounded-2xl border border-slate-200 shadow-premium overflow-hidden motion-item interactive-card">
                <div class="overflow-x-auto motion-container">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-slate-50 border-b border-slate-200">
                                <th class="px-6 py-4 text-[11px] font-bold text-slate-400 uppercase tracking-wider">Instructor Profile</th>
                                <th class="px-6 py-4 text-[11px] font-bold text-slate-400 uppercase tracking-wider text-center">Specialization</th>
                                <th class="px-6 py-4 text-[11px] font-bold text-slate-400 uppercase tracking-wider">Experience</th>
                                <th class="px-6 py-4 text-[11px] font-bold text-slate-400 uppercase tracking-wider text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                            <c:forEach items="${instructors}" var="inst">
                            <tr class="hover:bg-slate-50/50 transition-colors group motion-item">
                                <td class="px-6 py-4">
                                    <div class="flex items-center gap-3">
                                        <div class="w-9 h-9 rounded-full bg-slate-100 border border-slate-200 flex items-center justify-center text-slate-600 font-bold text-xs shadow-sm">
                                            ${not empty inst.fullName ? inst.fullName.substring(0,1).toUpperCase() : 'I'}
                                        </div>
                                        <div>
                                            <p class="text-sm font-bold text-slate-900">${inst.fullName}</p>
                                            <p class="text-xs text-slate-500 font-medium">${inst.email} • ${inst.phone}</p>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 text-center">
                                    <span class="inline-flex px-2 py-1 bg-slate-100 text-slate-700 border border-slate-200 rounded-md text-[10px] font-bold uppercase tracking-widest shadow-sm">${inst.licenseType}</span>
                                </td>
                                <td class="px-6 py-4">
                                    <p class="text-sm text-slate-700 font-semibold">${inst.experienceYears} Years</p>
                                    <p class="text-xs text-slate-400 font-medium">@${inst.username}</p>
                                </td>
                                <td class="px-6 py-4 text-right">
                                    <div class="flex items-center justify-end gap-1.5 opacity-0 group-hover:opacity-100 transition-all duration-300 transform translate-x-2 group-hover:translate-x-0">
                                        <button onclick="openEditModal('${inst.id}', '${inst.fullName}', '${inst.email}', '${inst.phone}', '${inst.licenseType}', '${inst.username}', '${inst.experienceYears}')" class="p-1.5 text-slate-400 hover:text-indigo-600 hover:bg-indigo-50 rounded-md transition-colors btn-press" title="Edit">
                                            <span class="material-symbols-outlined text-[18px]">edit</span>
                                        </button>
                                        <a href="javascript:void(0)" onclick="confirmDelete('InstructorServlet?action=delete&id=${inst.id}', 'instructor')" class="p-1.5 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded-md transition-colors btn-press" title="Remove">
                                            <span class="material-symbols-outlined text-[18px]">delete</span>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            </c:forEach>
                            <c:if test="${empty instructors}">
                            <tr>
                                <td colspan="4" class="px-6 py-16 text-center">
                                    <div class="flex flex-col items-center justify-center text-slate-400">
                                        <span class="material-symbols-outlined text-4xl mb-3 opacity-50">badge</span>
                                        <p class="font-medium text-sm">No instructors onboarded yet.</p>
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

<div id="addModal" class="fixed inset-0 bg-slate-900/40 backdrop-blur-sm hidden items-center justify-center z-50 p-4 transition-all duration-300">
    <div class="bg-white rounded-3xl shadow-[0_20px_50px_rgba(0,0,0,0.2)] w-full max-w-xl flex flex-col max-h-[90vh] border border-slate-200/60 transform scale-95 animate-in overflow-hidden">
        <div class="px-8 py-8 border-b border-slate-100 flex justify-between items-center shrink-0 bg-slate-900 relative overflow-hidden">
            <div class="absolute inset-0 bg-gradient-to-br from-indigo-600/20 to-transparent opacity-50"></div>
            <div class="absolute -right-4 -top-4 w-32 h-32 bg-indigo-500/10 rounded-full blur-3xl"></div>
            
            <div class="relative z-10">
                <div class="flex items-center gap-3 mb-1">
                    <div class="w-10 h-10 bg-white/10 backdrop-blur-md border border-white/20 rounded-xl flex items-center justify-center text-white shadow-inner">
                        <span class="material-symbols-outlined text-[20px]">person_add</span>
                    </div>
                    <h3 class="font-bold text-xl text-white tracking-tight">Onboard Instructor</h3>
                </div>
                <p class="text-indigo-100/60 text-xs font-medium ml-1">Establish new teaching credentials and access.</p>
            </div>
            
            <button onclick="document.getElementById('addModal').classList.add('hidden'); document.getElementById('addModal').classList.remove('flex');" class="relative z-10 w-10 h-10 flex items-center justify-center rounded-xl bg-white/10 border border-white/20 text-white hover:bg-white/20 transition-all shadow-sm btn-press group">
                <span class="material-symbols-outlined text-[20px] group-hover:rotate-90 transition-transform duration-300">close</span>
            </button>
        </div>
        <div class="overflow-y-auto p-8 custom-scrollbar">
            <form action="InstructorServlet" method="POST" class="space-y-7">
                <input type="hidden" name="action" value="add">
                
                <div>
                    <h4 class="text-[11px] font-black uppercase tracking-[0.2em] text-slate-900 mb-5 pb-2 border-b border-slate-100">Personal Information</h4>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                        <div class="md:col-span-2 space-y-2">
                            <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider ml-1">Full Name</label>
                            <input type="text" name="fullName" required placeholder="Enter complete legal name" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-4 focus:ring-slate-900/5 focus:border-slate-900 outline-none transition-all text-sm text-slate-900 shadow-sm">
                        </div>
                        <div class="space-y-2">
                            <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider ml-1">Email Address</label>
                            <input type="email" name="email" required placeholder="email@drivepro.com" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-4 focus:ring-slate-900/5 focus:border-slate-900 outline-none transition-all text-sm text-slate-900 shadow-sm">
                        </div>
                        <div class="space-y-2">
                            <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider ml-1">Phone Number</label>
                            <input type="text" name="phone" required placeholder="+94 7X XXX XXXX" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-4 focus:ring-slate-900/5 focus:border-slate-900 outline-none transition-all text-sm text-slate-900 shadow-sm">
                        </div>
                    </div>
                </div>

                <div class="pt-2">
                    <h4 class="text-[11px] font-black uppercase tracking-[0.2em] text-slate-900 mb-5 pb-2 border-b border-slate-100">Expertise & Access</h4>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                        <div class="space-y-2">
                            <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider ml-1">Specialization</label>
                            <select name="licenseType" required class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-4 focus:ring-slate-900/5 focus:border-slate-900 outline-none transition-all text-sm text-slate-900 shadow-sm appearance-none cursor-pointer">
                                <option value="Class B">Class B (Light Vehicle)</option>
                                <option value="Class C">Class C (Heavy Vehicle)</option>
                                <option value="Class A">Class A (Motorcycle)</option>
                            </select>
                        </div>
                        <div class="space-y-2">
                            <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider ml-1">Years of Experience</label>
                            <input type="number" name="experienceYears" required min="0" value="0" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-4 focus:ring-slate-900/5 focus:border-slate-900 outline-none transition-all text-sm text-slate-900 shadow-sm">
                        </div>
                    </div>
                </div>
                
                <div class="pt-2">
                    <h4 class="text-[11px] font-black uppercase tracking-[0.2em] text-slate-900 mb-5 pb-2 border-b border-slate-100">Account Credentials</h4>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                        <div class="space-y-2">
                            <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider ml-1">Username</label>
                            <input type="text" name="username" required placeholder="instructor_id" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-4 focus:ring-slate-900/5 focus:border-slate-900 outline-none transition-all text-sm text-slate-900 shadow-sm">
                        </div>
                        <div class="space-y-2">
                            <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider ml-1">Password</label>
                            <input type="password" name="password" required placeholder="Initial Password" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-4 focus:ring-slate-900/5 focus:border-slate-900 outline-none transition-all text-sm text-slate-900 shadow-sm">
                        </div>
                    </div>
                </div>

                <div class="pt-8 flex items-center gap-3">
                    <button type="button" onclick="document.getElementById('addModal').classList.add('hidden'); document.getElementById('addModal').classList.remove('flex');" class="flex-1 py-3 px-4 text-slate-600 bg-white border border-slate-200 hover:bg-slate-50 rounded-xl text-xs font-bold transition-all btn-press">Dismiss</button>
                    <button type="submit" class="flex-[2] py-3 px-4 bg-slate-900 text-white hover:bg-slate-800 rounded-xl text-xs font-bold shadow-xl shadow-slate-900/20 transition-all btn-press uppercase tracking-widest">Confirm Onboarding</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div id="editModal" class="fixed inset-0 bg-slate-900/40 backdrop-blur-sm hidden items-center justify-center z-50 p-4 transition-all duration-300">
    <div class="bg-white rounded-3xl shadow-[0_20px_50px_rgba(0,0,0,0.2)] w-full max-w-xl flex flex-col max-h-[90vh] border border-slate-200/60 transform scale-95 animate-in overflow-hidden">
        <div class="px-8 py-8 border-b border-slate-100 flex justify-between items-center shrink-0 bg-slate-900 relative overflow-hidden">
            <div class="absolute inset-0 bg-gradient-to-br from-indigo-600/20 to-transparent opacity-50"></div>
            <div class="absolute -right-4 -top-4 w-32 h-32 bg-indigo-500/10 rounded-full blur-3xl"></div>
            
            <div class="relative z-10">
                <div class="flex items-center gap-3 mb-1">
                    <div class="w-10 h-10 bg-white/10 backdrop-blur-md border border-white/20 rounded-xl flex items-center justify-center text-white shadow-inner">
                        <span class="material-symbols-outlined text-[20px]">edit</span>
                    </div>
                    <h3 class="font-bold text-xl text-white tracking-tight">Edit Instructor</h3>
                </div>
                <p class="text-indigo-100/60 text-xs font-medium ml-1">Update teaching credentials and access.</p>
            </div>
            
            <button onclick="document.getElementById('editModal').classList.add('hidden'); document.getElementById('editModal').classList.remove('flex');" class="relative z-10 w-10 h-10 flex items-center justify-center rounded-xl bg-white/10 border border-white/20 text-white hover:bg-white/20 transition-all shadow-sm btn-press group">
                <span class="material-symbols-outlined text-[20px] group-hover:rotate-90 transition-transform duration-300">close</span>
            </button>
        </div>
        <div class="overflow-y-auto p-8 custom-scrollbar">
            <form action="InstructorServlet" method="POST" class="space-y-7">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="instructorId" id="editInstructorId" value="">
                
                <div>
                    <h4 class="text-[11px] font-black uppercase tracking-[0.2em] text-slate-900 mb-5 pb-2 border-b border-slate-100">Personal Information</h4>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                        <div class="md:col-span-2 space-y-2">
                            <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider ml-1">Full Name</label>
                            <input type="text" name="fullName" id="editFullName" required class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-4 focus:ring-slate-900/5 focus:border-slate-900 outline-none transition-all text-sm text-slate-900 shadow-sm">
                        </div>
                        <div class="space-y-2">
                            <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider ml-1">Email Address</label>
                            <input type="email" name="email" id="editEmail" required class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-4 focus:ring-slate-900/5 focus:border-slate-900 outline-none transition-all text-sm text-slate-900 shadow-sm">
                        </div>
                        <div class="space-y-2">
                            <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider ml-1">Phone Number</label>
                            <input type="text" name="phone" id="editPhone" required class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-4 focus:ring-slate-900/5 focus:border-slate-900 outline-none transition-all text-sm text-slate-900 shadow-sm">
                        </div>
                    </div>
                </div>

                <div class="pt-2">
                    <h4 class="text-[11px] font-black uppercase tracking-[0.2em] text-slate-900 mb-5 pb-2 border-b border-slate-100">Expertise</h4>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                        <div class="space-y-2">
                            <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider ml-1">Specialization</label>
                            <select name="licenseType" id="editLicenseType" required class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-4 focus:ring-slate-900/5 focus:border-slate-900 outline-none transition-all text-sm text-slate-900 shadow-sm appearance-none cursor-pointer">
                                <option value="Class B">Class B (Light Vehicle)</option>
                                <option value="Class C">Class C (Heavy Vehicle)</option>
                                <option value="Class A">Class A (Motorcycle)</option>
                            </select>
                        </div>
                        <div class="space-y-2">
                            <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider ml-1">Years of Experience</label>
                            <input type="number" name="experienceYears" id="editExperienceYears" required min="0" value="0" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-4 focus:ring-slate-900/5 focus:border-slate-900 outline-none transition-all text-sm text-slate-900 shadow-sm">
                        </div>
                    </div>
                </div>

                <div class="pt-2">
                    <h4 class="text-[11px] font-black uppercase tracking-[0.2em] text-slate-900 mb-5 pb-2 border-b border-slate-100">Account Credentials</h4>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                        <div class="space-y-2">
                            <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider ml-1">Username</label>
                            <input type="text" name="username" id="editUsername" required class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-4 focus:ring-slate-900/5 focus:border-slate-900 outline-none transition-all text-sm text-slate-900 shadow-sm">
                        </div>
                        <div class="space-y-2">
                            <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider ml-1">Password</label>
                            <input type="password" name="password" id="editPassword" placeholder="Leave blank to keep current" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-4 focus:ring-slate-900/5 focus:border-slate-900 outline-none transition-all text-sm text-slate-900 shadow-sm">
                        </div>
                    </div>
                </div>

                <div class="pt-8 flex items-center gap-3">
                    <button type="button" onclick="document.getElementById('editModal').classList.add('hidden'); document.getElementById('editModal').classList.remove('flex');" class="flex-1 py-3 px-4 text-slate-600 bg-white border border-slate-200 hover:bg-slate-50 rounded-xl text-xs font-bold transition-all btn-press">Dismiss</button>
                    <button type="submit" class="flex-[2] py-3 px-4 bg-slate-900 text-white hover:bg-slate-800 rounded-xl text-xs font-bold shadow-xl shadow-slate-900/20 transition-all btn-press uppercase tracking-widest">Update Instructor</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/motion.js"></script>
<script>
    function openEditModal(id, fullName, email, phone, licenseType, username, experienceYears) {
        document.getElementById('editInstructorId').value = id;
        document.getElementById('editFullName').value = fullName;
        document.getElementById('editEmail').value = email;
        document.getElementById('editPhone').value = phone;
        document.getElementById('editLicenseType').value = licenseType;
        document.getElementById('editExperienceYears').value = experienceYears;
        document.getElementById('editUsername').value = username;
        
        document.getElementById('editModal').classList.remove('hidden');
        document.getElementById('editModal').classList.add('flex');
    }
</script>
<style>
    .custom-scrollbar::-webkit-scrollbar { width: 4px; }
    .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
    .custom-scrollbar::-webkit-scrollbar-thumb { background: #e2e8f0; border-radius: 10px; }
    .animate-in {
        animation: modalIn 0.25s cubic-bezier(0.16, 1, 0.3, 1) forwards;
    }
    @keyframes modalIn {
        from { opacity: 0; transform: scale(0.95) translateY(10px); }
        to { opacity: 1; transform: scale(1) translateY(0); }
    }
</style>
</body>
</html>
