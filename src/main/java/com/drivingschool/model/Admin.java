package com.drivingschool.model;

public class Admin extends Person {
    
    public Admin() {
        this.setRole("ADMIN");
    }

    @Override
    public String getRoleDescription() {
        return "System Administrator";
    }
}




