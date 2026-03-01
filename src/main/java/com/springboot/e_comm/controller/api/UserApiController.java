package com.springboot.e_comm.controller.api;

import com.springboot.e_comm.dto.ApiResponse;
import com.springboot.e_comm.entity.User;
import com.springboot.e_comm.exception.ResourceNotFoundException;
import com.springboot.e_comm.repo.UserRepo;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
@Tag(name = "Users", description = "User management — all endpoints require JWT token")
@SecurityRequirement(name = "Bearer Authentication")
public class UserApiController {

    private final UserRepo userRepo;

    @GetMapping
    @Operation(summary = "Get all users (Admin)", description = "Admin only — returns list of all users")
    public ResponseEntity<ApiResponse<List<User>>> getAllUsers(HttpServletRequest request) {
        String role = (String) request.getAttribute("jwtRole");
        if (!"ADMIN".equals(role))
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error("Admin access required"));

        return ResponseEntity.ok(ApiResponse.success("Users fetched", userRepo.findAll()));
    }

    @GetMapping("/me")
    @Operation(summary = "Get my profile", description = "Returns logged-in user's profile")
    public ResponseEntity<ApiResponse<User>> getMyProfile(HttpServletRequest request) {
        String username = (String) request.getAttribute("jwtUsername");
        User user = userRepo.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        return ResponseEntity.ok(ApiResponse.success("Profile fetched", user));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get user by ID (Admin)", description = "Admin only")
    public ResponseEntity<ApiResponse<User>> getUserById(@PathVariable Long id, HttpServletRequest request) {
        String role = (String) request.getAttribute("jwtRole");
        if (!"ADMIN".equals(role))
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error("Admin access required"));

        User user = userRepo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User", id));
        return ResponseEntity.ok(ApiResponse.success("User found", user));
    }

    @PatchMapping("/{id}/activate")
    @Operation(summary = "Activate user (Admin)", description = "Admin only — activate a user account")
    public ResponseEntity<ApiResponse<String>> activateUser(@PathVariable Long id, HttpServletRequest request) {
        String role = (String) request.getAttribute("jwtRole");
        if (!"ADMIN".equals(role))
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error("Admin access required"));

        User user = userRepo.findById(id).orElseThrow(() -> new ResourceNotFoundException("User", id));
        user.setIsActive(true);
        userRepo.save(user);
        log.info("User activated | id: {}", id);
        return ResponseEntity.ok(ApiResponse.success("User activated"));
    }

    @PatchMapping("/{id}/deactivate")
    @Operation(summary = "Deactivate user (Admin)", description = "Admin only — deactivate a user account")
    public ResponseEntity<ApiResponse<String>> deactivateUser(@PathVariable Long id, HttpServletRequest request) {
        String role = (String) request.getAttribute("jwtRole");
        if (!"ADMIN".equals(role))
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error("Admin access required"));

        User user = userRepo.findById(id).orElseThrow(() -> new ResourceNotFoundException("User", id));
        user.setIsActive(false);
        userRepo.save(user);
        log.info("User deactivated | id: {}", id);
        return ResponseEntity.ok(ApiResponse.success("User deactivated"));
    }
}