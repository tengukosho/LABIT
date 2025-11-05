<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    // Get and validate student ID parameter
    String idParam = request.getParameter("id");
    
    boolean hasError = false;
    String errorMessage = "";
    
    // Check if ID is provided
    if (idParam == null || idParam.trim().isEmpty()) {
        hasError = true;
        errorMessage = "Student ID is required.";
    }
    
    int studentId = 0;
    if (!hasError) {
        // Validate ID is a number
        try {
            studentId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            hasError = true;
            errorMessage = "Invalid student ID format. ID must be a number.";
        }
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
            
            // DELETE query using PreparedStatement to prevent SQL injection
            String sql = "DELETE FROM students WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            
            // Set parameter
            pstmt.setInt(1, studentId);
            
            // Execute delete
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // Success - redirect to list page with success message
                session.setAttribute("successMessage", "Student deleted successfully!");
                response.sendRedirect("list_students.jsp");
                return;
            } else {
                // No rows affected - student ID not found
                hasError = true;
                errorMessage = "Student not found. The student with ID " + studentId + " does not exist.";
            }
            
        } catch (ClassNotFoundException e) {
            hasError = true;
            errorMessage = "Database Driver Error: MySQL JDBC driver not found. " + e.getMessage();
        } catch (SQLException e) {
            hasError = true;
            errorMessage = "Database Error: Unable to delete student. " + e.getMessage();
        } finally {
            // Close resources properly
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
    <title>Error - Delete Student</title>
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
        .btn {
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
            <h2>❌ Error Deleting Student</h2>
            <p><%= errorMessage %></p>
        </div>
        
        <div class="btn-container">
            <a href="list_students.jsp" class="btn btn-list">← Back to Student List</a>
        </div>
    </div>
</body>
</html>
<%
    }
%>
