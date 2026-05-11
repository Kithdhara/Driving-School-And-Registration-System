package com.drivingschool.servlet;

import com.drivingschool.dao.ScheduleDAO;
import com.drivingschool.model.Schedule;
import com.drivingschool.util.FileHandler;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ScheduleServlet")
public class ScheduleServlet extends HttpServlet {
    private ScheduleDAO scheduleDAO;

    @Override
    public void init() {
        scheduleDAO = new ScheduleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role) && !"INSTRUCTOR".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            int scheduleId = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            
            scheduleDAO.updateScheduleStatus(scheduleId, status);
            FileHandler.logActivity("SCHEDULE_STATUS_" + status, "Schedule_" + scheduleId, "SYSTEM");

            String referer = request.getHeader("referer");
            if (referer != null && referer.contains("manageSessions")) {
                response.sendRedirect("manageSessions.jsp");
            } else if (referer != null && referer.contains("sessionRequests")) {
                response.sendRedirect("sessionRequests.jsp");
            } else {
                response.sendRedirect("manageSchedules.jsp");
            }
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
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            int instructorId = Integer.parseInt(request.getParameter("instructorId"));
            String sessionDate = request.getParameter("sessionDate");
            String sessionTime = request.getParameter("sessionTime");

            Schedule schedule = new Schedule();
            schedule.setStudentId(studentId);
            schedule.setInstructorId(instructorId);
            schedule.setSessionDate(sessionDate);
            schedule.setSessionTime(sessionTime);

            scheduleDAO.addSchedule(schedule);
            FileHandler.logActivity("NEW_SESSION_ASSIGNED", "Student_" + studentId, "ADMIN");
            
            response.sendRedirect("manageSchedules.jsp");
        }
    }
}


