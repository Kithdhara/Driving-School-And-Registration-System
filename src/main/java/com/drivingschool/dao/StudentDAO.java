package com.drivingschool.dao;

import com.drivingschool.model.Student;
import com.drivingschool.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * VIVA POINT: Data Access Object (DAO) Pattern.
 * This class encapsulates ALL database operations (CRUD) for Students.
 * It hides the SQL queries from the Servlets.
 */
public class StudentDAO {

        // VIVA POINT: CREATE operation. Takes a Student object (Encapsulation) and inserts it into two tables (users and students).
    public boolean insertStudent(Student student) {
        String insertUserSQL = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
        String insertStudentSQL = "INSERT INTO students (user_id, full_name, nic, phone, email, address, permit_type) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // start transaction

            // 1. Insert into users table
            int userId = -1;
            try (PreparedStatement pstmtUser = conn.prepareStatement(insertUserSQL, Statement.RETURN_GENERATED_KEYS)) {
                pstmtUser.setString(1, student.getUsername());
                pstmtUser.setString(2, student.getPassword());
                pstmtUser.setString(3, student.getRole()); // "STUDENT"
                
                int affectedRows = pstmtUser.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Creating user failed, no rows affected.");
                }

                try (ResultSet generatedKeys = pstmtUser.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        userId = generatedKeys.getInt(1);
                        student.setId(String.valueOf(userId)); // set id locally
                    } else {
                        throw new SQLException("Creating user failed, no ID obtained.");
                    }
                }
            }

            // 2. Insert into students table
            try (PreparedStatement pstmtStudent = conn.prepareStatement(insertStudentSQL)) {
                pstmtStudent.setInt(1, userId);
                pstmtStudent.setString(2, student.getFullName());
                pstmtStudent.setString(3, student.getNic());
                pstmtStudent.setString(4, student.getPhone());
                pstmtStudent.setString(5, student.getEmail());
                pstmtStudent.setString(6, student.getAddress());
                pstmtStudent.setString(7, student.getPermitType());
                
                int affectedRows = pstmtStudent.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Creating student record failed.");
                }
            }

            conn.commit(); // commit transaction
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public Student getStudentByUserId(int userId) {
        String sql = "SELECT * FROM students WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Student s = new Student();
                    s.setId(String.valueOf(rs.getInt("student_id")));
                    s.setFullName(rs.getString("full_name"));
                    s.setNic(rs.getString("nic"));
                    s.setPhone(rs.getString("phone"));
                    s.setEmail(rs.getString("email"));
                    s.setAddress(rs.getString("address"));
                    s.setPermitType(rs.getString("permit_type"));
                    s.setRegistrationDate(rs.getString("registration_date"));
                    return s;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

        // VIVA POINT: READ operation. Returns a Collection (List) of Student objects.
    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM students";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Student s = new Student();
                s.setId(String.valueOf(rs.getInt("student_id")));
                s.setFullName(rs.getString("full_name"));
                s.setNic(rs.getString("nic"));
                s.setPhone(rs.getString("phone"));
                s.setEmail(rs.getString("email"));
                s.setAddress(rs.getString("address"));
                s.setPermitType(rs.getString("permit_type"));
                s.setRegistrationDate(rs.getString("registration_date"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Student getStudentById(int studentId) {
        String sql = "SELECT * FROM students WHERE student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Student s = new Student();
                    s.setId(String.valueOf(rs.getInt("student_id")));
                    s.setFullName(rs.getString("full_name"));
                    s.setNic(rs.getString("nic"));
                    s.setPhone(rs.getString("phone"));
                    s.setEmail(rs.getString("email"));
                    s.setAddress(rs.getString("address"));
                    s.setPermitType(rs.getString("permit_type"));
                    s.setRegistrationDate(rs.getString("registration_date"));
                    return s;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

        // VIVA POINT: UPDATE operation.
    public boolean updateStudent(Student s) {
        String sql = "UPDATE students SET full_name=?, phone=?, email=?, address=?, permit_type=? WHERE student_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, s.getFullName());
            stmt.setString(2, s.getPhone());
            stmt.setString(3, s.getEmail());
            stmt.setString(4, s.getAddress());
            stmt.setString(5, s.getPermitType());
            stmt.setInt(6, Integer.parseInt(s.getId()));
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStudentAdmin(Student s) {
        String getUserIdSql = "SELECT user_id FROM students WHERE student_id = ?";
        String updateStudentSql = "UPDATE students SET full_name=?, nic=?, phone=?, email=?, address=?, permit_type=? WHERE student_id=?";
        String updateUserSql = "UPDATE users SET username=?, password=? WHERE user_id=?";
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            int userId = -1;
            try (PreparedStatement getStmt = conn.prepareStatement(getUserIdSql)) {
                getStmt.setInt(1, Integer.parseInt(s.getId()));
                try (ResultSet rs = getStmt.executeQuery()) {
                    if (rs.next()) {
                        userId = rs.getInt("user_id");
                    }
                }
            }
            
            boolean updated = false;
            if (userId != -1) {
                try (PreparedStatement stmt1 = conn.prepareStatement(updateStudentSql)) {
                    stmt1.setString(1, s.getFullName());
                    stmt1.setString(2, s.getNic());
                    stmt1.setString(3, s.getPhone());
                    stmt1.setString(4, s.getEmail());
                    stmt1.setString(5, s.getAddress());
                    stmt1.setString(6, s.getPermitType());
                    stmt1.setInt(7, Integer.parseInt(s.getId()));
                    int rows = stmt1.executeUpdate();
                    updated = rows > 0;
                }
                
                if (updated && s.getUsername() != null && !s.getUsername().trim().isEmpty()) {
                    try (PreparedStatement stmt2 = conn.prepareStatement(updateUserSql)) {
                        stmt2.setString(1, s.getUsername());
                        stmt2.setString(2, s.getPassword());
                        stmt2.setInt(3, userId);
                        stmt2.executeUpdate();
                    }
                }
            }
            
            conn.commit();
            return updated;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }

        // VIVA POINT: DELETE operation. Also cascades and deletes their related schedules and payments due to DB constraints.
    public boolean deleteStudent(int studentId) {
        String getUserSql = "SELECT user_id FROM students WHERE student_id = ?";
        String getSchedulesSql = "SELECT schedule_id FROM schedules WHERE student_id = ?";
        String deleteSessionReqSql = "DELETE FROM session_requests WHERE schedule_id = ?";
        String deleteSchedulesSql = "DELETE FROM schedules WHERE student_id = ?";
        String deleteStudentSql = "DELETE FROM students WHERE student_id = ?";
        String deleteUserSql = "DELETE FROM users WHERE user_id = ?";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int userId = -1;
            try (PreparedStatement getStmt = conn.prepareStatement(getUserSql)) {
                getStmt.setInt(1, studentId);
                try (ResultSet rs = getStmt.executeQuery()) {
                    if (rs.next()) {
                        userId = rs.getInt("user_id");
                    }
                }
            }

            if (userId != -1) {
                // Delete session requests associated with this student's schedules
                try (PreparedStatement getSchedStmt = conn.prepareStatement(getSchedulesSql)) {
                    getSchedStmt.setInt(1, studentId);
                    try (ResultSet rs = getSchedStmt.executeQuery()) {
                        while (rs.next()) {
                            int schedId = rs.getInt("schedule_id");
                            try (PreparedStatement delReqStmt = conn.prepareStatement(deleteSessionReqSql)) {
                                delReqStmt.setInt(1, schedId);
                                delReqStmt.executeUpdate();
                            }
                        }
                    }
                }

                // Delete schedules
                try (PreparedStatement delSchedStmt = conn.prepareStatement(deleteSchedulesSql)) {
                    delSchedStmt.setInt(1, studentId);
                    delSchedStmt.executeUpdate();
                }

                // Delete student (this cascades to payments and reviews)
                try (PreparedStatement delStudStmt = conn.prepareStatement(deleteStudentSql)) {
                    delStudStmt.setInt(1, studentId);
                    delStudStmt.executeUpdate();
                }

                // Delete user
                try (PreparedStatement delUserStmt = conn.prepareStatement(deleteUserSql)) {
                    delUserStmt.setInt(1, userId);
                    delUserStmt.executeUpdate();
                }

                conn.commit();
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }
}



