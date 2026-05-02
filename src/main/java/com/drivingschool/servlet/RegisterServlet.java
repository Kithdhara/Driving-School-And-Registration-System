package com.drivingschool.servlet;

import com.drivingschool.dao.StudentDAO;
import com.drivingschool.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("fullname");
        String nic = request.getParameter("nic");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String permitType = request.getParameter("permit_type");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Student student = new Student();
        student.setFullName(fullName);
        student.setNic(nic);
        student.setPhone(phone);
        student.setEmail(email);
        student.setAddress(address);
        student.setPermitType(permitType);
        student.setUsername(username);
        student.setPassword(password);

        boolean isRegistered = studentDAO.insertStudent(student);

        if (isRegistered) {
            response.sendRedirect("login.jsp?success=Registration+successful!+Please+login.");
        } else {
            response.sendRedirect("register.jsp?error=Registration+failed.+Please+try+again+or+check+server+logs.");
        }
    }
}

