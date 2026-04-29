package com.drivingschool.dao;

import com.drivingschool.model.Review;
import com.drivingschool.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    public boolean addReview(Review review) {
        String sql = "INSERT INTO reviews (student_id, instructor_id, rating, comment) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, review.getStudentId());
            stmt.setInt(2, review.getInstructorId());
            stmt.setInt(3, review.getRating());
            stmt.setString(4, review.getComment());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Review> getReviewsByInstructor(int instructorId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, s.full_name as student_name, i.full_name as instructor_name " +
                     "FROM reviews r " +
                     "JOIN students s ON r.student_id = s.student_id " +
                     "JOIN instructors i ON r.instructor_id = i.instructor_id " +
                     "WHERE r.instructor_id = ? ORDER BY r.review_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, instructorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Review> getAllReviews() {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, s.full_name as student_name, i.full_name as instructor_name " +
                     "FROM reviews r " +
                     "JOIN students s ON r.student_id = s.student_id " +
                     "JOIN instructors i ON r.instructor_id = i.instructor_id " +
                     "ORDER BY r.review_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteReview(int reviewId) {
        String sql = "DELETE FROM reviews WHERE review_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reviewId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Review mapRow(ResultSet rs) throws SQLException {
        Review r = new Review();
        r.setReviewId(rs.getInt("review_id"));
        r.setStudentId(rs.getInt("student_id"));
        r.setInstructorId(rs.getInt("instructor_id"));
        r.setRating(rs.getInt("rating"));
        r.setComment(rs.getString("comment"));
        r.setReviewDate(rs.getString("review_date"));
        r.setStudentName(rs.getString("student_name"));
        r.setInstructorName(rs.getString("instructor_name"));
        return r;
    }
}

