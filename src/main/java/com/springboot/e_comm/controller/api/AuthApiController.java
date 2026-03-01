package com.springboot.e_comm.controller.api;

import com.springboot.e_comm.dto.ApiResponse;
import com.springboot.e_comm.dto.LoginRequest;
import com.springboot.e_comm.dto.LoginResponse;
import com.springboot.e_comm.dto.SignupRequest;
import com.springboot.e_comm.entity.User;
import com.springboot.e_comm.entity.UserRole;
import com.springboot.e_comm.repo.UserRepo;
import com.springboot.e_comm.security.JwtUtil;
import com.springboot.e_comm.service.EmailService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication", description = "Login and signup endpoints")
public class AuthApiController {

    private final UserRepo userRepo;
    private final BCryptPasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final EmailService emailService;

    @PostMapping("/login")
    @Operation(summary = "Login", description = "Login with username and password to get a JWT token")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Login successful"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Invalid credentials"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Validation failed")
    })
    public ResponseEntity<ApiResponse<?>> login(
            @Valid @RequestBody LoginRequest request,
            BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            Map<String, String> errors = new HashMap<>();
            bindingResult.getFieldErrors().forEach(e -> errors.put(e.getField(), e.getDefaultMessage()));
            return ResponseEntity.badRequest().body(ApiResponse.error("Validation failed: " + errors));
        }

        log.info("API login attempt | username: {}", request.getUsername());
        var user = userRepo.findByUsername(request.getUsername());

        if (user.isEmpty() || !passwordEncoder.matches(request.getPassword(), user.get().getPassword())) {
            log.warn("API login failed | username: {}", request.getUsername());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(ApiResponse.error("Invalid username or password"));
        }

        String token = jwtUtil.generateToken(user.get().getUsername(), user.get().getRole().name());
        log.info("API login successful | username: {}", request.getUsername());

        return ResponseEntity.ok(ApiResponse.success("Login successful",
                new LoginResponse(token, user.get().getUsername(), user.get().getRole().name(), "Login successful")));
    }

    @PostMapping("/signup")
    @Operation(summary = "Signup", description = "Register a new user account")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Account created"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "Username or email already taken"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Validation failed")
    })
    public ResponseEntity<ApiResponse<?>> signup(
            @Valid @RequestBody SignupRequest request,
            BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            Map<String, String> errors = new HashMap<>();
            bindingResult.getFieldErrors().forEach(e -> errors.put(e.getField(), e.getDefaultMessage()));
            return ResponseEntity.badRequest().body(ApiResponse.error("Validation failed: " + errors));
        }

        log.info("API signup attempt | username: {}", request.getUsername());

        if (userRepo.existsByUsername(request.getUsername()))
            return ResponseEntity.status(HttpStatus.CONFLICT).body(ApiResponse.error("Username already taken"));

        if (userRepo.existsByEmail(request.getEmail()))
            return ResponseEntity.status(HttpStatus.CONFLICT).body(ApiResponse.error("Email already in use"));

        User newUser = new User();
        newUser.setUsername(request.getUsername());
        newUser.setPassword(passwordEncoder.encode(request.getPassword()));
        newUser.setEmail(request.getEmail());
        newUser.setFirstName(request.getFirstName());
        newUser.setLastName(request.getLastName());
        newUser.setRole(UserRole.USER);
        newUser.setIsActive(true);
        userRepo.save(newUser);
        log.info("API signup successful | username: {}", request.getUsername());

        try { emailService.sendWelcomeEmail(request.getEmail(), request.getFirstName()); }
        catch (Exception e) { log.error("Welcome email failed: {}", e.getMessage()); }

        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success("Account created successfully"));
    }
}