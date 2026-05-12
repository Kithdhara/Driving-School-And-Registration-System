package com.drivingschool.servlet;

import com.drivingschool.dao.ReviewDAO;
import com.drivingschool.dao.StudentDAO;
import com.drivingschool.model.Review;
import com.drivingschool.model.Student;
import com.drivingschool.util.FileHandler;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/ReviewServlet")
public class ReviewServlet extends HttpServlet {
    private ReviewDAO reviewDAO;
    private StudentDAO studentDAO;

    @Override
    public void init() {
        reviewDAO = new ReviewDAO();
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"STUDENT".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            int userId = Integer.parseInt((String) session.getAttribute("userId"));
            Student student = studentDAO.getStudentByUserId(userId);

            if (student == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            int instructorId = Integer.parseInt(request.getParameter("instructorId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            // Validation
            if (rating < 1 || rating > 5) {
                response.sendRedirect("addReview.jsp?error=Rating+must+be+between+1+and+5");
                return;
            }
            if (comment == null || comment.trim().isEmpty()) {
                response.sendRedirect("addReview.jsp?error=Please+write+a+comment");
                return;
            }

            Review review = new Review();
            review.setStudentId(Integer.parseInt(student.getId()));
            review.setInstructorId(instructorId);
            review.setRating(rating);
            review.setComment(comment.trim());

            if (reviewDAO.addReview(review)) {
                FileHandler.logReview(student.getFullName(), "InstructorID:" + instructorId, rating);
                response.sendRedirect("addReview.jsp?success=Review+submitted+successfully");
            } else {
                response.sendRedirect("addReview.jsp?error=Failed+to+submit+review");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
                response.sendRedirect("login.jsp");
                return;
            }

            int reviewId = Integer.parseInt(request.getParameter("id"));
            reviewDAO.deleteReview(reviewId);

            String role = (String) session.getAttribute("role");
            if ("ADMIN".equals(role)) {
                response.sendRedirect("manageReviews.jsp?success=Review+deleted");
            } else {
                response.sendRedirect("addReview.jsp?success=Review+deleted");
            }
        }
    }
}


