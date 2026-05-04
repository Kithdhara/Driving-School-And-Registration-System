package com.drivingschool.servlet;

import com.drivingschool.dao.PaymentDAO;
import com.drivingschool.dao.StudentDAO;
import com.drivingschool.model.Payment;
import com.drivingschool.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private PaymentDAO paymentDAO;
    private StudentDAO studentDAO;

    @Override
    public void init() {
        paymentDAO = new PaymentDAO();
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            int paymentId = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            
            paymentDAO.updatePaymentStatus(paymentId, status);
            response.sendRedirect("manageStudents.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"STUDENT".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        if ("submit".equals(action)) {
            int userId = Integer.parseInt((String) session.getAttribute("userId"));
            
            Student student = studentDAO.getStudentByUserId(userId);
            if (student == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String paymentMethod = request.getParameter("payment_method");
            String sessionType = request.getParameter("session_type");
            String packageType = request.getParameter("package_type");

            // Determine price and sessions based on the selected package
            double amount;
            int sessionsIncluded;
                        // VIVA POINT: Encapsulation & Server-Side Validation.
            // We NEVER trust the client side (JSP) to send the price.
            // We determine the price here on the server using a switch statement to prevent hacking.
            switch (packageType) {
                case "VIP":
                    amount = 35000.00;
                    sessionsIncluded = 10;
                    break;
                case "REFRESHER":
                    amount = 12000.00;
                    sessionsIncluded = 5;
                    break;
                case "INDIVIDUAL":
                default:
                    amount = 25000.00;
                    sessionsIncluded = 10;
                    break;
            }

            Payment payment = new Payment();
            payment.setStudentId(Integer.parseInt(student.getId()));
            payment.setAmount(amount);
            payment.setPaymentMethod(paymentMethod);
            payment.setSessionPreference(sessionType);
            payment.setPackageType(packageType);
            payment.setSessionsIncluded(sessionsIncluded);

                        // VIVA POINT: Calling the DAO to insert the payment into the database.
            // This separates the database logic from the Servlet logic.
            paymentDAO.addPayment(payment);
            response.sendRedirect("sessionAndPayment.jsp");
        }
    }
}

