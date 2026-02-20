package com.springboot.e_comm.repo;


import com.springboot.e_comm.entity.Order;
import com.springboot.e_comm.entity.OrderStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface OrderRepo extends JpaRepository<Order, Long> {

    List<Order> findByUserId(Long userId);
    List<Order> findByStatus(OrderStatus status);
    List<Order> findByUserIdOrderByCreatedAtDesc(Long userId);
}
