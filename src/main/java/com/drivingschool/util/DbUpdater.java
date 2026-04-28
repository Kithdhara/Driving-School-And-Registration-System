package com.drivingschool.util;

import java.sql.Connection;
import java.sql.Statement;

/**
 * Run this once to add new columns to the existing payments table.
 * Safe to run multiple times — it catches "column already exists" errors.
 */
public class DbUpdater {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            try {
                stmt.executeUpdate("ALTER TABLE payments ADD COLUMN package_type ENUM('INDIVIDUAL','VIP','REFRESHER') NOT NULL DEFAULT 'INDIVIDUAL'");
                System.out.println("Added package_type column.");
            } catch (Exception e) {
                System.out.println("package_type column already exists or error: " + e.getMessage());
            }

            try {
                stmt.executeUpdate("ALTER TABLE payments ADD COLUMN sessions_included INT NOT NULL DEFAULT 10");
                System.out.println("Added sessions_included column.");
            } catch (Exception e) {
                System.out.println("sessions_included column already exists or error: " + e.getMessage());
            }

            System.out.println("Database update complete.");
        } catch (Exception e) {
            System.err.println("Database connection failed: " + e.getMessage());
        }
    }
}




