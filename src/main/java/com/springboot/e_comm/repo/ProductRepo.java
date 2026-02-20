package com.springboot.e_comm.repo;

import com.springboot.e_comm.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ProductRepo extends JpaRepository<Product, Long> {

    // Find products by name
    List<Product> findByNameContainingIgnoreCase(String name);

    // Find products with stock > 0
    List<Product> findByStockGreaterThan(Integer stock);
}