package com.controller;

import com.dao.UserDAO;
import com.model.User;
import org.mindrot.jbcrypt.BCrypt;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Show change password form
        request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get current user from session
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=Session expired.");
            return;
        }

        // Get form parameters
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        String error = null;
        String success = null;

        // 1. Validate current password
        if (!BCrypt.checkpw(currentPassword, currentUser.getPassword())) {
            error = "The current password you entered is incorrect.";
        } 
        
        // 2. Validate new password (length, match)
        else if (newPassword.length() < 8) {
            error = "New password must be at least 8 characters long.";
        } 
        
        // 3. Confirm new password matches
        else if (!newPassword.equals(confirmPassword)) {
            error = "New password and confirmation password do not match.";
        } 
        
        // 4. Update password
        else {
            // Hash new password
            String newHashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            
            // Update in database
            boolean updated = userDAO.updatePassword(currentUser.getId(), newHashedPassword);
            
            if (updated) {
                // Update the user object in session with the new hash (Security improvement: force re-login or update password in session user object)
                currentUser.setPassword(newHashedPassword); 
                session.setAttribute("user", currentUser); // Update session
                success = "Your password has been changed successfully.";
            } else {
                error = "Failed to update password due to a database error.";
            }
        }

        // Show success/error message
        if (error != null) {
            request.setAttribute("error", error);
        }
        if (success != null) {
            request.setAttribute("success", success);
        }
        request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
    }
}