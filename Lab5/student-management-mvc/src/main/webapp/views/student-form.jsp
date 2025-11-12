<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${student != null}">Edit Student</c:when>
            <c:otherwise>Add New Student</c:otherwise>
        </c:choose>
    </title>
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
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .container {
            max-width: 600px;
            width: 100%;
            background: white;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 1.75em;
            margin-bottom: 8px;
            font-weight: 700;
        }
        
        .header p {
            opacity: 0.95;
            font-size: 0.95em;
        }
        
        .content {
            padding: 40px 30px;
        }
        
        .form-group {
            margin-bottom: 24px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #1e293b;
            font-weight: 600;
            font-size: 0.9em;
        }
        
        .required {
            color: #ef4444;
        }
        
        input[type="text"],
        input[type="email"] {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s;
            background: white;
        }
        
        input[type="text"]:focus,
        input[type="email"]:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }
        
        input[readonly] {
            background-color: #f8fafc;
            color: #64748b;
            cursor: not-allowed;
            border-color: #cbd5e1;
        }
        
        .helper-text {
            display: block;
            margin-top: 6px;
            font-size: 0.8em;
            color: #64748b;
        }
        
        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 32px;
        }
        
        button, .btn-cancel {
            flex: 1;
            padding: 14px 20px;
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-submit {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(59, 130, 246, 0.4);
        }
        
        .btn-submit:active {
            transform: translateY(0);
        }
        
        .btn-cancel {
            background-color: #f1f5f9;
            color: #475569;
            text-decoration: none;
            border: 2px solid #e2e8f0;
        }
        
        .btn-cancel:hover {
            background-color: #e2e8f0;
            border-color: #cbd5e1;
        }
        
        .input-icon {
            position: relative;
        }
        
        .input-icon::before {
            content: "";
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 18px;
            color: #94a3b8;
        }
        
        @media (max-width: 768px) {
            body {
                padding: 0;
            }
            
            .container {
                border-radius: 0;
                min-height: 100vh;
            }
            
            .header h1 {
                font-size: 1.5em;
            }
            
            .content {
                padding: 30px 20px;
            }
            
            .button-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>
                <c:if test="${student != null}">✏️ Edit Student</c:if>
                <c:if test="${student == null}">➕ Add New Student</c:if>
            </h1>
            <p>
                <c:choose>
                    <c:when test="${student != null}">Update student information</c:when>
                    <c:otherwise>Fill in the form to add a new student</c:otherwise>
                </c:choose>
            </p>
        </div>
        
        <div class="content">
            <form action="student" method="POST">
                <!-- Hidden field for action (insert or update) -->
                <input type="hidden" name="action" value="${student != null ? 'update' : 'insert'}">
                
                <!-- Hidden field for id if editing -->
                <c:if test="${student != null}">
                    <input type="hidden" name="id" value="${student.id}">
                </c:if>
                
                <!-- Student Code Field -->
                <div class="form-group">
                    <label for="studentCode">
                        Student Code <span class="required">*</span>
                    </label>
                    <input type="text" 
                           id="studentCode" 
                           name="studentCode" 
                           value="${student != null ? student.studentCode : ''}"
                           placeholder="e.g., ST001, CS123"
                           pattern="[A-Z]{2}[0-9]{3,}"
                           title="Must be 2 uppercase letters followed by at least 3 digits"
                           <c:if test="${student != null}">readonly</c:if>
                           <c:if test="${student == null}">required</c:if>>
                    <span class="helper-text">
                        <c:choose>
                            <c:when test="${student != null}">Student code cannot be changed</c:when>
                            <c:otherwise>Format: 2 uppercase letters + 3+ digits (e.g., ST001)</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                
                <!-- Full Name Field -->
                <div class="form-group">
                    <label for="fullName">
                        Full Name <span class="required">*</span>
                    </label>
                    <input type="text" 
                           id="fullName" 
                           name="fullName" 
                           value="${student != null ? student.fullName : ''}"
                           placeholder="Enter full name"
                           required>
                </div>
                
                <!-- Email Field -->
                <div class="form-group">
                    <label for="email">
                        Email
                    </label>
                    <input type="email" 
                           id="email" 
                           name="email" 
                           value="${student != null ? student.email : ''}"
                           placeholder="Enter email address"
                           pattern="^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"
                           title="Please enter a valid email address">
                    <span class="helper-text">Optional - Must be valid email format if provided</span>
                </div>
                
                <!-- Major Field -->
                <div class="form-group">
                    <label for="major">
                        Major
                    </label>
                    <input type="text" 
                           id="major" 
                           name="major" 
                           value="${student != null ? student.major : ''}"
                           placeholder="Enter major">
                    <span class="helper-text">Optional - e.g., Computer Science, Data Science</span>
                </div>
                
                <!-- Submit Button -->
                <div class="button-group">
                    <button type="submit" class="btn-submit">
                        <c:choose>
                            <c:when test="${student != null}">Update Student</c:when>
                            <c:otherwise>Add Student</c:otherwise>
                        </c:choose>
                    </button>
                    <a href="student?action=list" class="btn-cancel">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
