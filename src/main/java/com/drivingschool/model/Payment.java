package com.drivingschool.model;

public class Payment {
    private int paymentId;
    private int studentId;
    private double amount;
    private String paymentMethod;
    private String paymentStatus;
    private String paymentDate;
    private String sessionPreference;
    private String packageType;      // INDIVIDUAL, VIP, REFRESHER
    private int sessionsIncluded;     // how many lessons come with this package

    private String studentName;

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getPaymentDate() { return paymentDate; }
    public void setPaymentDate(String paymentDate) { this.paymentDate = paymentDate; }

    public String getSessionPreference() { return sessionPreference; }
    public void setSessionPreference(String sessionPreference) { this.sessionPreference = sessionPreference; }

    public String getPackageType() { return packageType; }
    public void setPackageType(String packageType) { this.packageType = packageType; }

    public int getSessionsIncluded() { return sessionsIncluded; }
    public void setSessionsIncluded(int sessionsIncluded) { this.sessionsIncluded = sessionsIncluded; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
}

