package com.springboot.e_comm.controller;

import com.springboot.e_comm.entity.Order;
import com.springboot.e_comm.entity.OrderItem;
import com.springboot.e_comm.entity.CartItem;
import com.springboot.e_comm.entity.User;
import com.springboot.e_comm.exception.ResourceNotFoundException;
import com.springboot.e_comm.service.OrderService;
import com.springboot.e_comm.service.CartService;
import com.springboot.e_comm.service.EmailService;
import com.springboot.e_comm.repo.UserRepo;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/orders")
public class OrderController {

    private final OrderService orderService;
    private final CartService cartService;
    private final UserRepo userRepo;
    private final EmailService emailService;

    public OrderController(OrderService orderService, CartService cartService,
                           UserRepo userRepo, EmailService emailService) {
        this.orderService = orderService;
        this.cartService = cartService;
        this.userRepo = userRepo;
        this.emailService = emailService;
    }

    @PostMapping("/checkout")
    public String checkout(HttpSession session, Model model) {
        String username = (String) session.getAttribute("loggedInUser");
        if (username == null) return "redirect:/login";

        log.info("Checkout initiated | username: {}", username);

        List<CartItem> cartItems = cartService.getCartItems(username);
        if (cartItems.isEmpty()) {
            log.warn("Checkout failed | empty cart | username: {}", username);
            model.addAttribute("error", "Your cart is empty");
            return "redirect:/cart";
        }

        User user = userRepo.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        Double totalAmount = cartService.getCartTotal(username);

        Order order = new Order();
        order.setUser(user);
        order.setTotalAmount(totalAmount);

        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem cartItem : cartItems) {
            OrderItem orderItem = new OrderItem();
            orderItem.setOrder(order);
            orderItem.setProduct(cartItem.getProduct());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setPrice(cartItem.getProduct().getPrice());
            orderItems.add(orderItem);
        }

        order.setOrderItems(orderItems);
        Order savedOrder = orderService.createOrder(order);
        cartService.clearCart(username);

        log.info("Checkout complete | username: {} | orderId: {} | total: {}", username, savedOrder.getId(), totalAmount);
        return "redirect:/payment/" + savedOrder.getId();
    }

    @GetMapping("/{orderId}/confirmation")
    public String orderConfirmation(@PathVariable Long orderId, HttpSession session, Model model) {
        String username = (String) session.getAttribute("loggedInUser");
        if (username == null) return "redirect:/login";

        Order order = orderService.getOrderById(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Order", orderId));

        if (!order.getUser().getUsername().equals(username)) {
            log.warn("Unauthorized confirmation access | orderId: {} | username: {}", orderId, username);
            return "redirect:/orders/history";
        }

        log.info("Order confirmation viewed | orderId: {} | username: {}", orderId, username);
        String paymentMethod = (String) session.getAttribute("lastPaymentMethod");
        model.addAttribute("paymentMethod", paymentMethod);
        model.addAttribute("order", order);
        session.removeAttribute("lastPaymentMethod");
        return "views/order/confirmation";
    }

    @GetMapping("/history")
    public String orderHistory(HttpSession session, Model model) {
        String username = (String) session.getAttribute("loggedInUser");
        if (username == null) return "redirect:/login";

        User user = userRepo.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        log.info("Order history viewed | username: {}", username);
        List<Order> orders = orderService.getOrdersByUser(user.getId());
        model.addAttribute("orders", orders);
        return "views/order/history";
    }

    @GetMapping("/{orderId}/track")
    public String trackOrder(@PathVariable Long orderId, HttpSession session, Model model) {
        String username = (String) session.getAttribute("loggedInUser");
        if (username == null) return "redirect:/login";

        Order order = orderService.getOrderById(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Order", orderId));

        if (!order.getUser().getUsername().equals(username)) {
            log.warn("Unauthorized track access | orderId: {} | username: {}", orderId, username);
            return "redirect:/orders/history";
        }

        log.info("Order tracking viewed | orderId: {} | username: {}", orderId, username);
        model.addAttribute("order", order);
        return "views/order/tracking";
    }

    @GetMapping("/{orderId}")
    public String orderDetails(@PathVariable Long orderId, HttpSession session, Model model) {
        String username = (String) session.getAttribute("loggedInUser");
        if (username == null) return "redirect:/login";

        Order order = orderService.getOrderById(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Order", orderId));

        if (!order.getUser().getUsername().equals(username)) {
            log.warn("Unauthorized order details access | orderId: {} | username: {}", orderId, username);
            return "redirect:/orders/history";
        }

        log.info("Order details viewed | orderId: {} | username: {}", orderId, username);
        model.addAttribute("order", order);
        return "views/order/details";
    }
}