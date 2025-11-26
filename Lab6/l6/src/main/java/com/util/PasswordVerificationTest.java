package util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Test utility to verify BCrypt password hashing and verification
 * Run this FIRST to make sure BCrypt is working
 */
public class PasswordVerificationTest {
    
    public static void main(String[] args) {
        System.out.println("========================================");
        System.out.println("BCrypt Password Verification Test");
        System.out.println("========================================\n");
        
        // The password we're using
        String plainPassword = "password123";
        
        // The hash that should be in your database
        String expectedHash = "$2a$10$I06PQyIX71eMlJwTtPvFN.y3JFmjfPl4eyiE1AgJLWnexf8Cf8Ige";
        
        System.out.println("Plain password: " + plainPassword);
        System.out.println("Expected hash:  " + expectedHash);
        System.out.println();
        
        // TEST 1: Verify the expected hash works
        System.out.println("TEST 1: Verifying expected hash...");
        try {
            boolean matches = BCrypt.checkpw(plainPassword, expectedHash);
            if (matches) {
                System.out.println("✅ SUCCESS! Password matches the hash");
                System.out.println("   This hash should work in your database");
            } else {
                System.out.println("❌ FAILED! Password does NOT match the hash");
                System.out.println("   Something is wrong with the hash");
            }
        } catch (Exception e) {
            System.out.println("❌ ERROR! BCrypt library problem:");
            e.printStackTrace();
        }
        
        System.out.println();
        
        // TEST 2: Generate a fresh hash
        System.out.println("TEST 2: Generating fresh hash...");
        try {
            String newHash = BCrypt.hashpw(plainPassword, BCrypt.gensalt());
            System.out.println("New hash generated: " + newHash);
            
            // Verify the new hash
            boolean newMatches = BCrypt.checkpw(plainPassword, newHash);
            if (newMatches) {
                System.out.println("✅ New hash verified successfully");
            } else {
                System.out.println("❌ New hash verification failed");
            }
        } catch (Exception e) {
            System.out.println("❌ ERROR! Could not generate hash:");
            e.printStackTrace();
        }
        
        System.out.println();
        System.out.println("========================================");
        System.out.println("INSTRUCTIONS:");
        System.out.println("========================================");
        System.out.println("1. If TEST 1 shows SUCCESS:");
        System.out.println("   - Use this SQL to update your database:");
        System.out.println("   UPDATE users SET password = '" + expectedHash + "' WHERE username = 'admin';");
        System.out.println();
        System.out.println("2. If TEST 1 shows FAILED or ERROR:");
        System.out.println("   - Check that jbcrypt-0.4.jar is in your classpath");
        System.out.println("   - Use the NEW hash from TEST 2 instead");
        System.out.println();
        System.out.println("3. After updating database, try these credentials:");
        System.out.println("   Username: admin");
        System.out.println("   Password: password123");
        System.out.println("========================================");
    }
}
