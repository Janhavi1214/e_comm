package com.springboot.e_comm.controller.api;

import com.springboot.e_comm.dto.ApiResponse;
import com.springboot.e_comm.dto.ProductRequest;
import com.springboot.e_comm.entity.Product;
import com.springboot.e_comm.exception.ResourceNotFoundException;
import com.springboot.e_comm.service.ProductService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/products")
@RequiredArgsConstructor
@Tag(name = "Products", description = "Product management endpoints — GET is public, POST/PUT/DELETE require Admin JWT")
public class ProductApiController {

    private final ProductService productService;

    @GetMapping
    @Operation(summary = "Get all products", description = "Public endpoint — returns paginated product list")
    public ResponseEntity<ApiResponse<Page<Product>>> getAllProducts(
            @Parameter(description = "Page number (0-based)") @RequestParam(defaultValue = "0") int page,
            @Parameter(description = "Items per page") @RequestParam(defaultValue = "10") int size,
            @Parameter(description = "Sort field: name, price, stock") @RequestParam(defaultValue = "name") String sortBy) {

        Page<Product> products = productService.getProductsPaginated(page, size, sortBy);
        return ResponseEntity.ok(ApiResponse.success(
                "Page " + (page + 1) + " of " + products.getTotalPages()
                        + " | Total: " + products.getTotalElements(), products));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get product by ID", description = "Public endpoint")
    public ResponseEntity<ApiResponse<Product>> getProductById(@PathVariable Long id) {
        Product product = productService.getProductById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Product", id));
        return ResponseEntity.ok(ApiResponse.success("Product found", product));
    }

    @GetMapping("/search")
    @Operation(summary = "Search products by name", description = "Public endpoint — paginated search")
    public ResponseEntity<ApiResponse<Page<Product>>> searchProducts(
            @RequestParam String name,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        Page<Product> products = productService.searchProductsPaginated(name, page, size);
        return ResponseEntity.ok(ApiResponse.success("Search results", products));
    }

    @PostMapping
    @Operation(summary = "Create product", description = "Admin only — requires JWT token")
    @SecurityRequirement(name = "Bearer Authentication")
    public ResponseEntity<ApiResponse<?>> createProduct(
            @Valid @RequestBody ProductRequest request,
            BindingResult bindingResult,
            HttpServletRequest httpRequest) {

        String role = (String) httpRequest.getAttribute("jwtRole");
        if (!"ADMIN".equals(role))
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error("Admin access required"));

        if (bindingResult.hasErrors()) {
            Map<String, String> errors = new HashMap<>();
            bindingResult.getFieldErrors().forEach(e -> errors.put(e.getField(), e.getDefaultMessage()));
            return ResponseEntity.badRequest().body(ApiResponse.error("Validation failed: " + errors));
        }

        Product product = new Product();
        product.setName(request.getName());
        product.setDescription(request.getDescription());
        product.setPrice(request.getPrice());
        product.setStock(request.getStock());

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Product created", productService.createProduct(product)));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update product", description = "Admin only — requires JWT token")
    @SecurityRequirement(name = "Bearer Authentication")
    public ResponseEntity<ApiResponse<?>> updateProduct(
            @PathVariable Long id,
            @Valid @RequestBody ProductRequest request,
            BindingResult bindingResult,
            HttpServletRequest httpRequest) {

        String role = (String) httpRequest.getAttribute("jwtRole");
        if (!"ADMIN".equals(role))
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error("Admin access required"));

        if (bindingResult.hasErrors()) {
            Map<String, String> errors = new HashMap<>();
            bindingResult.getFieldErrors().forEach(e -> errors.put(e.getField(), e.getDefaultMessage()));
            return ResponseEntity.badRequest().body(ApiResponse.error("Validation failed: " + errors));
        }

        Product product = new Product();
        product.setName(request.getName());
        product.setDescription(request.getDescription());
        product.setPrice(request.getPrice());
        product.setStock(request.getStock());

        return ResponseEntity.ok(ApiResponse.success("Product updated", productService.updateProduct(id, product)));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete product", description = "Admin only — requires JWT token")
    @SecurityRequirement(name = "Bearer Authentication")
    public ResponseEntity<ApiResponse<Void>> deleteProduct(@PathVariable Long id, HttpServletRequest httpRequest) {
        String role = (String) httpRequest.getAttribute("jwtRole");
        if (!"ADMIN".equals(role))
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error("Admin access required"));
        productService.deleteProduct(id);
        return ResponseEntity.ok(ApiResponse.success("Product deleted"));
    }
}