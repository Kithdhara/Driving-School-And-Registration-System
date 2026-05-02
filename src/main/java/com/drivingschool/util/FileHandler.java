package com.drivingschool.util;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * VIVA POINT: File Handling Implementation.
 * This class demonstrates writing data to a text file using FileWriter and PrintWriter.
 */
public class FileHandler {
    private static final String LOG_FILE = "activity_log.txt";
    private static final String CREDENTIALS_FILE = "instructor_credentials.txt";
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public static void logActivity(String event, String username, String role) {
        try (FileWriter fw = new FileWriter(LOG_FILE, true) /* VIVA POINT: The 'true' flag opens the file in APPEND mode so it doesn't delete old logs */;
             PrintWriter pw = new PrintWriter(fw)) {
            pw.println("Event:      " + event);
            pw.println("User:       " + username);
            pw.println("Role:       " + role);
            pw.println("Timestamp:  " + LocalDateTime.now().format(formatter));
            pw.println("---");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void saveInstructorCredentials(String name, String username, String password) {
        try (FileWriter fw = new FileWriter(CREDENTIALS_FILE, true);
             PrintWriter pw = new PrintWriter(fw)) {
            pw.println("New Instructor Account Created");
            pw.println("Name:      " + name);
            pw.println("Username:  " + username);
            pw.println("Password:  " + password);
            pw.println("Created:   " + LocalDateTime.now().format(formatter));
            pw.println("---");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void logReview(String studentName, String instructorName, int rating) {
        try (FileWriter fw = new FileWriter(LOG_FILE, true) /* VIVA POINT: The 'true' flag opens the file in APPEND mode so it doesn't delete old logs */;
             PrintWriter pw = new PrintWriter(fw)) {
            pw.println("Event:      REVIEW_SUBMITTED");
            pw.println("Student:    " + studentName);
            pw.println("Instructor: " + instructorName);
            pw.println("Rating:     " + rating + "/5");
            pw.println("Timestamp:  " + LocalDateTime.now().format(formatter));
            pw.println("---");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void logProfileUpdate(String username, String role, String field) {
        try (FileWriter fw = new FileWriter(LOG_FILE, true) /* VIVA POINT: The 'true' flag opens the file in APPEND mode so it doesn't delete old logs */;
             PrintWriter pw = new PrintWriter(fw)) {
            pw.println("Event:      PROFILE_UPDATED");
            pw.println("User:       " + username);
            pw.println("Role:       " + role);
            pw.println("Changed:    " + field);
            pw.println("Timestamp:  " + LocalDateTime.now().format(formatter));
            pw.println("---");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void logPaymentAction(String action, String studentName, double amount) {
        try (FileWriter fw = new FileWriter(LOG_FILE, true) /* VIVA POINT: The 'true' flag opens the file in APPEND mode so it doesn't delete old logs */;
             PrintWriter pw = new PrintWriter(fw)) {
            pw.println("Event:      PAYMENT_" + action);
            pw.println("Student:    " + studentName);
            pw.println("Amount:     Rs. " + String.format("%.2f", amount));
            pw.println("Timestamp:  " + LocalDateTime.now().format(formatter));
            pw.println("---");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

