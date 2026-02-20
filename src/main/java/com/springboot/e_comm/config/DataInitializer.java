package com.springboot.e_comm.config;


import com.springboot.e_comm.entity.User;
import com.springboot.e_comm.entity.UserRole;
import com.springboot.e_comm.repo.UserRepo;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * Initializes sample data on application startup
 */
@Configuration
@RequiredArgsConstructor
public class DataInitializer {

    private final UserRepo userRepository;
    private final PasswordEncoder passwordEncoder;

    @Bean
    public CommandLineRunner initData() {
        return args -> {
            // Check if admin user already exists
            if (userRepository.findByUsername("admin").isEmpty()) {

                // Create admin user
                User admin = User.builder()
                        .username("admin")
                        .email("admin@ecommerce.com")
                        .password(passwordEncoder.encode("admin123"))
                        .firstName("Admin")
                        .lastName("User")
                        .phone("+1234567890")
                        .role(UserRole.ADMIN)
                        .isActive(true)
                        .build();

                userRepository.save(admin);
                System.out.println("✅ Admin user created!");
            }

            // Create test customer
            if (userRepository.findByUsername("john").isEmpty()) {
                User customer = User.builder()
                        .username("john")
                        .email("john@example.com")
                        .password(passwordEncoder.encode("password123"))
                        .firstName("John")
                        .lastName("Doe")
                        .phone("+9876543210")
                        .role(UserRole.USER)
                        .isActive(true)
                        .build();

                userRepository.save(customer);
                System.out.println("✅ Test customer created!");
            }

            System.out.println("✅ Sample data initialization complete!");
        };
    }
}
