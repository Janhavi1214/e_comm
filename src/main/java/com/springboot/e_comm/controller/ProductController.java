package com.springboot.e_comm.controller;

import com.springboot.e_comm.entity.Product;
import com.springboot.e_comm.service.ProductService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Controller
@RequestMapping("/products")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    // Display all products
    @GetMapping
    public String listProducts(Model model) {
        List<Product> products = productService.getAllProducts();
        model.addAttribute("products", products);
        return "views/product/list";  // Full path from webapp root
    }

    @GetMapping("/{id}")
    public String getProduct(@PathVariable Long id, Model model) {
        Product product = productService.getProductById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));
        model.addAttribute("product", product);
        return "views/product/details";
    }

    @GetMapping("/search")
    public String searchProducts(@RequestParam String name, Model model) {
        List<Product> products = productService.searchProducts(name);
        model.addAttribute("products", products);
        model.addAttribute("searchQuery", name);
        return "views/product/list";
    }

    @GetMapping("/admin/add")
    public String showAddForm(Model model) {
        model.addAttribute("product", new Product());
        return "views/product/add";
    }

    @PostMapping("/admin/add")
    public String createProduct(@ModelAttribute Product product) {
        productService.createProduct(product);
        return "redirect:/products";
    }

    @GetMapping("/admin/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        Product product = productService.getProductById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));
        model.addAttribute("product", product);
        return "views/product/edit";
    }

    @PostMapping("/admin/edit/{id}")
    public String updateProduct(@PathVariable Long id, @ModelAttribute Product product) {
        productService.updateProduct(id, product);
        return "redirect:/products";
    }

    @GetMapping("/admin/delete/{id}")
    public String deleteProduct(@PathVariable Long id) {
        productService.deleteProduct(id);
        return "redirect:/products";
    }
}