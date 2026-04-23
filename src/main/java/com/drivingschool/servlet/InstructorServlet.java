package com.drivingschool.servlet;

import com.drivingschool.dao.InstructorDAO;
import com.drivingschool.model.Instructor;
import com.drivingschool.util.FileHandler;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import jakarta.servlet.http.HttpSession;

@WebServlet("/InstructorServlet")
public class InstructorServlet extends HttpServlet {
    private InstructorDAO instructorDAO;

    @Override
    public void init() {
        instructorDAO = new InstructorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            instructorDAO.deleteInstructor(id);
            response.sendRedirect("manageInstructors.jsp");
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

        if ("add".equals(action)) {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String licenseType = request.getParameter("licenseType");
            int exp = Integer.parseInt(request.getParameter("experienceYears"));
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            Instructor inst = new Instructor();
            inst.setFullName(fullName);
            inst.setPhone(phone);
            inst.setEmail(email);
            inst.setLicenseType(licenseType);
            inst.setExperienceYears(exp);
            inst.setUsername(username);
            inst.setPassword(password);

            if (instructorDAO.addInstructor(inst)) {
                FileHandler.saveInstructorCredentials(fullName, username, password);
            }
            response.sendRedirect("manageInstructors.jsp");
        } else if ("update".equals(action)) {
            String id = request.getParameter("instructorId");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String licenseType = request.getParameter("licenseType");
            String experienceYears = request.getParameter("experienceYears");
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            Instructor inst = new Instructor();
            inst.setId(id);
            inst.setFullName(fullName);
            inst.setPhone(phone);
            inst.setEmail(email);
            inst.setLicenseType(licenseType);
            if (experienceYears != null && !experienceYears.trim().isEmpty()) {
                inst.setExperienceYears(Integer.parseInt(experienceYears));
            }
            inst.setUsername(username);
            inst.setPassword(password);

            instructorDAO.updateInstructor(inst);
            response.sendRedirect("manageInstructors.jsp?success=Instructor+updated");
        }
    }
}




