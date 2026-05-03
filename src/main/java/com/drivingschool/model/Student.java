package com.drivingschool.model;

public class Student extends Person {
    private String nic;
    private String address;
    private String permitType;
    private String registrationDate;

    public Student() {
        this.setRole("STUDENT");
    }

    public String getNic() { return nic; }
    public void setNic(String nic) { this.nic = nic; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPermitType() { return permitType; }
    public void setPermitType(String permitType) { this.permitType = permitType; }

    public String getRegistrationDate() { return registrationDate; }
    public void setRegistrationDate(String registrationDate) { this.registrationDate = registrationDate; }

    @Override
    public String getRoleDescription() {
        return "Student | Permit: " + this.permitType;
    }
}



