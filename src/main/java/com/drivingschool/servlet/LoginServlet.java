package com.drivingschool.servlet;

import com.drivingschool.dao.UserDAO;
import com.drivingschool.model.Person;
import com.drivingschool.util.FileHandler;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
        // VIVA POINT: doPost is used instead of doGet because we are sending sensitive data (passwords) which shouldn't appear in the URL.
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

                // VIVA POINT: Polymorphism & Abstraction. We use the abstract 'Person' class to hold the result, 
        // because the user could be a Student, Instructor, or Admin.
        Person user = userDAO.login(username, password);

        if (user != null) {
                        // VIVA POINT: Session Management. We store the user object in the server's memory 
            // so we know who is logged in across different JSP pages.
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());

            FileHandler.logActivity("LOGIN", user.getUsername(), user.getRole());

                        // VIVA POINT: Routing based on the inherited role of the Person object.
            switch (user.getRole()) {
                case "ADMIN":
                    response.sendRedirect("adminDashboard.jsp");
                    break;
                case "STUDENT":
                    response.sendRedirect("studentDashboard.jsp");
                    break;
                case "INSTRUCTOR":
                    response.sendRedirect("instructorDashboard.jsp");
                    break;
                default:
                    response.sendRedirect("login.jsp?error=InvalidRole");
                    break;
            }
        } else {
            request.setAttribute("error", "Invalid username or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
