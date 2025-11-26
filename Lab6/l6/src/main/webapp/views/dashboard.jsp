<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    </head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="#">Admin Panel</a>
            <div class="d-flex">
                <span class="navbar-text me-3">
                    Logged in as: <strong>${sessionScope.fullName}</strong>
                </span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light">
                    <i class="bi bi-box-arrow-right"></i> Logout </a>
            </div>
        </div>
    </nav>
    <div class="container mt-4">
        <h1>Welcome, ${sessionScope.fullName}!</h1> <p>This is the protected Admin Dashboard.</p>
        <p>Your Role: <strong>${sessionScope.role}</strong></p>
        
        <div class="mt-4">
            <h2>Quick Links</h2>
            <a href="${pageContext.request.contextPath}/student" class="btn btn-info">Manage Students</a>
            <a href="${pageContext.request.contextPath}/change-password" class="btn btn-secondary">Change Password</a>
            </div>
    </div>
</body>
</html>