<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%!
    // Helper method to highlight search keyword in text
    private String highlightKeyword(String text, String keyword) {
        if (text == null || keyword == null || keyword.trim().isEmpty()) {
            return text;
        }
        return text.replaceAll("(?i)(" + keyword.trim() + ")", "<span class='highlight'>$1</span>");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
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
            margin-bottom: 20px;
        }
        
        /* Message Styling with Icons */
        .success {
            background-color: #4CAF50;
            color: white;
            padding: 15px;
            border-radius: 4px;
            margin: 10px 0;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .success::before {
            content: "✓";
            font-size: 20px;
            font-weight: bold;
        }
        
        .error {
            background-color: #f44336;
            color: white;
            padding: 15px;
            border-radius: 4px;
            margin: 10px 0;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .error::before {
            content: "✗";
            font-size: 20px;
            font-weight: bold;
        }
        
        .info {
            background-color: #2196F3;
            color: white;
            padding: 10px;
            border-radius: 4px;
            margin: 10px 0;
            text-align: center;
        }
        
        .search-info {
            background-color: #fff3cd;
            color: #856404;
            padding: 10px;
            border-radius: 4px;
            margin: 10px 0;
        }
        
        .btn-add {
            display: inline-block;
            background-color: #4CAF50;
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 4px;
            margin: 10px 10px 10px 0;
        }
        
        .btn-add:hover {
            background-color: #45a049;
        }
        
        .btn-export {
            display: inline-block;
            background-color: #FF9800;
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 4px;
            margin: 10px 0;
        }
        
        .btn-export:hover {
            background-color: #F57C00;
        }
        
        /* Search Container */
        .search-container {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .search-container form {
            display: flex;
            gap: 10px;
            flex: 1;
            align-items: center;
        }
        
        .search-container input[type="text"] {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            min-width: 250px;
        }
        
        .btn-search, .btn-clear {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-search {
            background-color: #2196F3;
            color: white;
        }
        
        .btn-search:hover {
            background-color: #0b7dda;
        }
        
        .btn-clear {
            background-color: #757575;
            color: white;
        }
        
        .btn-clear:hover {
            background-color: #616161;
        }
        
        /* Responsive Table */
        .table-responsive {
            overflow-x: auto;
            margin-top: 20px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th {
            background-color: #4CAF50;
            color: white;
            padding: 12px;
            text-align: left;
            cursor: pointer;
            position: relative;
            user-select: none;
        }
        
        th:hover {
            background-color: #45a049;
        }
        
        th.sortable::after {
            content: " ⇅";
            opacity: 0.5;
        }
        
        th.sorted-asc::after {
            content: " ▲";
            opacity: 1;
        }
        
        th.sorted-desc::after {
            content: " ▼";
            opacity: 1;
        }
        
        td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        
        tbody tr:hover {
            background-color: #f5f5f5;
        }
        
        .action-links {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
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
        
        .highlight {
            background-color: #ffeb3b;
            font-weight: bold;
            padding: 2px 4px;
        }
        
        /* Pagination Styling */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 5px;
            margin: 20px 0;
            flex-wrap: wrap;
        }
        
        .pagination a, .pagination strong {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            text-decoration: none;
            color: #333;
        }
        
        .pagination a:hover {
            background-color: #2196F3;
            color: white;
            border-color: #2196F3;
        }
        
        .pagination strong {
            background-color: #4CAF50;
            color: white;
            border-color: #4CAF50;
        }
        
        .pagination .disabled {
            color: #ccc;
            cursor: not-allowed;
            pointer-events: none;
        }
        
        /* Mobile Responsive */
        @media (max-width: 768px) {
            body {
                margin: 10px;
            }
            
            .container {
                padding: 10px;
            }
            
            h1 {
                font-size: 1.5em;
            }
            
            table {
                font-size: 12px;
            }
            
            th, td {
                padding: 5px;
            }
            
            .action-links {
                flex-direction: column;
                gap: 5px;
            }
            
            .search-container {
                flex-direction: column;
            }
            
            .search-container form {
                width: 100%;
            }
            
            .search-container input[type="text"] {
                min-width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎓 Student Management System</h1>
        
        <%
            // Display success message if exists (with auto-hide)
            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null) {
        %>
            <div class="success message">
                <%= successMessage %>
            </div>
        <%
                session.removeAttribute("successMessage");
            }
        %>
        
        <a href="add_student.jsp" class="btn-add">+ Add New Student</a>
        <a href="export_csv.jsp" class="btn-export">📥 Export to CSV</a>
        
        <!-- Search Form -->
        <div class="search-container">
            <form action="list_students.jsp" method="GET">
                <input type="text" 
                       name="keyword" 
                       placeholder="Search by name or code..." 
                       value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
                <button type="submit" class="btn-search">🔍 Search</button>
            </form>
            <a href="list_students.jsp" class="btn-clear">Clear</a>
        </div>
        
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            PreparedStatement countStmt = null;
            ResultSet rs = null;
            ResultSet countRs = null;
            
            // Get search keyword
            String keyword = request.getParameter("keyword");
            boolean isSearching = (keyword != null && !keyword.trim().isEmpty());
            
            // Sorting parameters
            String sortBy = request.getParameter("sort");
            String order = request.getParameter("order");
            
            // Default sorting
            if (sortBy == null || sortBy.trim().isEmpty()) {
                sortBy = "id";
            }
            if (order == null || order.trim().isEmpty()) {
                order = "desc";
            }
            
            // Validate sortBy to prevent SQL injection
            String[] allowedColumns = {"id", "student_code", "full_name", "email", "major", "created_at"};
            boolean validSort = false;
            for (String col : allowedColumns) {
                if (col.equals(sortBy)) {
                    validSort = true;
                    break;
                }
            }
            if (!validSort) {
                sortBy = "id";
            }
            
            // Validate order
            if (!order.equals("asc") && !order.equals("desc")) {
                order = "desc";
            }
            
            // Toggle order for next click
            String nextOrder = order.equals("asc") ? "desc" : "asc";
            
            // Pagination parameters
            String pageParam = request.getParameter("page");
            int currentPage = 1;
            try {
                if (pageParam != null) {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
            
            int recordsPerPage = 10;
            int offset = (currentPage - 1) * recordsPerPage;
            
            try {
                // Database connection settings
                String url = "jdbc:mysql://localhost:3306/student_management";
                String username = "root";
                String password = "123123";
                
                // Load JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver");
                
                // Connect to database
                conn = DriverManager.getConnection(url, username, password);
                
                // Count total records
                String countSql;
                if (isSearching) {
                    countSql = "SELECT COUNT(*) FROM students WHERE full_name LIKE ? OR student_code LIKE ?";
                    countStmt = conn.prepareStatement(countSql);
                    String searchPattern = "%" + keyword.trim() + "%";
                    countStmt.setString(1, searchPattern);
                    countStmt.setString(2, searchPattern);
                } else {
                    countSql = "SELECT COUNT(*) FROM students";
                    countStmt = conn.prepareStatement(countSql);
                }
                
                countRs = countStmt.executeQuery();
                int totalRecords = 0;
                if (countRs.next()) {
                    totalRecords = countRs.getInt(1);
                }
                
                int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
                
                // Build query with LIMIT and OFFSET
                String sql;
                if (isSearching) {
                    sql = "SELECT * FROM students WHERE full_name LIKE ? OR student_code LIKE ? ORDER BY " + sortBy + " " + order + " LIMIT ? OFFSET ?";
                    pstmt = conn.prepareStatement(sql);
                    String searchPattern = "%" + keyword.trim() + "%";
                    pstmt.setString(1, searchPattern);
                    pstmt.setString(2, searchPattern);
                    pstmt.setInt(3, recordsPerPage);
                    pstmt.setInt(4, offset);
                } else {
                    sql = "SELECT * FROM students ORDER BY " + sortBy + " " + order + " LIMIT ? OFFSET ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, recordsPerPage);
                    pstmt.setInt(2, offset);
                }
                
                // Execute query
                rs = pstmt.executeQuery();
        %>
        
        <% if (isSearching) { %>
        <div class="search-info">
            🔍 Search results for: "<strong><%= keyword %></strong>" - Found <%= totalRecords %> student(s)
        </div>
        <% } %>
        
        <div class="info">
            Showing <%= Math.min(offset + 1, totalRecords) %> - <%= Math.min(offset + recordsPerPage, totalRecords) %> of <%= totalRecords %> students
            <% if (totalPages > 1) { %> | Page <%= currentPage %> of <%= totalPages %> <% } %>
        </div>
        
        <% if (totalRecords > 0) { %>
        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>
                            <a href="list_students.jsp?sort=id&order=<%= sortBy.equals("id") ? nextOrder : "asc" %><%= isSearching ? "&keyword=" + keyword : "" %>&page=<%= currentPage %>" 
                               style="color: white; text-decoration: none; display: block;"
                               class="<%= sortBy.equals("id") ? (order.equals("asc") ? "sorted-asc" : "sorted-desc") : "sortable" %>">
                                ID
                            </a>
                        </th>
                        <th>
                            <a href="list_students.jsp?sort=student_code&order=<%= sortBy.equals("student_code") ? nextOrder : "asc" %><%= isSearching ? "&keyword=" + keyword : "" %>&page=<%= currentPage %>" 
                               style="color: white; text-decoration: none; display: block;"
                               class="<%= sortBy.equals("student_code") ? (order.equals("asc") ? "sorted-asc" : "sorted-desc") : "sortable" %>">
                                Student Code
                            </a>
                        </th>
                        <th>
                            <a href="list_students.jsp?sort=full_name&order=<%= sortBy.equals("full_name") ? nextOrder : "asc" %><%= isSearching ? "&keyword=" + keyword : "" %>&page=<%= currentPage %>" 
                               style="color: white; text-decoration: none; display: block;"
                               class="<%= sortBy.equals("full_name") ? (order.equals("asc") ? "sorted-asc" : "sorted-desc") : "sortable" %>">
                                Full Name
                            </a>
                        </th>
                        <th>
                            <a href="list_students.jsp?sort=email&order=<%= sortBy.equals("email") ? nextOrder : "asc" %><%= isSearching ? "&keyword=" + keyword : "" %>&page=<%= currentPage %>" 
                               style="color: white; text-decoration: none; display: block;"
                               class="<%= sortBy.equals("email") ? (order.equals("asc") ? "sorted-asc" : "sorted-desc") : "sortable" %>">
                                Email
                            </a>
                        </th>
                        <th>
                            <a href="list_students.jsp?sort=major&order=<%= sortBy.equals("major") ? nextOrder : "asc" %><%= isSearching ? "&keyword=" + keyword : "" %>&page=<%= currentPage %>" 
                               style="color: white; text-decoration: none; display: block;"
                               class="<%= sortBy.equals("major") ? (order.equals("asc") ? "sorted-asc" : "sorted-desc") : "sortable" %>">
                                Major
                            </a>
                        </th>
                        <th>
                            <a href="list_students.jsp?sort=created_at&order=<%= sortBy.equals("created_at") ? nextOrder : "asc" %><%= isSearching ? "&keyword=" + keyword : "" %>&page=<%= currentPage %>" 
                               style="color: white; text-decoration: none; display: block;"
                               class="<%= sortBy.equals("created_at") ? (order.equals("asc") ? "sorted-asc" : "sorted-desc") : "sortable" %>">
                                Created At
                            </a>
                        </th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% while (rs.next()) { 
                        int id = rs.getInt("id");
                        String studentCode = rs.getString("student_code");
                        String fullName = rs.getString("full_name");
                        String email = rs.getString("email");
                        String major = rs.getString("major");
                        
                        // Apply highlighting if searching
                        if (isSearching) {
                            studentCode = highlightKeyword(studentCode, keyword);
                            fullName = highlightKeyword(fullName, keyword);
                        }
                    %>
                    <tr>
                        <td><%= id %></td>
                        <td><%= studentCode %></td>
                        <td><%= fullName %></td>
                        <td><%= email %></td>
                        <td><%= major %></td>
                        <td><%= rs.getTimestamp("created_at") %></td>
                        <td>
                            <div class="action-links">
                                <a href="edit_student.jsp?id=<%= id %>" class="edit-link">✏️ Edit</a>
                                <a href="delete_student.jsp?id=<%= id %>" 
                                   class="delete-link"
                                   onclick="return confirm('Are you sure you want to delete this student?')">🗑️ Delete</a>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
        <!-- Pagination Links -->
        <% if (totalPages > 1) { 
            String sortParams = "&sort=" + sortBy + "&order=" + order;
        %>
        <div class="pagination">
            <% if (currentPage > 1) { %>
                <a href="list_students.jsp?page=<%= currentPage - 1 %><%= isSearching ? "&keyword=" + keyword : "" %><%= sortParams %>">← Previous</a>
            <% } else { %>
                <span class="disabled">← Previous</span>
            <% } %>
            
            <% 
            // Show page numbers (with ellipsis if too many pages)
            int startPage = Math.max(1, currentPage - 2);
            int endPage = Math.min(totalPages, currentPage + 2);
            
            if (startPage > 1) { %>
                <a href="list_students.jsp?page=1<%= isSearching ? "&keyword=" + keyword : "" %><%= sortParams %>">1</a>
                <% if (startPage > 2) { %>
                    <span>...</span>
                <% } %>
            <% } %>
            
            <% for (int i = startPage; i <= endPage; i++) { %>
                <% if (i == currentPage) { %>
                    <strong><%= i %></strong>
                <% } else { %>
                    <a href="list_students.jsp?page=<%= i %><%= isSearching ? "&keyword=" + keyword : "" %><%= sortParams %>"><%= i %></a>
                <% } %>
            <% } %>
            
            <% if (endPage < totalPages) { %>
                <% if (endPage < totalPages - 1) { %>
                    <span>...</span>
                <% } %>
                <a href="list_students.jsp?page=<%= totalPages %><%= isSearching ? "&keyword=" + keyword : "" %><%= sortParams %>"><%= totalPages %></a>
            <% } %>
            
            <% if (currentPage < totalPages) { %>
                <a href="list_students.jsp?page=<%= currentPage + 1 %><%= isSearching ? "&keyword=" + keyword : "" %><%= sortParams %>">Next →</a>
            <% } else { %>
                <span class="disabled">Next →</span>
            <% } %>
        </div>
        <% } %>
        
        <% } else { %>
        <p style="text-align: center; padding: 40px; color: #999;">
            📋 No students found. 
            <% if (isSearching) { %>
                Try a different search term.
            <% } else { %>
                Click "Add New Student" to get started!
            <% } %>
        </p>
        <% } %>
        
        <%
            } catch (ClassNotFoundException e) {
        %>
            <div class="error message">
                <strong>Driver Error:</strong> MySQL JDBC driver not found.<br>
                <%= e.getMessage() %>
            </div>
        <%
            } catch (SQLException e) {
        %>
            <div class="error message">
                <strong>Database Error:</strong> Could not connect or query database.<br>
                <%= e.getMessage() %>
            </div>
        <%
            } finally {
                // Close resources
                if (rs != null) try { rs.close(); } catch (SQLException e) {}
                if (countRs != null) try { countRs.close(); } catch (SQLException e) {}
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
                if (countStmt != null) try { countStmt.close(); } catch (SQLException e) {}
                if (conn != null) try { conn.close(); } catch (SQLException e) {}
            }
        %>
    </div>
    
    <!-- Auto-hide messages after 3 seconds -->
    <script>
        setTimeout(function() {
            var messages = document.querySelectorAll('.message');
            messages.forEach(function(msg) {
                msg.style.opacity = '0';
                msg.style.transition = 'opacity 0.5s';
                setTimeout(function() {
                    msg.style.display = 'none';
                }, 500);
            });
        }, 3000);
    </script>
</body>
</html>
