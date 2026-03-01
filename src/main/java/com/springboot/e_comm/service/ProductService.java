package com.springboot.e_comm.service;

import com.springboot.e_comm.entity.Product;
import com.springboot.e_comm.exception.ResourceNotFoundException;
import com.springboot.e_comm.repo.ProductRepo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Slf4j
@Service
public class ProductService {

    private final ProductRepo productRepo;

    public ProductService(ProductRepo productRepo) {
        this.productRepo = productRepo;
    }

    // Existing — unchanged (used by MVC controllers)
    public List<Product> getAllProducts() {
        return productRepo.findAll();
    }

    public List<Product> getAllActiveProducts() {
        return productRepo.findAll();
    }

    public Optional<Product> getProductById(Long id) {
        return productRepo.findById(id);
    }

    public List<Product> searchProducts(String name) {
        return productRepo.findByNameContainingIgnoreCase(name);
    }

    public Product createProduct(Product product) {
        return productRepo.save(product);
    }

    public Product updateProduct(Long id, Product product) {
        return productRepo.findById(id)
                .map(p -> {
                    p.setName(product.getName());
                    p.setDescription(product.getDescription());
                    p.setPrice(product.getPrice());
                    p.setStock(product.getStock());
                    return productRepo.save(p);
                })
                .orElseThrow(() -> new ResourceNotFoundException("Product", id));
    }

    public void deleteProduct(Long id) {
        productRepo.deleteById(id);
    }

    // ✅ NEW — Paginated methods (used by API)
    public Page<Product> getProductsPaginated(int page, int size, String sortBy) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(sortBy).ascending());
        Page<Product> result = productRepo.findAll(pageable);
        log.info("Fetched products page: {}/{} | size: {} | sort: {}",
                page + 1, result.getTotalPages(), size, sortBy);
        return result;
    }

    public Page<Product> searchProductsPaginated(String name, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("name").ascending());
        Page<Product> result = productRepo.findByNameContainingIgnoreCase(name, pageable);
        log.info("Product search paginated | query: {} | page: {}/{} | results: {}",
                name, page + 1, result.getTotalPages(), result.getTotalElements());
        return result;
    }
}