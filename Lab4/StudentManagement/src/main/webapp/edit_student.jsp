<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Student</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: bold;
        }
        small {
            display: block;
            margin-top: 5px;
            font-size: 12px;
            font-style: italic;
        }
        input[type="text"],
        input[type="email"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
        }
        input[readonly] {
            background-color: #e9ecef;
            cursor: not-allowed;
        }
        input[type="text"]:focus,
        input[type="email"]:focus {
            outline: none;
            border-color: #2196F3;
        }
        .required {
            color: red;
        }
        .btn-container {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }
        button, .btn {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
            text-align: center;
            text-decoration: none;
            display: inline-block;
        }
        .btn-submit {
            background-color: #2196F3;
            color: white;
        }
        .btn-submit:hover {
            background-color: #0b7dda;
        }
        .btn-cancel {
            background-color: #f44336;
            color: white;
        }
        .btn-cancel:hover {
            background-color: #da190b;
        }
        .error {
            background-color: #f44336;
            color: white;
            padding: 20px;
            border-radius: 4px;
            margin-bottom: 20px;
            text-align: center;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #2196F3;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <%
            // Get and validate student ID parameter
            String idParam = request.getParameter("id");
            
            if (idParam == null || idParam.trim().isEmpty()) {
        %>
                <div class="error">
                    <h2>❌ Invalid Request</h2>
                    <p>Student ID is required.</p>
                </div>
                <div class="btn-container">
                    <a href="list_students.jsp" class="btn btn-cancel">Back to List</a>
                </div>
        <%
            } else {
                int studentId = 0;
                boolean validId = false;
                
                // Parse ID
                try {
                    studentId = Integer.parseInt(idParam);
                    validId = true;
                } catch (NumberFormatException e) {
        %>
                    <div class="error">
                        <h2>❌ Invalid Student ID</h2>
                        <p>Student ID must be a valid number.</p>
                    </div>
                    <div class="btn-container">
                        <a href="list_students.jsp" class="btn btn-cancel">Back to List</a>
                    </div>
        <%
                }
                
                if (validId) {
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    
                    try {
                        // Database connection settings
                        String url = "jdbc:mysql://localhost:3306/student_management";
                        String username = "root";
                        String password = "123123";
                        
                        // Load JDBC driver
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        
                        // Connect to database
                        conn = DriverManager.getConnection(url, username, password);
                        
                        // Query for student with the given ID
                        String sql = "SELECT * FROM students WHERE id = ?";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setInt(1, studentId);
                        
                        rs = pstmt.executeQuery();
                        
                        if (rs.next()) {
                            // Student found - display edit form with pre-filled values
                            String studentCode = rs.getString("student_code");
                            String fullName = rs.getString("full_name");
                            String email = rs.getString("email");
                            String major = rs.getString("major");
        %>
                            <h1>Edit Student</h1>
                            
                            <form action="process_edit.jsp" method="post" onsubmit="return submitForm(this)">
                                <!-- Hidden input for student ID -->
                                <input type="hidden" name="id" value="<%= studentId %>">
                                
                                <div class="form-group">
                                    <label for="student_code">Student Code <span class="required">*</span></label>
                                    <input type="text" id="student_code" name="student_code" value="<%= studentCode %>" readonly>
                                </div>
                                
                                <div class="form-group">
                                    <label for="full_name">Full Name <span class="required">*</span></label>
                                    <input type="text" id="full_name" name="full_name" value="<%= fullName %>" required>
                                </div>
                                
                                <div class="form-group">
                                    <label for="email">Email</label>
                                    <input type="email" 
                                           id="email" 
                                           name="email" 
                                           value="<%= email != null ? email : "" %>"
                                           pattern="^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"
                                           title="Please enter a valid email address">
                                    <small style="color: #666;">Optional - Must be valid email format if provided</small>
                                </div>
                                
                                <div class="form-group">
                                    <label for="major">Major</label>
                                    <input type="text" id="major" name="major" value="<%= major != null ? major : "" %>">
                                </div>
                                
                                <div class="btn-container">
                                    <button type="submit" class="btn-submit">Update Student</button>
                                    <a href="list_students.jsp" class="btn btn-cancel">Cancel</a>
                                </div>
                            </form>
                            
                            <a href="list_students.jsp" class="back-link">← Back to Student List</a>
        <%
                        } else {
                            // Student not found
        %>
                            <div class="error">
                                <h2>❌ Student Not Found</h2>
                                <p>No student exists with ID: <%= studentId %></p>
                            </div>
                            <div class="btn-container">
                                <a href="list_students.jsp" class="btn btn-cancel">Back to List</a>
                            </div>
        <%
                        }
                        
                    } catch (ClassNotFoundException e) {
        %>
                        <div class="error">
                            <strong>Driver Error:</strong><br>
                            <%= e.getMessage() %>
                        </div>
                        <div class="btn-container">
                            <a href="list_students.jsp" class="btn btn-cancel">Back to List</a>
                        </div>
        <%
                    } catch (SQLException e) {
        %>
                        <div class="error">
                            <strong>Database Error:</strong><br>
                            <%= e.getMessage() %>
                        </div>
                        <div class="btn-container">
                            <a href="list_students.jsp" class="btn btn-cancel">Back to List</a>
                        </div>
        <%
                    } finally {
                        // Close resources
                        if (rs != null) try { rs.close(); } catch (SQLException e) {}
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
                        if (conn != null) try { conn.close(); } catch (SQLException e) {}
                    }
                }
            }
        %>
    </div>
    
    <script>
        function submitForm(form) {
            var btn = form.querySelector('button[type="submit"]');
            btn.disabled = true;
            btn.textContent = 'Processing...';
            btn.style.backgroundColor = '#ccc';
            return true;
        }
    </script>
</body>
</html>
