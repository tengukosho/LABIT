package dao;

import model.Student;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {
    // Database configuration constants
    private static final String DB_URL = "jdbc:mysql://localhost:3306/student_management";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "123123";
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    
    /**
     * Get database connection
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public Connection getConnection() throws SQLException {
        try {
            // Load JDBC driver
            Class.forName(DB_DRIVER);
            // Return connection
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found", e);
        }
    }
    
    /**
     * Get all students from database
     * @return List of all students
     */
    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students ORDER BY id DESC";
        
        // Try-with-resources - automatically closes resources
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            // Loop through result set and create Student objects
            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setStudentCode(rs.getString("student_code"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
                student.setCreatedAt(rs.getTimestamp("created_at"));
                
                students.add(student);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all students: " + e.getMessage());
            e.printStackTrace();
        }
        
        return students;
    }
    
    /**
     * Test method - remove after testing
     */
    public static void main(String[] args) {
        System.out.println("Testing StudentDAO...");
        System.out.println("=====================\n");
        
        StudentDAO dao = new StudentDAO();
        
        // Test getAllStudents()
        List<Student> students = dao.getAllStudents();
        
        if (students.isEmpty()) {
            System.out.println("No students found in database.");
        } else {
            System.out.println("Found " + students.size() + " students:\n");
            for (Student s : students) {
                System.out.println(s);
            }
        }
        
        System.out.println("\n=====================");
        System.out.println("Test completed!");
    }
}
