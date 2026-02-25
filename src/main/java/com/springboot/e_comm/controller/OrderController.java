package com.springboot.e_comm.controller;

import com.springboot.e_comm.entity.Order;
import com.springboot.e_comm.entity.OrderItem;
import com.springboot.e_comm.entity.CartItem;
import com.springboot.e_comm.entity.User;
import com.springboot.e_comm.service.OrderService;
import com.springboot.e_comm.service.CartService;
import com.springboot.e_comm.repo.UserRepo;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/orders")
public class OrderController {

    private final OrderService orderService;
    private final CartService cartService;
    private final UserRepo userRepo;

    public OrderController(OrderService orderService, CartService cartService, UserRepo userRepo) {
        this.orderService = orderService;
        this.cartService = cartService;
        this.userRepo = userRepo;
    }

    // Create order from cart (CHECKOUT)
    @PostMapping("/checkout")
    public String checkout(HttpSession session, Model model) {
        String username = (String) session.getAttribute("loggedInUser");

        if (username == null) {
            return "redirect:/login";
        }

        // Get cart items
        List<CartItem> cartItems = cartService.getCartItems(username);

        if (cartItems.isEmpty()) {
            model.addAttribute("error", "Your cart is empty");
            return "redirect:/cart";
        }

        // Get user
        User user = userRepo.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Calculate total
        Double totalAmount = cartService.getCartTotal(username);

        // Create order
        Order order = new Order();
        order.setUser(user);
        order.setTotalAmount(totalAmount);

        // Convert cart items to order items
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

        // Save order to database
        Order savedOrder = orderService.createOrder(order);

        // Clear cart
        cartService.clearCart(username);

        // Redirect to order confirmation
        return "redirect:/orders/" + savedOrder.getId() + "/confirmation";
    }

    // Show order confirmation
    @GetMapping("/{orderId}/confirmation")
    public String orderConfirmation(
            @PathVariable Long orderId,
            HttpSession session,
            Model model) {

        String username = (String) session.getAttribute("loggedInUser");

        if (username == null) {
            return "redirect:/login";
        }

        Order order = orderService.getOrderById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        // Security check: user can only see their own orders
        if (!order.getUser().getUsername().equals(username)) {
            return "redirect:/orders/history";
        }

        model.addAttribute("order", order);
        return "views/order/confirmation";
    }

    // View order history
    @GetMapping("/history")
    public String orderHistory(HttpSession session, Model model) {
        String username = (String) session.getAttribute("loggedInUser");

        if (username == null) {
            return "redirect:/login";
        }

        User user = userRepo.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        List<Order> orders = orderService.getOrdersByUser(user.getId());

        model.addAttribute("orders", orders);
        return "views/order/history";
    }

    // View order details
    @GetMapping("/{orderId}")
    public String orderDetails(
            @PathVariable Long orderId,
            HttpSession session,
            Model model) {

        String username = (String) session.getAttribute("loggedInUser");

        if (username == null) {
            return "redirect:/login";
        }

        Order order = orderService.getOrderById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        // Security check: user can only see their own orders
        if (!order.getUser().getUsername().equals(username)) {
            return "redirect:/orders/history";
        }

        model.addAttribute("order", order);
        return "views/order/details";
    }
}