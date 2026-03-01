package com.springboot.e_comm.controller;

import com.springboot.e_comm.entity.Order;
import com.springboot.e_comm.entity.OrderStatus;
import com.springboot.e_comm.entity.Product;
import com.springboot.e_comm.exception.ResourceNotFoundException;
import com.springboot.e_comm.service.OrderService;
import com.springboot.e_comm.service.ProductService;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/admin")
public class AdminController {

    private final ProductService productService;
    private final OrderService orderService;

    public AdminController(ProductService productService, OrderService orderService) {
        this.productService = productService;
        this.orderService = orderService;
    }

    private boolean isNotAdmin(HttpSession session) {
        Object userRole = session.getAttribute("userRole");
        if (userRole == null) return true;
        return !userRole.toString().equals("ADMIN");
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        if (isNotAdmin(session)) return "redirect:/products";
        String username = (String) session.getAttribute("loggedInUser");
        log.info("Admin dashboard accessed by: {}", username);

        List<Product> allProducts = productService.getAllProducts();
        List<Order> allOrders = orderService.getAllOrders();
        Double totalRevenue = allOrders.stream().mapToDouble(Order::getTotalAmount).sum();

        model.addAttribute("totalProducts", allProducts.size());
        model.addAttribute("totalOrders", allOrders.size());
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("username", username);
        model.addAttribute("pendingCount",   allOrders.stream().filter(o -> o.getStatus() == OrderStatus.PENDING).count());
        model.addAttribute("confirmedCount", allOrders.stream().filter(o -> o.getStatus() == OrderStatus.CONFIRMED).count());
        model.addAttribute("shippedCount",   allOrders.stream().filter(o -> o.getStatus() == OrderStatus.SHIPPED).count());
        model.addAttribute("deliveredCount", allOrders.stream().filter(o -> o.getStatus() == OrderStatus.DELIVERED).count());
        model.addAttribute("cancelledCount", allOrders.stream().filter(o -> o.getStatus() == OrderStatus.CANCELLED).count());

        return "views/admin/dashboard";
    }

    @GetMapping("/products")
    public String manageProducts(HttpSession session, Model model) {
        if (isNotAdmin(session)) return "redirect:/products";
        log.info("Admin products page accessed");
        model.addAttribute("products", productService.getAllProducts());
        return "views/admin/products";
    }

    @GetMapping("/products/add")
    public String addProductForm(HttpSession session, Model model) {
        if (isNotAdmin(session)) return "redirect:/products";
        model.addAttribute("product", new Product());
        return "views/admin/product-form";
    }

    @PostMapping("/products/save")
    public String saveProduct(@ModelAttribute Product product, HttpSession session) {
        if (isNotAdmin(session)) return "redirect:/products";
        productService.createProduct(product);
        log.info("Product created: {}", product.getName());
        return "redirect:/admin/products";
    }

    @GetMapping("/products/edit/{id}")
    public String editProductForm(@PathVariable Long id, HttpSession session, Model model) {
        if (isNotAdmin(session)) return "redirect:/products";
        Product product = productService.getProductById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Product", id));
        model.addAttribute("product", product);
        return "views/admin/product-form";
    }

    @PostMapping("/products/update/{id}")
    public String updateProduct(@PathVariable Long id, @ModelAttribute Product product, HttpSession session) {
        if (isNotAdmin(session)) return "redirect:/products";
        productService.updateProduct(id, product);
        log.info("Product updated | id: {}", id);
        return "redirect:/admin/products";
    }

    @GetMapping("/products/delete/{id}")
    public String deleteProduct(@PathVariable Long id, HttpSession session) {
        if (isNotAdmin(session)) return "redirect:/products";
        productService.deleteProduct(id);
        log.info("Product deleted | id: {}", id);
        return "redirect:/admin/products";
    }

    @GetMapping("/orders")
    public String manageOrders(HttpSession session, Model model) {
        if (isNotAdmin(session)) return "redirect:/products";
        log.info("Admin orders page accessed");
        List<Order> orders = orderService.getAllOrders();
        model.addAttribute("orders", orders);
        model.addAttribute("statuses", OrderStatus.values());
        model.addAttribute("pendingCount",   orders.stream().filter(o -> o.getStatus() == OrderStatus.PENDING).count());
        model.addAttribute("confirmedCount", orders.stream().filter(o -> o.getStatus() == OrderStatus.CONFIRMED).count());
        model.addAttribute("shippedCount",   orders.stream().filter(o -> o.getStatus() == OrderStatus.SHIPPED).count());
        model.addAttribute("deliveredCount", orders.stream().filter(o -> o.getStatus() == OrderStatus.DELIVERED).count());
        model.addAttribute("cancelledCount", orders.stream().filter(o -> o.getStatus() == OrderStatus.CANCELLED).count());
        return "views/admin/orders";
    }

    @PostMapping("/orders/update-status")
    public String updateOrderStatus(@RequestParam Long orderId, @RequestParam OrderStatus newStatus,
                                    HttpSession session, RedirectAttributes redirectAttributes) {
        if (isNotAdmin(session)) return "redirect:/products";
        try {
            orderService.updateOrderStatus(orderId, newStatus);
            log.info("Order status updated | orderId: {} | newStatus: {}", orderId, newStatus);
            redirectAttributes.addFlashAttribute("success", "Order #" + orderId + " updated to " + newStatus);
        } catch (Exception e) {
            log.error("Failed to update order | orderId: {} | error: {}", orderId, e.getMessage());
            redirectAttributes.addFlashAttribute("error", "Failed to update order #" + orderId + ": " + e.getMessage());
        }
        return "redirect:/admin/orders";
    }
}