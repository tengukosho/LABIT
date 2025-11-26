package filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = "/*") // Apply to all requests
public class AuthFilter implements Filter {

    // Define URLs that do NOT require authentication
    private static final String[] PUBLIC_URLS = {
        "/login", 
        "/logout",
        "/css/", 
        "/js/", 
        "/images/"
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("AuthFilter initialized.");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // Get request URI and context path
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length()); // Extract path (e.g., /login, /student)

        // Check if URL is public (i.e., doesn't require login)
        if (isPublicUrl(path)) {
            chain.doFilter(request, response);
            return;
        }

        // Check if user is logged in
        HttpSession session = req.getSession(false); // Get session (false = don't create)
        boolean loggedIn = (session != null && session.getAttribute("user") != null);

        // If logged in, continue
        if (loggedIn) {
            chain.doFilter(request, response);
        } else {
            // If not logged in, redirect to login
            res.sendRedirect(contextPath + "/login?error=Session expired or access denied. Please log in.");
        }
    }
    
    private boolean isPublicUrl(String path) {
        // Simple check: iterate through public URLs and check if the path starts with any of them
        for (String url : PUBLIC_URLS) {
            if (path.startsWith(url)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void destroy() {
        System.out.println("AuthFilter destroyed.");
    }
}