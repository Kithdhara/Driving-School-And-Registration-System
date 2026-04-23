package com.drivingschool.model;

public class Instructor extends Person {
    private String licenseType;
    private int experienceYears;

    public Instructor() {
        this.setRole("INSTRUCTOR");
    }

    public String getLicenseType() { return licenseType; }
    public void setLicenseType(String licenseType) { this.licenseType = licenseType; }

    public int getExperienceYears() { return experienceYears; }
    public void setExperienceYears(int experienceYears) { this.experienceYears = experienceYears; }

    @Override
    public String getRoleDescription() {
        return "Instructor | License: " + this.licenseType + " | " + this.experienceYears + " yrs";
    }
}


