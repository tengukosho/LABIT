<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    </head>
<body>
    <div class="container mt-5">
        <div class="card p-4 mx-auto" style="max-width: 400px;">
            <h2 class="card-title text-center">Login</h2>

            <%-- Display error message from controller --%>
            <c:if test="${not empty requestScope.error}">
                <div class="alert alert-danger" role="alert">${requestScope.error}</div>
            </c:if>

            <%-- Display success/logout message from URL parameter --%>
            <c:if test="${not empty param.message}">
                <div class="alert alert-success"> ? ${param.message} </div>
            </c:if>

            <form action="login" method="post">
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" class="form-control" id="username" name="username" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Login</button>
            </form>
            
            <div class="demo-credentials mt-4 border p-3 rounded">
                <h4 class="h6">Demo Credentials:</h4>
                <p>Admin: **admin** / **password123**</p>
                <p>User: **john** / **password123**</p>
                <p>User: **jane** / **password123**</p>
            </div>
        </div>
    </div>
</body>
</html>