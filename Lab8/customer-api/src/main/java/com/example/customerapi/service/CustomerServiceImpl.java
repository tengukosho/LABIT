package com.example.customerapi.service;

import com.example.customerapi.dto.CustomerRequestDTO;
import com.example.customerapi.dto.CustomerResponseDTO;
import com.example.customerapi.dto.CustomerUpdateDTO;
import com.example.customerapi.entity.Customer;
import com.example.customerapi.repository.CustomerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class CustomerServiceImpl implements CustomerService {

    private final CustomerRepository customerRepository;

    @Autowired
    public CustomerServiceImpl(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

    @Override
    public CustomerResponseDTO getCustomerById(Long id) {
        Customer customer = customerRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Customer not found with id: " + id));
        return convertToResponseDTO(customer);
    }

    @Override
    public CustomerResponseDTO createCustomer(CustomerRequestDTO requestDTO) {

        if (customerRepository.existsByCustomerCode(requestDTO.getCustomerCode())) {
            throw new RuntimeException("Customer code already exists");
        }

        if (customerRepository.existsByEmail(requestDTO.getEmail())) {
            throw new RuntimeException("Email already exists");
        }

        Customer customer = convertToEntity(requestDTO);
        Customer saved = customerRepository.save(customer);

        return convertToResponseDTO(saved);
    }

    @Override
    public CustomerResponseDTO updateCustomer(Long id, CustomerRequestDTO requestDTO) {

        Customer customer = customerRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Customer not found with id: " + id));

        // Prevent duplicate email on update
        if (!customer.getEmail().equals(requestDTO.getEmail())
                && customerRepository.existsByEmail(requestDTO.getEmail())) {
            throw new RuntimeException("Email already exists");
        }

        customer.setCustomerCode(requestDTO.getCustomerCode());
        customer.setFullName(requestDTO.getFullName());
        customer.setEmail(requestDTO.getEmail());
        customer.setPhone(requestDTO.getPhone());
        customer.setAddress(requestDTO.getAddress());
        customer.setStatus(Customer.CustomerStatus.valueOf(requestDTO.getStatus()));

        Customer updated = customerRepository.save(customer);
        return convertToResponseDTO(updated);
    }

    @Override
    public void deleteCustomer(Long id) {

        if (!customerRepository.existsById(id)) {
            throw new RuntimeException("Customer not found with id: " + id);
        }

        customerRepository.deleteById(id);
    }
    @Override
    public List<CustomerResponseDTO> searchCustomers(String keyword) {
        List<Customer> customers = customerRepository.searchCustomers(keyword);
        return customers.stream()
            .map(this::convertToResponseDTO)
            .collect(Collectors.toList());
    }
    @Override
    public List<CustomerResponseDTO> getCustomersByStatus(String status) {
        List<Customer> customers = customerRepository.findByStatus(status.toUpperCase());
        return customers.stream()
            .map(this::convertToResponseDTO)
            .collect(Collectors.toList());
    }
    @Override
    public List<CustomerResponseDTO> advancedSearch(String name, String email, String status) {
        List<Customer> customers = customerRepository.findAll();

        return customers.stream()
            .filter(c -> name == null || c.getFullName().toLowerCase().contains(name.toLowerCase()))
            .filter(c -> email == null || c.getEmail().toLowerCase().contains(email.toLowerCase()))
            .filter(c -> status == null || c.getStatus().name().equalsIgnoreCase(status))
            .map(this::convertToResponseDTO)
            .collect(Collectors.toList());
    }
    @Override
    public Page<CustomerResponseDTO> getAllCustomers(int page, int size, String sortBy, String sortDir) {

        Sort sort = sortDir.equalsIgnoreCase("asc")
            ? Sort.by(sortBy).ascending()
            : Sort.by(sortBy).descending();

        Pageable pageable = PageRequest.of(page, size, sort);

        return customerRepository.findAll(pageable)
            .map(this::convertToResponseDTO);
    }
    @Override
    public CustomerResponseDTO partialUpdateCustomer(Long id, CustomerUpdateDTO updateDTO) {
        Customer customer = customerRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Customer not found with id: " + id));

        if (updateDTO.getFullName() != null) customer.setFullName(updateDTO.getFullName());
        if (updateDTO.getEmail() != null) customer.setEmail(updateDTO.getEmail());
        if (updateDTO.getPhone() != null) customer.setPhone(updateDTO.getPhone());
        if (updateDTO.getAddress() != null) customer.setAddress(updateDTO.getAddress());

        Customer updated = customerRepository.save(customer);
        return convertToResponseDTO(updated);
    }

    // ------------------------------
    // Helper: Convert Entity → DTO
    // ------------------------------
    private CustomerResponseDTO convertToResponseDTO(Customer customer) {
        return new CustomerResponseDTO(
                customer.getId(),
                customer.getCustomerCode(),
                customer.getFullName(),
                customer.getEmail(),
                customer.getPhone(),
                customer.getAddress(),
                customer.getStatus().name(),
                customer.getCreatedAt()
        );
    }

    // ------------------------------
    // Helper: Convert DTO → Entity
    // ------------------------------
    private Customer convertToEntity(CustomerRequestDTO dto) {
        return new Customer(
                dto.getCustomerCode(),
                dto.getFullName(),
                dto.getEmail(),
                dto.getPhone(),
                dto.getAddress(),
                Customer.CustomerStatus.valueOf(dto.getStatus())
        );
    }
}
