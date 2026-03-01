package com.springboot.e_comm.controller;

import com.springboot.e_comm.service.CartService;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Slf4j
@Controller
@RequestMapping("/cart")
public class CartController {

    private final CartService cartService;

    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    @GetMapping
    public String viewCart(HttpSession session, Model model) {
        String username = (String) session.getAttribute("loggedInUser");
        if (username == null) return "redirect:/login";

        log.info("Cart viewed | username: {}", username);
        model.addAttribute("cartItems", cartService.getCartItems(username));
        model.addAttribute("total", cartService.getCartTotal(username));
        model.addAttribute("itemCount", cartService.getCartItemCount(username));
        return "views/cart/list";
    }

    @PostMapping("/add")
    public String addToCart(@RequestParam Long productId,
                            @RequestParam(defaultValue = "1") Integer quantity,
                            HttpSession session) {
        String username = (String) session.getAttribute("loggedInUser");
        if (username == null) return "redirect:/login";

        log.info("Item added to cart | username: {} | productId: {} | qty: {}", username, productId, quantity);
        cartService.addToCart(username, productId, quantity);
        return "redirect:/cart";
    }

    @GetMapping("/remove/{cartItemId}")
    public String removeFromCart(@PathVariable Long cartItemId, HttpSession session) {
        String username = (String) session.getAttribute("loggedInUser");
        if (username == null) return "redirect:/login";

        log.info("Item removed from cart | username: {} | cartItemId: {}", username, cartItemId);
        cartService.removeFromCart(cartItemId);
        return "redirect:/cart";
    }

    @PostMapping("/update/{cartItemId}")
    public String updateQuantity(@PathVariable Long cartItemId,
                                 @RequestParam Integer quantity,
                                 HttpSession session) {
        String username = (String) session.getAttribute("loggedInUser");
        if (username == null) return "redirect:/login";

        if (quantity > 0) {
            log.info("Cart quantity updated | username: {} | cartItemId: {} | qty: {}", username, cartItemId, quantity);
            cartService.updateQuantity(cartItemId, quantity);
        }
        return "redirect:/cart";
    }

    @GetMapping("/clear")
    public String clearCart(HttpSession session) {
        String username = (String) session.getAttribute("loggedInUser");
        if (username == null) return "redirect:/login";

        log.info("Cart cleared | username: {}", username);
        cartService.clearCart(username);
        return "redirect:/cart";
    }
}