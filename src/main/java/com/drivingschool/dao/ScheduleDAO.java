package com.drivingschool.dao;

import com.drivingschool.model.Schedule;
import com.drivingschool.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ScheduleDAO {

    public boolean addSchedule(Schedule schedule) {
        String sql = "INSERT INTO schedules (student_id, instructor_id, lesson_date, lesson_time, status) VALUES (?, ?, ?, ?, 'SCHEDULED')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, schedule.getStudentId());
            stmt.setInt(2, schedule.getInstructorId());
            stmt.setString(3, schedule.getSessionDate());
            stmt.setString(4, schedule.getSessionTime());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Schedule> getAllSchedules() {
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT sc.*, s.full_name as student_name, i.full_name as instructor_name " +
                     "FROM schedules sc " +
                     "JOIN students s ON sc.student_id = s.student_id " +
                     "JOIN instructors i ON sc.instructor_id = i.instructor_id " +
                     "ORDER BY sc.lesson_date, sc.lesson_time";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Schedule sc = new Schedule();
                sc.setScheduleId(rs.getInt("schedule_id"));
                sc.setStudentId(rs.getInt("student_id"));
                sc.setInstructorId(rs.getInt("instructor_id"));
                sc.setSessionDate(rs.getString("lesson_date"));
                sc.setSessionTime(rs.getString("lesson_time"));
                sc.setStatus(rs.getString("status"));
                sc.setStudentName(rs.getString("student_name"));
                sc.setInstructorName(rs.getString("instructor_name"));
                list.add(sc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Schedule> getSchedulesByInstructor(int instructorId) {
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT sc.*, s.full_name as student_name, i.full_name as instructor_name " +
                     "FROM schedules sc " +
                     "JOIN students s ON sc.student_id = s.student_id " +
                     "JOIN instructors i ON sc.instructor_id = i.instructor_id " +
                     "WHERE sc.instructor_id = ? " +
                     "ORDER BY sc.lesson_date, sc.lesson_time";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, instructorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Schedule sc = new Schedule();
                    sc.setScheduleId(rs.getInt("schedule_id"));
                    sc.setStudentId(rs.getInt("student_id"));
                    sc.setInstructorId(rs.getInt("instructor_id"));
                    sc.setSessionDate(rs.getString("lesson_date"));
                    sc.setSessionTime(rs.getString("lesson_time"));
                    sc.setStatus(rs.getString("status"));
                    sc.setStudentName(rs.getString("student_name"));
                    sc.setInstructorName(rs.getString("instructor_name"));
                    list.add(sc);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Schedule> getSchedulesByStudent(int studentId) {
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT sc.*, s.full_name as student_name, i.full_name as instructor_name " +
                     "FROM schedules sc " +
                     "JOIN students s ON sc.student_id = s.student_id " +
                     "JOIN instructors i ON sc.instructor_id = i.instructor_id " +
                     "WHERE sc.student_id = ? " +
                     "ORDER BY sc.lesson_date, sc.lesson_time";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Schedule sc = new Schedule();
                    sc.setScheduleId(rs.getInt("schedule_id"));
                    sc.setStudentId(rs.getInt("student_id"));
                    sc.setInstructorId(rs.getInt("instructor_id"));
                    sc.setSessionDate(rs.getString("lesson_date"));
                    sc.setSessionTime(rs.getString("lesson_time"));
                    sc.setStatus(rs.getString("status"));
                    sc.setStudentName(rs.getString("student_name"));
                    sc.setInstructorName(rs.getString("instructor_name"));
                    list.add(sc);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateScheduleStatus(int scheduleId, String status) {
        String sql = "UPDATE schedules SET status = ? WHERE schedule_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, scheduleId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}


