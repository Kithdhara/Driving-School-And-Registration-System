package com.drivingschool.dao;

import com.drivingschool.model.Payment;
import com.drivingschool.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {
    public boolean addPayment(Payment payment) {
        String sql = "INSERT INTO payments (student_id, amount, payment_date, payment_method, session_preference, package_type, sessions_included, payment_status) VALUES (?, ?, CURRENT_DATE, ?, ?, ?, ?, 'PENDING')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, payment.getStudentId());
            stmt.setDouble(2, payment.getAmount());
            stmt.setString(3, payment.getPaymentMethod());
            stmt.setString(4, payment.getSessionPreference());
            stmt.setString(5, payment.getPackageType());
            stmt.setInt(6, payment.getSessionsIncluded());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Payment> getAllPayments() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, s.full_name FROM payments p JOIN students s ON p.student_id = s.student_id ORDER BY p.payment_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setStudentId(rs.getInt("student_id"));
                p.setAmount(rs.getDouble("amount"));
                p.setPaymentMethod(rs.getString("payment_method"));
                p.setPaymentStatus(rs.getString("payment_status"));
                p.setPaymentDate(rs.getString("payment_date"));
                p.setSessionPreference(rs.getString("session_preference"));
                p.setStudentName(rs.getString("full_name"));
                try { p.setPackageType(rs.getString("package_type")); } catch (SQLException ignored) {}
                try { p.setSessionsIncluded(rs.getInt("sessions_included")); } catch (SQLException ignored) {}
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public Payment getPaymentByStudentId(int studentId) {
        String sql = "SELECT p.*, s.full_name FROM payments p JOIN students s ON p.student_id = s.student_id WHERE p.student_id = ? ORDER BY p.payment_date DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Payment p = new Payment();
                    p.setPaymentId(rs.getInt("payment_id"));
                    p.setStudentId(rs.getInt("student_id"));
                    p.setAmount(rs.getDouble("amount"));
                    p.setPaymentMethod(rs.getString("payment_method"));
                    p.setPaymentStatus(rs.getString("payment_status"));
                    p.setPaymentDate(rs.getString("payment_date"));
                    p.setSessionPreference(rs.getString("session_preference"));
                    p.setStudentName(rs.getString("full_name"));
                    try { p.setPackageType(rs.getString("package_type")); } catch (SQLException ignored) {}
                    try { p.setSessionsIncluded(rs.getInt("sessions_included")); } catch (SQLException ignored) {}
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePaymentStatus(int paymentId, String status) {
        String sql = "UPDATE payments SET payment_status = ? WHERE payment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, paymentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Payment> getPaymentsByStudentId(int studentId) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, s.full_name FROM payments p JOIN students s ON p.student_id = s.student_id WHERE p.student_id = ? ORDER BY p.payment_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Payment p = new Payment();
                    p.setPaymentId(rs.getInt("payment_id"));
                    p.setStudentId(rs.getInt("student_id"));
                    p.setAmount(rs.getDouble("amount"));
                    p.setPaymentMethod(rs.getString("payment_method"));
                    p.setPaymentStatus(rs.getString("payment_status"));
                    p.setPaymentDate(rs.getString("payment_date"));
                    p.setSessionPreference(rs.getString("session_preference"));
                    p.setStudentName(rs.getString("full_name"));
                    try { p.setPackageType(rs.getString("package_type")); } catch (SQLException ignored) {}
                    try { p.setSessionsIncluded(rs.getInt("sessions_included")); } catch (SQLException ignored) {}
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalSessionCredits(int studentId) {
        int total = 0;
        String sql = "SELECT COALESCE(SUM(sessions_included), 0) as total FROM payments WHERE student_id = ? AND payment_status = 'CONFIRMED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            // Column may not exist yet — return 0
        }
        return total;
    }
}


