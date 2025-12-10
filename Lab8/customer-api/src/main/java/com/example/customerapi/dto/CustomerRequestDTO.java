package com.example.customerapi.dto;

import jakarta.validation.constraints.*;

public class CustomerRequestDTO {

    @NotBlank(message = "Customer code is required")
    @Size(min = 3, max = 20, message = "Customer code must be between 3 and 20 characters")
    @Pattern(regexp = "^C\\d{3,}$", message = "Customer code must start with 'C' followed by at least 3 digits")
    private String customerCode;

    @NotBlank(message = "Full name is required")
    @Size(min = 2, max = 100, message = "Full name must be between 2 and 100 characters")
    private String fullName;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;

    @Pattern(regexp = "^\\+?[0-9]{10,20}$", message = "Phone must contain 10–20 digits, optional '+' sign")
    private String phone;

    @Size(max = 500, message = "Address cannot exceed 500 characters")
    private String address;

    // String because DTO receives raw input
    private String status;

    // Constructors
    public CustomerRequestDTO() {}

    public CustomerRequestDTO(String customerCode, String fullName, String email,
                              String phone, String address, String status) {
        this.customerCode = customerCode;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.status = status;
    }

    // Getters and Setters
    public String getCustomerCode() {
        return customerCode;
    }

    public void setCustomerCode(String customerCode) {
        this.customerCode = customerCode;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
