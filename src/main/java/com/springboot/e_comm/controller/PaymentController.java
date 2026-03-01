package com.springboot.e_comm.controller;

import com.springboot.e_comm.entity.Order;
import com.springboot.e_comm.entity.OrderStatus;
import com.springboot.e_comm.exception.ResourceNotFoundException;
import com.springboot.e_comm.service.OrderService;
import com.springboot.e_comm.service.EmailService;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Slf4j
@Controller
@RequestMapping("/payment")
public class PaymentController {

    private final OrderService orderService;
    private final EmailService emailService;

    public PaymentController(OrderService orderService, EmailService emailService) {
        this.orderService = orderService;
        this.emailService = emailService;
    }

    @GetMapping("/{orderId}")
    public String showPaymentPage(@PathVariable Long orderId, HttpSession session, Model model) {
        String username = (String) session.getAttribute("loggedInUser");
        if (username == null) return "redirect:/login";

        log.info("Payment page accessed | orderId: {} | username: {}", orderId, username);

        Order order = orderService.getOrderById(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Order", orderId));

        if (!order.getUser().getUsername().equals(username)) {
            log.warn("Unauthorized payment page access | orderId: {} | username: {}", orderId, username);
            return "redirect:/orders/history";
        }

        if (order.getStatus() == OrderStatus.CONFIRMED) {
            log.info("Order already confirmed, redirecting | orderId: {}", orderId);
            return "redirect:/orders/" + orderId + "/confirmation";
        }

        model.addAttribute("order", order);
        return "views/payment/payment";
    }

    @PostMapping("/process")
    public String processPayment(
            @RequestParam Long orderId,
            @RequestParam String paymentMethod,
            @RequestParam(required = false) String cardNumber,
            @RequestParam(required = false) String cardHolder,
            @RequestParam(required = false) String expiry,
            @RequestParam(required = false) String cvv,
            @RequestParam(required = false) String upiId,
            @RequestParam(required = false) String bank,
            HttpSession session,
            Model model) {

        String username = (String) session.getAttribute("loggedInUser");
        if (username == null) return "redirect:/login";

        log.info("Payment processing | orderId: {} | method: {} | username: {}", orderId, paymentMethod, username);

        Order order = orderService.getOrderById(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Order", orderId));

        if (!order.getUser().getUsername().equals(username)) {
            log.warn("Unauthorized payment attempt | orderId: {} | username: {}", orderId, username);
            return "redirect:/orders/history";
        }

        String paymentError = validatePayment(paymentMethod, cardNumber, cardHolder, expiry, cvv, upiId, bank);
        if (paymentError != null) {
            log.warn("Payment validation failed | orderId: {} | method: {} | reason: {}", orderId, paymentMethod, paymentError);
            model.addAttribute("order", order);
            model.addAttribute("paymentError", paymentError);
            return "views/payment/payment";
        }

        orderService.updateOrderStatus(orderId, OrderStatus.CONFIRMED);
        log.info("Payment successful | orderId: {} | method: {} | amount: {}", orderId, paymentMethod, order.getTotalAmount());

        try {
            emailService.sendOrderConfirmationEmail(order.getUser().getEmail(), orderId, order.getTotalAmount());
        } catch (Exception e) {
            log.error("Confirmation email failed | orderId: {} | error: {}", orderId, e.getMessage());
        }

        session.setAttribute("lastPaymentMethod", paymentMethod);
        return "redirect:/orders/" + orderId + "/confirmation";
    }

    private String validatePayment(String method, String cardNumber, String cardHolder,
                                   String expiry, String cvv, String upiId, String bank) {
        switch (method) {
            case "CARD":
                if (cardNumber == null || cardNumber.replaceAll("\\s", "").length() < 16)
                    return "Please enter a valid 16-digit card number.";
                if (cardHolder == null || cardHolder.trim().isEmpty())
                    return "Please enter the cardholder name.";
                if (expiry == null || expiry.trim().isEmpty())
                    return "Please enter the expiry date.";
                if (cvv == null || cvv.trim().length() < 3)
                    return "Please enter a valid CVV.";
                break;
            case "UPI":
                if (upiId == null || !upiId.contains("@"))
                    return "Please enter a valid UPI ID (e.g. name@upi).";
                break;
            case "NETBANKING":
                if (bank == null || bank.trim().isEmpty())
                    return "Please select your bank.";
                break;
            case "COD":
                break;
            default:
                return "Please select a payment method.";
        }
        return null;
    }
}