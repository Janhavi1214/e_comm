package com.springboot.e_comm.controller;

import com.springboot.e_comm.service.CartService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/cart")
public class CartController {

    private final CartService cartService;

    // Constructor - Spring injects CartService
    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    // Display cart page
    @GetMapping
    public String viewCart(HttpSession session, Model model) {
        String username = (String) session.getAttribute("loggedInUser");

        if (username == null) {
            return "redirect:/login";
        }

        model.addAttribute("cartItems", cartService.getCartItems(username));
        model.addAttribute("total", cartService.getCartTotal(username));
        model.addAttribute("itemCount", cartService.getCartItemCount(username));

        return "views/cart/list";
    }

    // Add product to cart
    @PostMapping("/add")
    public String addToCart(
            @RequestParam Long productId,
            @RequestParam(defaultValue = "1") Integer quantity,
            HttpSession session) {

        String username = (String) session.getAttribute("loggedInUser");

        if (username == null) {
            return "redirect:/login";
        }

        cartService.addToCart(username, productId, quantity);
        return "redirect:/cart";
    }

    // Remove item from cart
    @GetMapping("/remove/{cartItemId}")
    public String removeFromCart(
            @PathVariable Long cartItemId,
            HttpSession session) {

        String username = (String) session.getAttribute("loggedInUser");

        if (username == null) {
            return "redirect:/login";
        }

        cartService.removeFromCart(cartItemId);
        return "redirect:/cart";
    }

    // Update quantity
    @PostMapping("/update/{cartItemId}")
    public String updateQuantity(
            @PathVariable Long cartItemId,
            @RequestParam Integer quantity,
            HttpSession session) {

        String username = (String) session.getAttribute("loggedInUser");

        if (username == null) {
            return "redirect:/login";
        }

        if (quantity > 0) {
            cartService.updateQuantity(cartItemId, quantity);
        }

        return "redirect:/cart";
    }

    // Clear entire cart
    @GetMapping("/clear")
    public String clearCart(HttpSession session) {
        String username = (String) session.getAttribute("loggedInUser");

        if (username == null) {
            return "redirect:/login";
        }

        cartService.clearCart(username);
        return "redirect:/cart";
    }
}