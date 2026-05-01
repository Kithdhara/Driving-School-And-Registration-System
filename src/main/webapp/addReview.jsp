<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.drivingschool.dao.*, com.drivingschool.model.*, java.util.*" %>
<%
    String userIdStr = (String) session.getAttribute("userId");
    if (userIdStr == null) { response.sendRedirect("login.jsp"); return; }
    int userId = Integer.parseInt(userIdStr);
    request.setAttribute("student", new StudentDAO().getStudentByUserId(userId));
    request.setAttribute("instructors", new InstructorDAO().getAllInstructors());
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Write Review | DrivePro Academy</title>
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
                    <a class="font-medium text-slate-500 hover:text-slate-900 h-full flex items-center px-1 text-sm transition-colors" href="studentProfile.jsp">My Profile</a>
                    <a class="font-semibold text-indigo-600 border-b-2 border-indigo-600 h-full flex items-center px-1 text-sm transition-colors" href="addReview.jsp">Write Review</a>
                </nav>
            </div>
            <div class="flex items-center gap-4">
                <a href="studentProfile.jsp" class="h-8 w-8 rounded-full bg-indigo-600 relative cursor-pointer shadow-sm ring-2 ring-transparent hover:ring-indigo-200 transition-all block">
                    <div class="absolute inset-0 rounded-full flex items-center justify-center text-white text-xs font-bold">
                        ${not empty student.fullName ? student.fullName.substring(0,1).toUpperCase() : 'S'}
                    </div>
                    <img src="${pageContext.request.contextPath}/assets/images/profiles/${userId}.jpg?t=<%= System.currentTimeMillis() %>" onerror="this.style.opacity='0';" class="relative z-10 w-full h-full object-cover rounded-full transition-opacity duration-300">
                </a>
                <a href="javascript:void(0)" onclick="confirmLogout()" class="flex items-center gap-2 px-3 py-1.5 bg-slate-100 text-slate-700 font-semibold text-xs rounded-md hover:bg-slate-200 transition-colors btn-press">
                    Logout <span class="material-symbols-outlined text-[16px]">logout</span>
                </a>
            </div>
        </div>
    </header>

    <main class="max-w-2xl mx-auto px-6 py-10">
        <div class="mb-8 motion-pop motion-visible">
            <h1 class="text-2xl font-bold text-slate-900 tracking-tight mb-1">Rate Your Instructor</h1>
            <p class="text-slate-500 text-sm">Share your experience to help us improve our training quality.</p>
        </div>

        <form action="ReviewServlet" method="POST" onsubmit="return validateReview()" id="reviewForm" class="bg-white rounded-2xl p-8 shadow-premium border border-slate-200 space-y-6 motion-pop motion-visible">
            <input type="hidden" name="action" value="add">

            <div class="space-y-1.5">
                <label class="block text-sm font-semibold text-slate-700">Select Instructor</label>
                <select name="instructorId" id="instructorId" class="w-full px-3.5 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-slate-900 text-sm shadow-sm" required>
                    <option value="">Choose an instructor...</option>
                    <c:forEach items="${instructors}" var="ins">
                    <option value="${ins.id}">${ins.fullName} — ${ins.licenseType}</option>
                    </c:forEach>
                </select>
                <div id="instructorIdError" class="error-message"></div>
            </div>

            <div class="space-y-1.5">
                <label class="block text-sm font-semibold text-slate-700 mb-2">Your Rating</label>
                <div class="star-rating">
                    <input type="radio" name="rating" value="5" id="star5"><label for="star5"><span class="material-symbols-outlined">star</span></label>
                    <input type="radio" name="rating" value="4" id="star4"><label for="star4"><span class="material-symbols-outlined">star</span></label>
                    <input type="radio" name="rating" value="3" id="star3"><label for="star3"><span class="material-symbols-outlined">star</span></label>
                    <input type="radio" name="rating" value="2" id="star2"><label for="star2"><span class="material-symbols-outlined">star</span></label>
                    <input type="radio" name="rating" value="1" id="star1"><label for="star1"><span class="material-symbols-outlined">star</span></label>
                </div>
                <div id="ratingError" class="error-message"></div>
            </div>

            <div class="space-y-1.5">
                <label class="block text-sm font-semibold text-slate-700">Your Review</label>
                <textarea class="w-full px-3.5 py-2.5 bg-white border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 outline-none transition-all text-slate-900 text-sm shadow-sm resize-none" id="comment" name="comment" rows="4" placeholder="Share your experience with this instructor..." required></textarea>
                <div id="commentError" class="error-message"></div>
                <p class="text-xs text-slate-400 mt-1">Maximum 500 characters</p>
            </div>

            <button type="submit" class="w-full py-3 bg-slate-900 text-white text-sm font-semibold rounded-lg hover:bg-slate-800 transition-colors btn-press shadow-sm flex items-center justify-center gap-2">
                <span class="material-symbols-outlined text-[16px]">rate_review</span> Submit Review
            </button>
        </form>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/js/motion.js"></script>
    <script>
        function validateReview() {
            let isValid = true;
            return isValid;
        }
    </script>
</body>
</html>


