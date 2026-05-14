package com.drivingschool.servlet;

import com.drivingschool.dao.StudentDAO;
import com.drivingschool.model.Student;
import com.drivingschool.util.FileHandler;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                int studentId = Integer.parseInt(idParam);
                boolean success = studentDAO.deleteStudent(studentId);
                if (success) {
                    FileHandler.logActivity("DELETED_STUDENT_ID_" + studentId, (String) session.getAttribute("username"), "ADMIN");
                    response.sendRedirect("manageStudents.jsp?success=Student removed successfully");
                } else {
                    response.sendRedirect("manageStudents.jsp?error=Failed to remove student");
                }
            }
        } else {
            response.sendRedirect("manageStudents.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("update".equals(action)) {
            String idStr = request.getParameter("studentId");
            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect("manageStudents.jsp?error=Missing student ID");
                return;
            }

            Student student = new Student();
            student.setId(idStr);
            student.setFullName(request.getParameter("fullName"));
            student.setNic(request.getParameter("nic"));
            student.setEmail(request.getParameter("email"));
            student.setPhone(request.getParameter("phone"));
            student.setAddress(request.getParameter("address"));
            student.setPermitType(request.getParameter("permitType"));
            student.setUsername(request.getParameter("username"));
            student.setPassword(request.getParameter("password"));

            boolean success = studentDAO.updateStudentAdmin(student);
            if (success) {
                FileHandler.logActivity("UPDATED_STUDENT_PROFILE_" + student.getId(), (String) session.getAttribute("username"), "ADMIN");
                response.sendRedirect("manageStudents.jsp?success=Student profile updated successfully");
            } else {
                response.sendRedirect("manageStudents.jsp?error=Failed to update student profile");
            }
        } else {
            response.sendRedirect("manageStudents.jsp");
        }
    }
}


