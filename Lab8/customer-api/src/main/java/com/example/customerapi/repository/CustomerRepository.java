package com.example.customerapi.repository;

import com.example.customerapi.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;


@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {

    // Find by customer code
    Optional<Customer> findByCustomerCode(String customerCode);

    // Find by email
    Optional<Customer> findByEmail(String email);

    // Check if customer code exists
    boolean existsByCustomerCode(String customerCode);

    // Check if email exists
    boolean existsByEmail(String email);

    // Find by status
    List<Customer> findByStatus(Customer.CustomerStatus status);

    @Query("SELECT c FROM Customer c WHERE " +
       "LOWER(c.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
       "LOWER(c.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
       "LOWER(c.customerCode) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Customer> searchCustomers(@Param("keyword") String keyword);

    List<Customer> findByStatus(String status);

}
