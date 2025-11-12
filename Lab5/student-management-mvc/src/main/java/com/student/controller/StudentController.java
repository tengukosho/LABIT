package controller;

import dao.StudentDAO;
import model.Student;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/student")
public class StudentController extends HttpServlet {
    
    private StudentDAO studentDAO;
    
    /**
     * Initialize the servlet by creating StudentDAO instance
     */
    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }
    
    /**
     * Handle GET requests
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        // If action is null, default to "list"
        if (action == null) {
            action = "list";
        }
        
        // Route to appropriate method based on action
        switch (action) {
            case "list":
                listStudents(request, response);
                break;
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteStudent(request, response);
                break;
            default:
                listStudents(request, response);
                break;
        }
    }
    
    /**
     * Handle POST requests
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        // Route to appropriate method based on action
        switch (action) {
            case "insert":
                insertStudent(request, response);
                break;
            case "update":
                updateStudent(request, response);
                break;
            default:
                listStudents(request, response);
                break;
        }
    }
    
    /**
     * List all students
     */
    private void listStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get list of students from DAO
        List<Student> students = studentDAO.getAllStudents();
        
        // 2. Set as request attribute
        request.setAttribute("students", students);
        
        // 3. Forward to student-list.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * Show form to add new student
     */
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Forward to student-form.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * Show form to edit existing student
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get student ID from request
        int id = Integer.parseInt(request.getParameter("id"));
        
        // Get student from DAO
        Student existingStudent = studentDAO.getStudentById(id);
        
        // Set student as request attribute
        request.setAttribute("student", existingStudent);
        
        // Forward to student-form.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * Insert new student
     */
    private void insertStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");
        
        // Create new Student object
        Student newStudent = new Student(studentCode, fullName, email, major);
        
        // Insert student via DAO
        boolean success = studentDAO.insertStudent(newStudent);
        
        // Set success message
        if (success) {
            request.getSession().setAttribute("message", "Student added successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to add student.");
        }
        
        // Redirect to list
        response.sendRedirect("student?action=list");
    }
    
    /**
     * Update existing student
     */
    private void updateStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        int id = Integer.parseInt(request.getParameter("id"));
        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");
        
        // Create Student object with updated data
        Student student = new Student();
        student.setId(id);
        student.setStudentCode(studentCode);
        student.setFullName(fullName);
        student.setEmail(email);
        student.setMajor(major);
        
        // Update student via DAO
        boolean success = studentDAO.updateStudent(student);
        
        // Set success message
        if (success) {
            request.getSession().setAttribute("message", "Student updated successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to update student.");
        }
        
        // Redirect to list
        response.sendRedirect("student?action=list");
    }
    
    /**
     * Delete student
     */
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get student ID from request
        int id = Integer.parseInt(request.getParameter("id"));
        
        // Delete student via DAO
        boolean success = studentDAO.deleteStudent(id);
        
        // Set success message
        if (success) {
            request.getSession().setAttribute("message", "Student deleted successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to delete student.");
        }
        
        // Redirect to list
        response.sendRedirect("student?action=list");
    }
}
