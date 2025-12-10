package com.example.customerapi.service;

import com.example.customerapi.dto.CustomerRequestDTO;
import com.example.customerapi.dto.CustomerResponseDTO;
import com.example.customerapi.entity.Customer;
import com.example.customerapi.repository.CustomerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
    public List<CustomerResponseDTO> getAllCustomers() {
        return customerRepository.findAll()
                .stream()
                .map(this::convertToResponseDTO)
                .collect(Collectors.toList());
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
