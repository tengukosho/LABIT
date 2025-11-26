package filter;

import com.model.User;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

// Apply filter only to the StudentController servlet (or the main controller that handles admin actions)
@WebFilter(urlPatterns = "/student") 
public class AdminFilter implements Filter {

    // Define actions that ONLY an admin should be able to perform
    private static final String[] ADMIN_ACTIONS = {
        "add", 
        "insert", 
        "edit", 
        "update", 
        "delete"
    };

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        // 1. Get the action parameter
        String action = req.getParameter("action");
        
        // Check if the current request is an Admin-only action
        if (action != null && isAdminAction(action)) {
            
            // 2. Retrieve user object from session
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            
            // 3. Check if user is logged in AND is an admin
            if (user != null && user.isAdmin()) {
                // Allow access
                chain.doFilter(request, response);
            } else {
                // Deny access
                String errorMsg = "Authorization denied: You do not have permission to perform this action.";
                
                // Redirect with error message
                // For a /student path, we redirect to a safe page (e.g., list view)
                res.sendRedirect(req.getContextPath() + "/student?error=" + 
                    java.net.URLEncoder.encode(errorMsg, "UTF-8"));
            }
        } else {
            // Not an admin action (e.g., list/view), allow
            chain.doFilter(request, response);
        }
    }
    
    private boolean isAdminAction(String action) {
        // Check if action is in ADMIN_ACTIONS array
        for (String adminAction : ADMIN_ACTIONS) {
            if (adminAction.equalsIgnoreCase(action)) {
                return true;
            }
        }
        return false;
    }

    // init() and destroy() methods omitted for brevity
}