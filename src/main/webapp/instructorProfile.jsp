<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.drivingschool.dao.*, com.drivingschool.model.*, java.util.*" %>
<%
    String userIdStr = (String) session.getAttribute("userId");
    if (userIdStr == null) { response.sendRedirect("login.jsp"); return; }
    int userId = Integer.parseInt(userIdStr);
    Instructor instructor = new InstructorDAO().getInstructorByUserId(userId);
    request.setAttribute("instructor", instructor);
    if (instructor != null) {
        request.setAttribute("reviews", new ReviewDAO().getReviewsByInstructor(Integer.parseInt(instructor.getId())));
    }
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Instructor Profile | DrivePro Academy</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
                    <a class="font-medium text-slate-500 hover:text-slate-900 h-full flex items-center px-1 text-sm transition-colors" href="instructorDashboard.jsp">Dashboard</a>
                    <a class="font-semibold text-indigo-600 border-b-2 border-indigo-600 h-full flex items-center px-1 text-sm transition-colors" href="instructorProfile.jsp">My Profile</a>
                </nav>
            </div>
            <a href="javascript:void(0)" onclick="confirmLogout()" class="flex items-center gap-2 px-3 py-1.5 bg-slate-100 text-slate-700 font-semibold text-xs rounded-md hover:bg-slate-200 transition-colors btn-press">
                Logout <span class="material-symbols-outlined text-[16px]">logout</span>
            </a>
        </div>
    </header>

    <!-- Profile Hero -->
    <div class="profile-hero">
        <div class="max-w-5xl mx-auto relative z-10 flex flex-col sm:flex-row items-center sm:items-end gap-6">
            <div class="profile-avatar bg-white p-1 relative">
                <div class="absolute inset-1 rounded-full bg-indigo-600 flex items-center justify-center text-white text-4xl font-bold">
                    ${not empty instructor.fullName ? instructor.fullName.substring(0, 1).toUpperCase() : 'I'}
                </div>
                <img src="${pageContext.request.contextPath}/assets/images/profiles/${userId}.jpg?t=<%= System.currentTimeMillis() %>" onerror="this.style.opacity='0';" alt="Profile Picture" class="relative z-10 w-full h-full object-cover rounded-full transition-opacity duration-300">
            </div>
            <div class="text-center sm:text-left">
                <h1 class="text-2xl font-bold text-white tracking-tight">${not empty instructor ? instructor.fullName : sessionScope.username}</h1>
                <p class="text-slate-400 text-sm mt-1">
                    Instructor ID: INS-${not empty instructor ? instructor.id : 'N/A'} &bull; 
                    ${not empty instructor ? instructor.licenseType : 'N/A'} License &bull;
                    ${not empty instructor ? instructor.experienceYears : 0} Years Experience
                </p>
                <c:if test="${not empty reviews}">
                <div class="flex items-center gap-2 mt-2">
                    <div class="star-display">
                        <c:forEach begin="1" end="5" var="i">
                            <c:set var="roundedAvg" value="${avgRating + 0.5}"/>
                            <span class="material-symbols-outlined text-[18px] ${i <= roundedAvg ? 'star-filled' : 'star-empty'}">star</span>
                        </c:forEach>
                    </div>
                    <span class="text-sm text-white/80 font-semibold"><fmt:formatNumber value="${avgRating}" pattern="0.0"/></span>
                    <span class="text-xs text-slate-400">(${reviews.size()} reviews)</span>
                </div>
                </c:if>
            </div>
            <div class="sm:ml-auto flex gap-2">
                <a href="editInstructorProfile.jsp" class="px-4 py-2 bg-white/10 backdrop-blur-md text-white text-xs font-semibold rounded-lg border border-white/20 hover:bg-white/20 transition-colors btn-press flex items-center gap-1.5">
                    <span class="material-symbols-outlined text-[16px]">edit</span> Edit Profile
                </a>
            </div>
        </div>
    </div>

    <!-- Tabs -->
    <div class="tab-bar max-w-5xl mx-auto px-6 lg:px-0">
        <button class="tab-btn active" data-tab="info"><span class="material-symbols-outlined text-[18px]">person</span> Info</button>
        <button class="tab-btn" data-tab="schedule"><span class="material-symbols-outlined text-[18px]">calendar_month</span> Schedule</button>
        <button class="tab-btn" data-tab="reviews"><span class="material-symbols-outlined text-[18px]">reviews</span> Reviews (${reviews.size()})</button>
        <button class="tab-btn" data-tab="settings"><span class="material-symbols-outlined text-[18px]">settings</span> Settings</button>
    </div>

    <main class="max-w-5xl mx-auto px-6 lg:px-0 py-8">
        
        <!-- Info Tab -->
        <div id="panel-info" class="tab-panel active">
            <div class="bg-white rounded-2xl p-8 shadow-premium border border-slate-200">
                <h2 class="text-lg font-bold text-slate-900 mb-6 flex items-center gap-2">
                    <span class="material-symbols-outlined text-indigo-600 text-[20px]">badge</span> Professional Information
                </h2>
                <c:if test="${not empty instructor}">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="space-y-1">
                        <span class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Full Name</span>
                        <p class="text-sm font-semibold text-slate-900">${instructor.fullName}</p>
                    </div>
                    <div class="space-y-1">
                        <span class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">License Type</span>
                        <span class="inline-flex px-3 py-1 bg-indigo-50 text-indigo-700 text-xs font-bold rounded-md border border-indigo-100">${instructor.licenseType}</span>
                    </div>
                    <div class="space-y-1">
                        <span class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Email</span>
                        <p class="text-sm font-semibold text-slate-900">${instructor.email}</p>
                    </div>
                    <div class="space-y-1">
                        <span class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Phone</span>
                        <p class="text-sm font-semibold text-slate-900">${instructor.phone}</p>
                    </div>
                    <div class="space-y-1">
                        <span class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Experience</span>
                        <p class="text-sm font-semibold text-slate-900">${instructor.experienceYears} Years</p>
                    </div>
                    <div class="space-y-1">
                        <span class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Active Students</span>
                        <p class="text-sm font-semibold text-slate-900">${schedules.size()} assigned sessions</p>
                    </div>
                </div>
                </c:if>
            </div>
        </div>

        <!-- Schedule Tab -->
        <div id="panel-schedule" class="tab-panel">
            <div class="bg-white rounded-2xl shadow-premium border border-slate-200 overflow-hidden">
                <div class="px-6 py-4 border-b border-slate-100 flex justify-between items-center">
                    <h2 class="text-sm font-bold text-slate-900">My Schedule</h2>
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-widest">${schedules.size()} Sessions</span>
                </div>
                <c:if test="${empty schedules}">
                <div class="empty-state m-6">
                    <span class="material-symbols-outlined empty-icon">event_busy</span>
                    <h3>No Sessions Assigned</h3>
                    <p>You don't have any upcoming sessions. New sessions will appear here once assigned by admin.</p>
                </div>
                </c:if>
                <c:if test="${not empty schedules}">
                <div class="divide-y divide-slate-100">
                    <c:forEach items="${schedules}" var="sc">
                        <c:set var="dateParts" value="${fn:split(sc.sessionDate, '-')}" />
                    <div class="px-6 py-4 flex items-center gap-4 hover:bg-slate-50 transition-colors">
                        <div class="w-12 h-12 bg-indigo-50 rounded-xl flex flex-col items-center justify-center text-indigo-600 border border-indigo-100/50">
                            <span class="text-[9px] font-black uppercase tracking-tighter leading-none mb-0.5">${dateParts[1]}</span>
                            <span class="text-lg font-black leading-none tracking-tighter">${dateParts[2]}</span>
                        </div>
                        <div class="flex-1">
                            <p class="text-sm font-bold text-slate-900">${sc.studentName}</p>
                            <p class="text-xs text-slate-500 font-medium">${sc.sessionTime}</p>
                        </div>
                        <span class="px-2.5 py-1 rounded-md text-[10px] font-bold uppercase tracking-wider ${sc.status == 'COMPLETED' ? 'bg-emerald-50 text-emerald-700 border border-emerald-200' : sc.status == 'SCHEDULED' ? 'bg-blue-50 text-blue-700 border border-blue-200' : 'bg-amber-50 text-amber-700 border border-amber-200'}">
                            ${sc.status}
                        </span>
                    </div>
                    </c:forEach>
                </div>
                </c:if>
            </div>
        </div>

        <!-- Reviews Tab -->
        <div id="panel-reviews" class="tab-panel">
            <div class="bg-white rounded-2xl shadow-premium border border-slate-200 overflow-hidden">
                <div class="px-6 py-4 border-b border-slate-100 flex justify-between items-center">
                    <h2 class="text-sm font-bold text-slate-900">Student Reviews</h2>
                    <c:if test="${not empty reviews}">
                    <div class="flex items-center gap-2">
                        <div class="star-display">
                            <c:forEach begin="1" end="5" var="i">
                                <c:set var="roundedAvg" value="${avgRating + 0.5}"/>
                                <span class="material-symbols-outlined text-[14px] ${i <= roundedAvg ? 'star-filled' : 'star-empty'}">star</span>
                            </c:forEach>
                        </div>
                        <span class="text-xs font-bold text-slate-900"><fmt:formatNumber value="${avgRating}" pattern="0.0"/></span>
                    </div>
                    </c:if>
                </div>
                <c:if test="${empty reviews}">
                <div class="empty-state m-6">
                    <span class="material-symbols-outlined empty-icon">rate_review</span>
                    <h3>No Reviews Yet</h3>
                    <p>Students will be able to review you after completing their lessons.</p>
                </div>
                </c:if>
                <c:if test="${not empty reviews}">
                <div class="divide-y divide-slate-100">
                    <c:forEach items="${reviews}" var="r">
                    <div class="px-6 py-5">
                        <div class="flex items-center gap-3 mb-2">
                            <div class="w-8 h-8 bg-slate-100 rounded-full flex items-center justify-center">
                                <span class="material-symbols-outlined text-[16px] text-slate-500">person</span>
                            </div>
                            <div>
                                <p class="text-sm font-bold text-slate-900">${r.studentName}</p>
                                <p class="text-[11px] text-slate-400 font-medium">${r.reviewDate}</p>
                            </div>
                            <div class="ml-auto star-display">
                                <c:forEach begin="1" end="5" var="i">
                                <span class="material-symbols-outlined text-[14px] ${i <= r.rating ? 'star-filled' : 'star-empty'}">star</span>
                                </c:forEach>
                            </div>
                        </div>
                        <p class="text-sm text-slate-600 leading-relaxed pl-11">${r.comment}</p>
                    </div>
                    </c:forEach>
                </div>
                </c:if>
            </div>
        </div>

        <!-- Settings Tab -->
        <div id="panel-settings" class="tab-panel">
            <div class="space-y-6">
                <div class="bg-white rounded-2xl p-8 shadow-premium border border-slate-200">
                    <h2 class="text-lg font-bold text-slate-900 mb-2 flex items-center gap-2">
                        <span class="material-symbols-outlined text-indigo-600 text-[20px]">lock</span> Change Password
                    </h2>
                    <p class="text-slate-500 text-sm mb-6">Use a strong password with letters, numbers, and symbols.</p>
                    
                    <div class="mt-4">
                        <a href="changePassword.jsp" class="inline-flex items-center gap-2 px-6 py-2.5 bg-slate-900 text-white text-sm font-semibold rounded-lg hover:bg-slate-800 transition-colors btn-press shadow-sm">
                            <span class="material-symbols-outlined text-[18px]">lock_reset</span> Go to Password Settings
                        </a>
                    </div>
                </div>

                <div class="danger-zone">
                    <h3 class="text-sm mb-2"><span class="material-symbols-outlined text-[18px]">warning</span> Danger Zone</h3>
                    <p class="text-sm text-slate-500 mb-4">Permanently delete your account and all associated data.</p>
                    <form id="deleteAccountForm" action="ProfileServlet" method="POST">
                        <input type="hidden" name="action" value="deleteAccount">
                        <button type="button" onclick="confirmDeleteAccount('deleteAccountForm')" class="px-4 py-2 bg-red-600 text-white text-xs font-semibold rounded-lg hover:bg-red-700 transition-colors btn-press">
                            Delete My Account
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/assets/js/motion.js"></script>
    <script>
        function validatePasswordChange() {
            let isValid = true;
            return isValid;
        }
    </script>
</body>
</html>
