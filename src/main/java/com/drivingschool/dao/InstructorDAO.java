package com.drivingschool.dao;

import com.drivingschool.model.Instructor;
import com.drivingschool.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InstructorDAO {

    public boolean addInstructor(Instructor instructor) {
        String insertUserSQL = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
        String insertInstSQL = "INSERT INTO instructors (user_id, full_name, phone, email, license_type, experience_years) VALUES (?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int userId = -1;
            try (PreparedStatement pstmtUser = conn.prepareStatement(insertUserSQL, Statement.RETURN_GENERATED_KEYS)) {
                pstmtUser.setString(1, instructor.getUsername());
                pstmtUser.setString(2, instructor.getPassword());
                pstmtUser.setString(3, instructor.getRole());

                pstmtUser.executeUpdate();
                try (ResultSet generatedKeys = pstmtUser.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        userId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Creating user failed, no ID obtained.");
                    }
                }
            }

            try (PreparedStatement pstmtInst = conn.prepareStatement(insertInstSQL)) {
                pstmtInst.setInt(1, userId);
                pstmtInst.setString(2, instructor.getFullName());
                pstmtInst.setString(3, instructor.getPhone());
                pstmtInst.setString(4, instructor.getEmail());
                pstmtInst.setString(5, instructor.getLicenseType());
                pstmtInst.setInt(6, instructor.getExperienceYears());

                pstmtInst.executeUpdate();
            }

            conn.commit();
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

    public List<Instructor> getAllInstructors() {
        List<Instructor> list = new ArrayList<>();
        String sql = "SELECT i.*, u.username FROM instructors i JOIN users u ON i.user_id = u.user_id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Instructor inst = new Instructor();
                inst.setId(String.valueOf(rs.getInt("instructor_id")));
                inst.setFullName(rs.getString("full_name"));
                inst.setPhone(rs.getString("phone"));
                inst.setEmail(rs.getString("email"));
                inst.setLicenseType(rs.getString("license_type"));
                inst.setExperienceYears(rs.getInt("experience_years"));
                inst.setUsername(rs.getString("username"));
                list.add(inst);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Instructor getInstructorByUserId(int userId) {
        String sql = "SELECT i.*, u.username FROM instructors i JOIN users u ON i.user_id = u.user_id WHERE i.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Instructor inst = new Instructor();
                    inst.setId(String.valueOf(rs.getInt("instructor_id")));
                    inst.setFullName(rs.getString("full_name"));
                    inst.setPhone(rs.getString("phone"));
                    inst.setEmail(rs.getString("email"));
                    inst.setLicenseType(rs.getString("license_type"));
                    inst.setExperienceYears(rs.getInt("experience_years"));
                    inst.setUsername(rs.getString("username"));
                    return inst;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteInstructor(int instructorId) {
        String getUserIdSQL = "SELECT user_id FROM instructors WHERE instructor_id = ?";
        String getSchedulesSql = "SELECT schedule_id FROM schedules WHERE instructor_id = ?";
        String deleteSessionReqSql = "DELETE FROM session_requests WHERE schedule_id = ?";
        String deleteSchedulesSql = "DELETE FROM schedules WHERE instructor_id = ?";
        String deleteInstSQL = "DELETE FROM instructors WHERE instructor_id = ?";
        String deleteUserSQL = "DELETE FROM users WHERE user_id = ?";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int userId = -1;
            try (PreparedStatement stmt = conn.prepareStatement(getUserIdSQL)) {
                stmt.setInt(1, instructorId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        userId = rs.getInt("user_id");
                    }
                }
            }

            if (userId != -1) {
                // Delete session requests associated with this instructor's schedules
                try (PreparedStatement getSchedStmt = conn.prepareStatement(getSchedulesSql)) {
                    getSchedStmt.setInt(1, instructorId);
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
                    delSchedStmt.setInt(1, instructorId);
                    delSchedStmt.executeUpdate();
                }

                // Delete instructor (cascades to reviews)
                try (PreparedStatement stmt = conn.prepareStatement(deleteInstSQL)) {
                    stmt.setInt(1, instructorId);
                    stmt.executeUpdate();
                }
                
                // Delete user
                try (PreparedStatement stmt = conn.prepareStatement(deleteUserSQL)) {
                    stmt.setInt(1, userId);
                    stmt.executeUpdate();
                }
            }

            conn.commit();
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

    public boolean updateInstructor(Instructor i) {
        String getUserIdSql = "SELECT user_id FROM instructors WHERE instructor_id = ?";
        String updateInstSql = "UPDATE instructors SET full_name=?, phone=?, email=?, license_type=?, experience_years=? WHERE instructor_id=?";
        String updateUserSql = "UPDATE users SET username=?, password=? WHERE user_id=?";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int userId = -1;
            try (PreparedStatement getStmt = conn.prepareStatement(getUserIdSql)) {
                getStmt.setInt(1, Integer.parseInt(i.getId()));
                try (ResultSet rs = getStmt.executeQuery()) {
                    if (rs.next()) {
                        userId = rs.getInt("user_id");
                    }
                }
            }

            boolean updated = false;
            if (userId != -1) {
                try (PreparedStatement stmt1 = conn.prepareStatement(updateInstSql)) {
                    stmt1.setString(1, i.getFullName());
                    stmt1.setString(2, i.getPhone());
                    stmt1.setString(3, i.getEmail());
                    stmt1.setString(4, i.getLicenseType());
                    stmt1.setInt(5, i.getExperienceYears());
                    stmt1.setInt(6, Integer.parseInt(i.getId()));
                    int rows = stmt1.executeUpdate();
                    updated = rows > 0;
                }

                if (updated && i.getUsername() != null && !i.getUsername().trim().isEmpty()) {
                    try (PreparedStatement stmt2 = conn.prepareStatement(updateUserSql)) {
                        stmt2.setString(1, i.getUsername());
                        stmt2.setString(2, i.getPassword());
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
}



