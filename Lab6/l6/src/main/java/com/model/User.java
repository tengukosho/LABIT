package com.model;

import java.sql.Timestamp;

public class User {
    // Attributes matching database columns
    private int id;
    private String username;
    private String password; // Stored as hash
    private String fullName;
    private String role; // 'admin' or 'user'
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp lastLogin;

    // No-arg constructor
    public User() {
    }

    // Parameterized constructor (username, password, fullName, role)
    public User(String username, String password, String fullName, String role) {
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.role = role;
    }
    
    // Full Parameterized constructor
    public User(int id, String username, String password, String fullName, String role, boolean isActive, Timestamp createdAt, Timestamp lastLogin) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.role = role;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.lastLogin = lastLogin;
    }

    // =========================================================================
    // FIX: ADDED GETTERS AND SETTERS TO RESOLVE 'cannot find symbol' ERRORS
    // =========================================================================

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    // Required by UserDAO.authenticate() and ChangePasswordController.doPost()
    public String getPassword() {
        return password;
    }

    // Required by ChangePasswordController.doPost()
    public void setPassword(String password) {
        this.password = password;
    }

    // Required by LoginController.doPost()
    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    // Required by LoginController.doPost()
    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(Timestamp lastLogin) {
        this.lastLogin = lastLogin;
    }

    // Utility methods
    public boolean isAdmin() {
        return "admin".equals(this.role);
    }

    public boolean isUser() {
        return "user".equals(this.role);
    }
}