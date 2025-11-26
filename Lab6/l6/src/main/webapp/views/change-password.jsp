<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Change Password</title>
    </head>
<body>
    <div class="container mt-5">
        <div class="card p-4 mx-auto" style="max-width: 450px;">
            <h2 class="card-title text-center">Change Password</h2>

            <%-- Display messages --%>
            <c:if test="${not empty requestScope.error}">
                <div class="alert alert-danger" role="alert">${requestScope.error}</div>
            </c:if>
            <c:if test="${not empty requestScope.success}">
                <div class="alert alert-success" role="alert">${requestScope.success}</div>
            </c:if>

            <form action="change-password" method="post">
                <div class="mb-3">
                    <label for="currentPassword" class="form-label">Current Password</label>
                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                </div>
                <div class="mb-3">
                    <label for="newPassword" class="form-label">New Password (Min 8 characters)</label>
                    <input type="password" class="form-control" id="newPassword" name="newPassword" required minlength="8">
                </div>
                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required minlength="8">
                </div>
                <button type="submit" class="btn btn-primary w-100">Change Password</button>
            </form>
            
            <div class="mt-3 text-center">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-link">Back to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>