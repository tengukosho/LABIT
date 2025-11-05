<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    // Retrieve all parameters
    String idParam = request.getParameter("id");
    String studentCode = request.getParameter("student_code");
    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email");
    String major = request.getParameter("major");
    
    // Validation
    boolean hasError = false;
    String errorMessage = "";
    
    // Check if ID is provided and valid
    if (idParam == null || idParam.trim().isEmpty()) {
        hasError = true;
        errorMessage = "Student ID is required.";
    }
    
    int studentId = 0;
    if (!hasError) {
        try {
            studentId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            hasError = true;
            errorMessage = "Invalid student ID format.";
        }
    }
    
    // Check if required field (full name) is empty
    if (!hasError && (fullName == null || fullName.trim().isEmpty())) {
        hasError = true;
        errorMessage = "Required field missing. Full Name is required.";
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
            
            // UPDATE query with WHERE clause using PreparedStatement
            String sql = "UPDATE students SET full_name = ?, email = ?, major = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            
            // Set parameters
            pstmt.setString(1, fullName.trim());
            pstmt.setString(2, email != null && !email.trim().isEmpty() ? email.trim() : null);
            pstmt.setString(3, major != null && !major.trim().isEmpty() ? major.trim() : null);
            pstmt.setInt(4, studentId);
            
            // Execute update
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // Success - redirect to list page with success message
                session.setAttribute("successMessage", "Student updated successfully!");
                response.sendRedirect("list_students.jsp");
                return;
            } else {
                // No rows affected - student might not exist
                hasError = true;
                errorMessage = "Student not found or no changes were made.";
            }
            
        } catch (ClassNotFoundException e) {
            hasError = true;
            errorMessage = "Database Driver Error: MySQL JDBC driver not found.";
        } catch (SQLException e) {
            hasError = true;
            errorMessage = "Database Error: " + e.getMessage();
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
    <title>Error - Update Student</title>
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
            background-color: #2196F3;
            color: white;
        }
        .btn-back:hover {
            background-color: #0b7dda;
        }
        .btn-list {
            background-color: #4CAF50;
            color: white;
        }
        .btn-list:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="error-box">
            <h2>❌ Error Updating Student</h2>
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
