<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    // Retrieve form parameters
    String studentCode = request.getParameter("student_code");
    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email");
    String major = request.getParameter("major");
    
    // Server-side validation
    boolean hasError = false;
    String errorMessage = "";
    
    // Check if required fields are empty
    if (studentCode == null || studentCode.trim().isEmpty() || 
        fullName == null || fullName.trim().isEmpty()) {
        hasError = true;
        errorMessage = "Required fields missing. Student Code and Full Name are required.";
    }
    
    if (!hasError) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            // Database connection settings
            String url = "jdbc:mysql://localhost:3306/student_management";
            String username = "root";
            String password = "123123";
            
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Connect to database
            conn = DriverManager.getConnection(url, username, password);
            
            // Use PreparedStatement to prevent SQL injection
            String sql = "INSERT INTO students (student_code, full_name, email, major) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            
            // Set parameters
            pstmt.setString(1, studentCode.trim());
            pstmt.setString(2, fullName.trim());
            pstmt.setString(3, email != null && !email.trim().isEmpty() ? email.trim() : null);
            pstmt.setString(4, major != null && !major.trim().isEmpty() ? major.trim() : null);
            
            // Execute insert
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // Success - redirect to list page with success message
                session.setAttribute("successMessage", "Student added successfully!");
                response.sendRedirect("list_students.jsp");
                return;
            } else {
                hasError = true;
                errorMessage = "Failed to insert student. Please try again.";
            }
            
        } catch (ClassNotFoundException e) {
            hasError = true;
            errorMessage = "Database Driver Error: MySQL JDBC driver not found.";
        } catch (SQLException e) {
            hasError = true;
            // Check if it's a duplicate key error
            if (e.getMessage().contains("Duplicate entry") || e.getErrorCode() == 1062) {
                errorMessage = "Student code already exists. Please use a different student code.";
            } else {
                errorMessage = "Database Error: " + e.getMessage();
            }
        } finally {
            // Close resources
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    }
    
    // If there's an error, display error page
    if (hasError) {
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error - Add Student</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .error-box {
            background-color: #f44336;
            color: white;
            padding: 20px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .error-box h2 {
            margin: 0 0 10px 0;
        }
        .error-box p {
            margin: 0;
            font-size: 16px;
        }
        .btn-container {
            display: flex;
            gap: 10px;
        }
        button, .btn {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            display: inline-block;
        }
        .btn-back {
            background-color: #4CAF50;
            color: white;
        }
        .btn-back:hover {
            background-color: #45a049;
        }
        .btn-list {
            background-color: #2196F3;
            color: white;
        }
        .btn-list:hover {
            background-color: #0b7dda;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="error-box">
            <h2>❌ Error Adding Student</h2>
            <p><%= errorMessage %></p>
        </div>
        
        <div class="btn-container">
            <a href="javascript:history.back()" class="btn btn-back">← Go Back</a>
            <a href="list_students.jsp" class="btn btn-list">View Student List</a>
        </div>
    </div>
</body>
</html>
<%
    }
%>
