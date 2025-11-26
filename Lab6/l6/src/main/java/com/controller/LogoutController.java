package com.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false); // Do not create a new session
        
        if (session != null) {
            session.invalidate(); // Invalidate session
        }
        
        // Redirect to login with success message
        response.sendRedirect(request.getContextPath() + "/login?message=You have been logged out successfully.");
    }
}