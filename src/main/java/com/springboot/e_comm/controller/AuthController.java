package com.springboot.e_comm.controller;

import com.springboot.e_comm.entity.User;
import com.springboot.e_comm.entity.UserRole;
import com.springboot.e_comm.repo.UserRepo;
import com.springboot.e_comm.service.EmailService;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Slf4j
@Controller
public class AuthController {

    private final UserRepo userRepository;
    private final BCryptPasswordEncoder passwordEncoder;
    private final EmailService emailService;

    public AuthController(UserRepo userRepository, BCryptPasswordEncoder passwordEncoder,
                          EmailService emailService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.emailService = emailService;
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @PostMapping("/api/login")
    @ResponseBody
    public String apiLogin(@RequestParam String username, @RequestParam String password, HttpSession session) {
        log.info("Login attempt for username: {}", username);
        try {
            var user = userRepository.findByUsername(username);
            if (user.isPresent() && passwordEncoder.matches(password, user.get().getPassword())) {
                session.setAttribute("loggedInUser", user.get().getUsername());
                session.setAttribute("userRole", user.get().getRole().name());
                log.info("Login successful for username: {} | role: {}", username, user.get().getRole());
                return "LOGIN_SUCCESS";
            }
            log.warn("Login failed for username: {} | invalid credentials", username);
            return "LOGIN_FAILED";
        } catch (Exception e) {
            log.error("Login error for username: {} | error: {}", username, e.getMessage());
            return "LOGIN_FAILED";
        }
    }

    @PostMapping("/api/signup")
    @ResponseBody
    public String signup(@RequestParam String username,
                         @RequestParam String password,
                         @RequestParam String email,
                         @RequestParam String firstName,
                         @RequestParam String lastName) {
        log.info("Signup attempt | username: {} | email: {}", username, email);
        try {
            if (userRepository.findByUsername(username).isPresent()) {
                log.warn("Signup failed | username already taken: {}", username);
                return "USERNAME_TAKEN";
            }

            User newUser = new User();
            newUser.setUsername(username);
            newUser.setPassword(passwordEncoder.encode(password));
            newUser.setEmail(email);
            newUser.setFirstName(firstName);
            newUser.setLastName(lastName);
            newUser.setRole(UserRole.USER);
            newUser.setIsActive(true);
            userRepository.save(newUser);
            log.info("New user registered | username: {} | email: {}", username, email);

            try {
                emailService.sendWelcomeEmail(email, firstName);
            } catch (Exception e) {
                log.error("Welcome email failed for: {} | error: {}", email, e.getMessage());
            }

            return "SIGNUP_SUCCESS";
        } catch (Exception e) {
            log.error("Signup error | username: {} | error: {}", username, e.getMessage());
            return "SIGNUP_FAILED";
        }
    }

    @GetMapping("/success")
    public String success(HttpSession session) {
        if (session.getAttribute("loggedInUser") == null) {
            return "redirect:/login";
        }
        return "redirect:/products";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        String username = (String) session.getAttribute("loggedInUser");
        log.info("User logged out: {}", username);
        session.invalidate();
        return "redirect:/login";
    }

    @GetMapping("/test")
    public String test() {
        return "test";
    }
}