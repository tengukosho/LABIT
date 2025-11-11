<%@ page contentType="text/csv;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    // Set response headers for CSV download
    response.setContentType("text/csv");
    response.setHeader("Content-Disposition", "attachment; filename=\"students.csv\"");
    
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
        
        // Create statement
        stmt = conn.createStatement();
        
        // Write CSV header
        out.println("ID,Student Code,Full Name,Email,Major,Created At");
        
        // Query all students
        String sql = "SELECT * FROM students ORDER BY id";
        rs = stmt.executeQuery(sql);
        
        // Write data rows
        while (rs.next()) {
            int id = rs.getInt("id");
            String studentCode = rs.getString("student_code");
            String fullName = rs.getString("full_name");
            String email = rs.getString("email");
            String major = rs.getString("major");
            Timestamp createdAt = rs.getTimestamp("created_at");
            
            // Escape commas and quotes in CSV
            fullName = "\"" + (fullName != null ? fullName.replace("\"", "\"\"") : "") + "\"";
            email = "\"" + (email != null ? email.replace("\"", "\"\"") : "") + "\"";
            major = "\"" + (major != null ? major.replace("\"", "\"\"") : "") + "\"";
            
            out.println(id + "," + studentCode + "," + fullName + "," + email + "," + major + "," + createdAt);
        }
        
    } catch (Exception e) {
        // If error, write error message to CSV
        out.println("Error," + e.getMessage());
    } finally {
        // Close resources
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
