<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .success {
            background-color: #4CAF50;
            color: white;
            padding: 15px;
            border-radius: 4px;
            margin: 10px 0;
            text-align: center;
        }
        .info {
            background-color: #2196F3;
            color: white;
            padding: 10px;
            border-radius: 4px;
            margin: 10px 0;
            text-align: center;
        }
        .btn-add {
            display: inline-block;
            background-color: #4CAF50;
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 4px;
            margin: 10px 0;
        }
        .btn-add:hover {
            background-color: #45a049;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th {
            background-color: #4CAF50;
            color: white;
            padding: 12px;
            text-align: left;
        }
        td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .action-links {
            display: flex;
            gap: 10px;
        }
        .edit-link {
            color: #2196F3;
            text-decoration: none;
        }
        .edit-link:hover {
            text-decoration: underline;
        }
        .delete-link {
            color: #f44336;
            text-decoration: none;
            font-weight: bold;
        }
        .delete-link:hover {
            text-decoration: underline;
            color: #d32f2f;
        }
        .error {
            background-color: #f44336;
            color: white;
            padding: 15px;
            border-radius: 4px;
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Student Management System</h1>
        
        <%
            // Display success message if exists
            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null) {
        %>
            <div class="success">
                ✓ <%= successMessage %>
            </div>
        <%
                session.removeAttribute("successMessage");
            }
        %>
        
        <a href="add_student.jsp" class="btn-add">+ Add New Student</a>
        
        <%
            Connection conn = null;
            Statement stmt = null;
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
                
                // Create statement with scrollable result set
                stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                
                // Execute query
                String sql = "SELECT * FROM students ORDER BY id";
                rs = stmt.executeQuery(sql);
                
                // Count rows
                int count = 0;
                while (rs.next()) {
                    count++;
                }
                rs.beforeFirst();
        %>
        
        <div class="info">
            Total Students: <%= count %>
        </div>
        
        <% if (count > 0) { %>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Student Code</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Major</th>
                    <th>Created At</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% while (rs.next()) { %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("student_code") %></td>
                    <td><%= rs.getString("full_name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getString("major") %></td>
                    <td><%= rs.getTimestamp("created_at") %></td>
                    <td>
                        <div class="action-links">
                            <a href="edit_student.jsp?id=<%= rs.getInt("id") %>" class="edit-link">✏️ Edit</a>
                            <a href="delete_student.jsp?id=<%= rs.getInt("id") %>" 
                               class="delete-link"
                               onclick="return confirm('Are you sure you want to delete this student?')">🗑️ Delete</a>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
        <p style="text-align: center; padding: 20px;">No students found.</p>
        <% } %>
        
        <%
            } catch (ClassNotFoundException e) {
        %>
            <div class="error">
                <strong>Driver Error:</strong> MySQL JDBC driver not found.<br>
                <%= e.getMessage() %>
            </div>
        <%
            } catch (SQLException e) {
        %>
            <div class="error">
                <strong>Database Error:</strong> Could not connect or query database.<br>
                <%= e.getMessage() %>
            </div>
        <%
            } finally {
                // Close resources
                if (rs != null) try { rs.close(); } catch (SQLException e) {}
                if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                if (conn != null) try { conn.close(); } catch (SQLException e) {}
            }
        %>
    </div>
</body>
</html>
