package com.springboot.e_comm.repo;

import com.springboot.e_comm.entity.Order;
import com.springboot.e_comm.entity.OrderStatus;
import com.springboot.e_comm.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface OrderRepo extends JpaRepository<Order, Long> {

    // Find all orders by user, sorted by newest first
    List<Order> findByUserIdOrderByCreatedAtDesc(Long userId);

    // Find all orders by specific status
    List<Order> findByStatus(OrderStatus status);

    // Find orders by user AND status
    List<Order> findByUserAndStatusOrderByCreatedAtDesc(User user, OrderStatus status);
}