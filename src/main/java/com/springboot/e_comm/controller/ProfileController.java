package com.springboot.e_comm.controller;

import com.springboot.e_comm.entity.User;
import com.springboot.e_comm.exception.ResourceNotFoundException;
import com.springboot.e_comm.service.UserService;
import com.springboot.e_comm.repo.UserRepo;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Slf4j
@Controller
@RequestMapping("/profile")
public class ProfileController {

    private final UserService userService;
    private final UserRepo userRepo;

    public ProfileController(UserService userService, UserRepo userRepo) {
        this.userService = userService;
        this.userRepo = userRepo;
    }

    @GetMapping
    public String viewProfile(HttpSession session, Model model) {
        String username = (String) session.getAttribute("loggedInUser");
        if (username == null) return "redirect:/login";
        log.info("Profile viewed | username: {}", username);
        User user = userRepo.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        model.addAttribute("user", user);
        return "views/user/profile";
    }

    @PostMapping("/update")
    public String updateProfile(@RequestParam String firstName, @RequestParam String lastName,
                                @RequestParam String email, @RequestParam(required = false) String phone,
                                HttpSession session, RedirectAttributes redirectAttributes) {
        String username = (String) session.getAttribute("loggedInUser");
        if (username == null) return "redirect:/login";
        log.info("Profile update attempt | username: {}", username);
        try {
            User user = userRepo.findByUsername(username)
                    .orElseThrow(() -> new ResourceNotFoundException("User not found"));
            if (!user.getEmail().equals(email) && userRepo.existsByEmail(email)) {
                log.warn("Profile update failed | email taken: {} | username: {}", email, username);
                redirectAttributes.addFlashAttribute("error", "Email already in use by another account.");
                return "redirect:/profile";
            }
            User updatedDetails = new User();
            updatedDetails.setFirstName(firstName);
            updatedDetails.setLastName(lastName);
            updatedDetails.setEmail(email);
            updatedDetails.setPhone(phone);
            userService.updateUser(user.getId(), updatedDetails);
            log.info("Profile updated successfully | username: {}", username);
            redirectAttributes.addFlashAttribute("success", "Profile updated successfully!");
        } catch (ResourceNotFoundException e) {
            throw e;
        } catch (Exception e) {
            log.error("Profile update error | username: {} | error: {}", username, e.getMessage());
            redirectAttributes.addFlashAttribute("error", "Failed to update profile: " + e.getMessage());
        }
        return "redirect:/profile";
    }

    @PostMapping("/change-password")
    public String changePassword(@RequestParam String oldPassword, @RequestParam String newPassword,
                                 @RequestParam String confirmPassword, HttpSession session, RedirectAttributes redirectAttributes) {
        String username = (String) session.getAttribute("loggedInUser");
        if (username == null) return "redirect:/login";
        log.info("Password change attempt | username: {}", username);
        try {
            if (!newPassword.equals(confirmPassword)) {
                redirectAttributes.addFlashAttribute("passwordError", "New passwords do not match.");
                return "redirect:/profile";
            }
            if (newPassword.length() < 6) {
                redirectAttributes.addFlashAttribute("passwordError", "Password must be at least 6 characters.");
                return "redirect:/profile";
            }
            User user = userRepo.findByUsername(username)
                    .orElseThrow(() -> new ResourceNotFoundException("User not found"));
            userService.changePassword(user.getId(), oldPassword, newPassword);
            log.info("Password changed successfully | username: {}", username);
            redirectAttributes.addFlashAttribute("passwordSuccess", "Password changed successfully!");
        } catch (IllegalArgumentException e) {
            log.warn("Password change failed | username: {} | reason: {}", username, e.getMessage());
            redirectAttributes.addFlashAttribute("passwordError", e.getMessage());
        }
        return "redirect:/profile";
    }
}