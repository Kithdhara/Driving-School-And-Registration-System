package com.drivingschool.dao;

import com.drivingschool.model.*;
import com.drivingschool.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    public Person login(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String role = rs.getString("role");
                    int userId = rs.getInt("user_id");
                    
                    Person person = null;
                    switch (role) {
                        case "ADMIN":
                            person = new Admin();
                            break;
                        case "STUDENT":
                            person = new Student();
                            break;
                        case "INSTRUCTOR":
                            person = new Instructor();
                            break;
                    }
                    
                    if (person != null) {
                        person.setId(String.valueOf(userId));
                        person.setUsername(rs.getString("username"));
                    }
                    return person;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePassword(int userId, String oldPassword, String newPassword) {
        String checkSQL = "SELECT password FROM users WHERE user_id = ?";
        String updateSQL = "UPDATE users SET password = ? WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            // Verify old password first
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSQL)) {
                checkStmt.setInt(1, userId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        String currentPassword = rs.getString("password");
                        if (!currentPassword.equals(oldPassword)) {
                            return false; // Old password doesn't match
                        }
                    } else {
                        return false; // User not found
                    }
                }
            }

            // Update to new password
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSQL)) {
                updateStmt.setString(1, newPassword);
                updateStmt.setInt(2, userId);
                return updateStmt.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}

