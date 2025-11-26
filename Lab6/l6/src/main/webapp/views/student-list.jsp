<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Assuming the 'user' object is stored in the session by the LoginController --%>
<%-- User user = (User) session.getAttribute("user"); --%>

<div class="d-flex justify-content-between mb-3">
    <h2>Student List</h2>
    
    <c:if test="${sessionScope.user.isAdmin()}">
        <a href="student?action=show-add-form" class="btn btn-success">
            <i class="bi bi-plus-circle"></i> Add New Student
        </a>
    </c:if>
</div>

<table class="table table-bordered">
    <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="student" items="${requestScope.studentList}">
            <tr>
                <td><c:out value="${student.id}"/></td>
                <td><c:out value="${student.name}"/></td>
                <td><c:out value="${student.email}"/></td>
                <td>
                    <a href="student?action=view&id=<c:out value='${student.id}'/>" class="btn btn-sm btn-info">View</a>
                    
                    <c:if test="${sessionScope.user.isAdmin()}">
                        <a href="student?action=edit&id=<c:out value='${student.id}'/>" class="btn btn-sm btn-warning">Edit</a>
                        <a href="student?action=delete&id=<c:out value='${student.id}'/>" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this student?');">Delete</a>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>