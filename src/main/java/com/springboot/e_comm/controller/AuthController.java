package com.springboot.e_comm.controller;

import com.springboot.e_comm.repo.UserRepo;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class AuthController {

    private final UserRepo userRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    public AuthController(UserRepo userRepository, BCryptPasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @PostMapping("/api/login")
    @ResponseBody
    public String apiLogin(@RequestParam String username, @RequestParam String password, HttpSession session) {
        try {
            var user = userRepository.findByUsername(username);

            if (user.isPresent() && passwordEncoder.matches(password, user.get().getPassword())) {
                session.setAttribute("loggedInUser", user.get().getUsername());
                session.setAttribute("userRole", user.get().getRole());
                return "LOGIN_SUCCESS";
            }
            return "LOGIN_FAILED";
        } catch (Exception e) {
            return "LOGIN_FAILED";
        }
    }

    @GetMapping("/success")
    public String success(HttpSession session) {
        if (session.getAttribute("loggedInUser") == null) {
            return "redirect:/login";
        }
        return "success";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
    @GetMapping("/test")
    public String test() {
        return "test";
    }
}