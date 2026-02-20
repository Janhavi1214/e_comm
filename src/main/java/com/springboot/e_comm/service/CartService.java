package com.springboot.e_comm.service;

import com.springboot.e_comm.entity.CartItem;
import com.springboot.e_comm.entity.Product;
import com.springboot.e_comm.entity.User;
import com.springboot.e_comm.repo.CartItemRepo;
import com.springboot.e_comm.repo.ProductRepo;
import com.springboot.e_comm.repo.UserRepo;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CartService {

    private final CartItemRepo cartItemRepo;
    private final ProductRepo productRepo;
    private final UserRepo userRepo;

    // Constructor - Spring injects the repositories
    public CartService(CartItemRepo cartItemRepo, ProductRepo productRepo, UserRepo userRepo) {
        this.cartItemRepo = cartItemRepo;
        this.productRepo = productRepo;
        this.userRepo = userRepo;
    }

    // Get all cart items for a user
    public List<CartItem> getCartItems(String username) {
        User user = userRepo.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return cartItemRepo.findByUser(user);
    }

    // Add product to cart (or increase quantity if already there)
    public void addToCart(String username, Long productId, Integer quantity) {
        User user = userRepo.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Product product = productRepo.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        var existingItem = cartItemRepo.findByUserAndProductId(user, productId);

        if (existingItem.isPresent()) {
            // Product already in cart - increase quantity
            CartItem item = existingItem.get();
            item.setQuantity(item.getQuantity() + quantity);
            cartItemRepo.save(item);
        } else {
            // Product not in cart - create new CartItem
            CartItem newItem = new CartItem();
            newItem.setUser(user);
            newItem.setProduct(product);
            newItem.setQuantity(quantity);
            cartItemRepo.save(newItem);
        }
    }

    // Remove a specific item from cart
    public void removeFromCart(Long cartItemId) {
        cartItemRepo.deleteById(cartItemId);
    }

    // Update quantity of an item in cart
    public void updateQuantity(Long cartItemId, Integer quantity) {
        CartItem item = cartItemRepo.findById(cartItemId)
                .orElseThrow(() -> new RuntimeException("Cart item not found"));
        item.setQuantity(quantity);
        cartItemRepo.save(item);
    }

    // Clear all items from user's cart
    public void clearCart(String username) {
        User user = userRepo.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        cartItemRepo.deleteByUser(user);
    }

    // Calculate total price of cart
    public Double getCartTotal(String username) {
        List<CartItem> items = getCartItems(username);
        return items.stream()
                .mapToDouble(CartItem::getSubtotal)
                .sum();
    }

    // Get count of items in cart
    public Integer getCartItemCount(String username) {
        List<CartItem> items = getCartItems(username);
        return items.size();
    }
}