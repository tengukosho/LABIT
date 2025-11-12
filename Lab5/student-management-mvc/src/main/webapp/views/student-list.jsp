<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List - MVC</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #f0f2f5;
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .header {
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            margin-bottom: 24px;
            border-left: 5px solid #3b82f6;
        }
        
        .header h1 {
            font-size: 2em;
            color: #1e293b;
            margin-bottom: 8px;
            font-weight: 700;
        }
        
        .header p {
            color: #64748b;
            font-size: 1em;
        }
        
        .content {
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }
        
        .message {
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 500;
            animation: slideDown 0.3s ease-out;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .success {
            background-color: #ecfdf5;
            color: #047857;
            border: 1px solid #d1fae5;
        }
        
        .success::before {
            content: "✓";
            font-size: 18px;
            background: #047857;
            color: white;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .error {
            background-color: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }
        
        .error::before {
            content: "✗";
            font-size: 18px;
            background: #dc2626;
            color: white;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .btn-add {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 10px;
            margin-bottom: 24px;
            font-weight: 600;
            transition: all 0.3s;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }
        
        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(59, 130, 246, 0.4);
        }
        
        .btn-add::before {
            content: "➕";
            font-size: 16px;
        }
        
        .table-container {
            overflow-x: auto;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        thead {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
        }
        
        th {
            padding: 16px;
            text-align: left;
            font-weight: 600;
            font-size: 0.875em;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        
        td {
            padding: 16px;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
        }
        
        tbody tr {
            transition: background-color 0.2s;
        }
        
        tbody tr:hover {
            background-color: #f8fafc;
        }
        
        tbody tr:last-child td {
            border-bottom: none;
        }
        
        .action-links {
            display: flex;
            gap: 8px;
        }
        
        .btn-edit, .btn-delete {
            padding: 8px 16px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 0.875em;
            font-weight: 500;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        
        .btn-edit {
            background: #eff6ff;
            color: #3b82f6;
            border: 1px solid #dbeafe;
        }
        
        .btn-edit:hover {
            background: #dbeafe;
            border-color: #3b82f6;
        }
        
        .btn-delete {
            background: #fef2f2;
            color: #ef4444;
            border: 1px solid #fecaca;
        }
        
        .btn-delete:hover {
            background: #fecaca;
            border-color: #ef4444;
        }
        
        .empty-state {
            text-align: center;
            padding: 80px 20px;
        }
        
        .empty-state-icon {
            font-size: 5em;
            margin-bottom: 20px;
            opacity: 0.3;
        }
        
        .empty-state h3 {
            color: #64748b;
            font-size: 1.5em;
            margin-bottom: 8px;
        }
        
        .empty-state p {
            color: #94a3b8;
        }
        
        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.75em;
            font-weight: 600;
            background: #f1f5f9;
            color: #475569;
        }
        
        @media (max-width: 768px) {
            .header h1 {
                font-size: 1.5em;
            }
            
            .content {
                padding: 16px;
            }
            
            th, td {
                padding: 12px 8px;
                font-size: 0.875em;
            }
            
            .action-links {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📚 Student Management System (MVC)</h1>
            <p>View and manage student records</p>
        </div>
        
        <div class="content">
            <!-- Display success message if exists -->
            <c:if test="${not empty sessionScope.message}">
                <div class="message success">
                    ${sessionScope.message}
                </div>
                <c:remove var="message" scope="session"/>
            </c:if>
            
            <!-- Display error message if exists -->
            <c:if test="${not empty sessionScope.error}">
                <div class="message error">
                    ${sessionScope.error}
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>
            
            <!-- Add New Student Button -->
            <a href="student?action=new" class="btn-add">+ Add New Student</a>
            
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Student Code</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Major</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Loop through students using c:forEach -->
                        <c:forEach var="student" items="${students}">
                            <tr>
                                <td>${student.id}</td>
                                <td>${student.studentCode}</td>
                                <td>${student.fullName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty student.email}">
                                            ${student.email}
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">N/A</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty student.major}">
                                            ${student.major}
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">N/A</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-links">
                                        <a href="student?action=edit&id=${student.id}" class="btn-edit">✏️ Edit</a>
                                        <a href="student?action=delete&id=${student.id}" 
                                           class="btn-delete"
                                           onclick="return confirm('Are you sure you want to delete this student?')">🗑️ Delete</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <!-- Handle empty list -->
                        <c:if test="${empty students}">
                            <tr>
                                <td colspan="6" class="empty-state">
                                    <div class="empty-state-icon">📋</div>
                                    <h3>No Students Found</h3>
                                    <p>Click "Add New Student" to get started!</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
