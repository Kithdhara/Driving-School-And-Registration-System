package com.drivingschool.servlet;

import com.drivingschool.dao.*;
import com.drivingschool.model.*;
import com.drivingschool.util.FileHandler;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.io.File;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/ProfileServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 5,   // 5 MB
    maxRequestSize = 1024 * 1024 * 10 // 10 MB
)
public class ProfileServlet extends HttpServlet {
    private StudentDAO studentDAO;
    private InstructorDAO instructorDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
        instructorDAO = new InstructorDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String role = (String) session.getAttribute("role");
        int userId = Integer.parseInt((String) session.getAttribute("userId"));

        if ("updateStudent".equals(action)) {
            Student student = studentDAO.getStudentByUserId(userId);
            if (student != null) {
                student.setFullName(request.getParameter("fullName"));
                student.setNic(request.getParameter("nic"));
                student.setPhone(request.getParameter("phone"));
                student.setEmail(request.getParameter("email"));
                student.setAddress(request.getParameter("address"));
                student.setPermitType(request.getParameter("permitType"));

                Part filePart = request.getPart("profilePicture");
                if (filePart != null && filePart.getSize() > 0) {
                    String sourcePath = "D:\\Self Study\\SLIIT\\OOP\\Project\\VMain\\DrivingSchoolSystem\\src\\main\\webapp\\assets\\images\\profiles";
                    String targetPath = getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "images" + File.separator + "profiles";
                    
                    File uploadDirSource = new File(sourcePath);
                    if (!uploadDirSource.exists()) uploadDirSource.mkdirs();
                    File uploadDirTarget = new File(targetPath);
                    if (!uploadDirTarget.exists()) uploadDirTarget.mkdirs();
                    
                    filePart.write(sourcePath + File.separator + userId + ".jpg");
                    try {
                        Files.copy(Paths.get(sourcePath + File.separator + userId + ".jpg"), 
                                   Paths.get(targetPath + File.separator + userId + ".jpg"), 
                                   StandardCopyOption.REPLACE_EXISTING);
                    } catch(Exception ignored) {}
                }

                if (studentDAO.updateStudent(student)) {
                    FileHandler.logProfileUpdate((String) session.getAttribute("username"), role, "Profile Info");
                    response.sendRedirect("studentProfile.jsp?success=Profile+updated+successfully");
                } else {
                    response.sendRedirect("editStudentProfile.jsp?error=Update+failed");
                }
            }

        } else if ("updateInstructor".equals(action)) {
            Instructor instructor = instructorDAO.getInstructorByUserId(userId);
            if (instructor != null) {
                instructor.setFullName(request.getParameter("fullName"));
                instructor.setPhone(request.getParameter("phone"));
                instructor.setEmail(request.getParameter("email"));
                instructor.setLicenseType(request.getParameter("licenseType"));
                // Experience is not updated by the instructor, it stays the same

                Part filePart = request.getPart("profilePicture");
                if (filePart != null && filePart.getSize() > 0) {
                    String sourcePath = "D:\\Self Study\\SLIIT\\OOP\\Project\\VMain\\DrivingSchoolSystem\\src\\main\\webapp\\assets\\images\\profiles";
                    String targetPath = getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "images" + File.separator + "profiles";
                    
                    File uploadDirSource = new File(sourcePath);
                    if (!uploadDirSource.exists()) uploadDirSource.mkdirs();
                    File uploadDirTarget = new File(targetPath);
                    if (!uploadDirTarget.exists()) uploadDirTarget.mkdirs();
                    
                    filePart.write(sourcePath + File.separator + userId + ".jpg");
                    try {
                        Files.copy(Paths.get(sourcePath + File.separator + userId + ".jpg"), 
                                   Paths.get(targetPath + File.separator + userId + ".jpg"), 
                                   StandardCopyOption.REPLACE_EXISTING);
                    } catch(Exception ignored) {}
                }

                if (instructorDAO.updateInstructor(instructor)) {
                    FileHandler.logProfileUpdate((String) session.getAttribute("username"), role, "Profile Info");
                    response.sendRedirect("instructorProfile.jsp?success=Profile+updated+successfully");
                } else {
                    response.sendRedirect("editInstructorProfile.jsp?error=Update+failed");
                }
            }

        } else if ("changePassword".equals(action)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");

            if (userDAO.updatePassword(userId, oldPassword, newPassword)) {
                FileHandler.logProfileUpdate((String) session.getAttribute("username"), role, "Password");
                String redirect = "STUDENT".equals(role) ? "studentProfile.jsp" : 
                                  "INSTRUCTOR".equals(role) ? "instructorProfile.jsp" : "adminSettings.jsp";
                response.sendRedirect(redirect + "?success=Password+changed+successfully");
            } else {
                response.sendRedirect("changePassword.jsp?error=Current+password+is+incorrect");
            }

        } else if ("deleteAccount".equals(action)) {
            boolean deleted = false;
            if ("STUDENT".equals(role)) {
                Student student = studentDAO.getStudentByUserId(userId);
                if (student != null) {
                    deleted = studentDAO.deleteStudent(Integer.parseInt(student.getId()));
                }
            } else if ("INSTRUCTOR".equals(role)) {
                Instructor instructor = instructorDAO.getInstructorByUserId(userId);
                if (instructor != null) {
                    deleted = instructorDAO.deleteInstructor(Integer.parseInt(instructor.getId()));
                }
            }

            if (deleted) {
                FileHandler.logActivity("ACCOUNT_DELETED", (String) session.getAttribute("username"), role);
                session.invalidate();
                response.sendRedirect("login.jsp?success=Account+deleted+successfully");
            } else {
                response.sendRedirect("changePassword.jsp?error=Could+not+delete+account");
            }
        }
    }
}




