package com.springboot.e_comm.controller;

import com.springboot.e_comm.entity.Product;
import com.springboot.e_comm.exception.ResourceNotFoundException;
import com.springboot.e_comm.service.ProductService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/products")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    public String listProducts(Model model) {
        List<Product> products = productService.getAllProducts();
        log.info("Products list viewed | count: {}", products.size());
        model.addAttribute("products", products);
        return "views/product/list";
    }

    @GetMapping("/{id}")
    public String getProduct(@PathVariable Long id, Model model) {
        log.info("Product detail viewed | productId: {}", id);
        Product product = productService.getProductById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Product", id));
        model.addAttribute("product", product);
        return "views/product/details";
    }

    @GetMapping("/search")
    public String searchProducts(@RequestParam String name, Model model) {
        log.info("Product search | query: {}", name);
        List<Product> products = productService.searchProducts(name);
        log.info("Product search results | query: {} | count: {}", name, products.size());
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
        log.info("Product created via admin | name: {}", product.getName());
        return "redirect:/products";
    }

    @GetMapping("/admin/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        Product product = productService.getProductById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Product", id));
        model.addAttribute("product", product);
        return "views/product/edit";
    }

    @PostMapping("/admin/edit/{id}")
    public String updateProduct(@PathVariable Long id, @ModelAttribute Product product) {
        productService.updateProduct(id, product);
        log.info("Product updated | id: {}", id);
        return "redirect:/products";
    }

    @GetMapping("/admin/delete/{id}")
    public String deleteProduct(@PathVariable Long id) {
        productService.deleteProduct(id);
        log.info("Product deleted | id: {}", id);
        return "redirect:/products";
    }
}