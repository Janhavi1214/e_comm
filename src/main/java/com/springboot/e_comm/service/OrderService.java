package com.springboot.e_comm.service;

import com.springboot.e_comm.entity.Order;
import com.springboot.e_comm.entity.OrderStatus;
import com.springboot.e_comm.repo.OrderRepo;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class OrderService {

    private final OrderRepo orderRepository;
    private final EmailService emailService;

    // Existing — unchanged (used by MVC controllers)
    public Order createOrder(Order order) {
        order.setStatus(OrderStatus.PENDING);
        Order saved = orderRepository.save(order);
        log.info("Order created | orderId: {} | userId: {} | total: {}",
                saved.getId(), saved.getUser().getId(), saved.getTotalAmount());
        return saved;
    }

    public List<Order> getAllOrders() {
        List<Order> orders = orderRepository.findAll();
        log.info("Fetched all orders | count: {}", orders.size());
        return orders;
    }

    public Optional<Order> getOrderById(Long id) {
        log.info("Fetching order | orderId: {}", id);
        return orderRepository.findById(id);
    }

    public List<Order> getOrdersByUser(Long userId) {
        List<Order> orders = orderRepository.findByUserIdOrderByCreatedAtDesc(userId);
        log.info("Fetched orders for userId: {} | count: {}", userId, orders.size());
        return orders;
    }

    public List<Order> getOrdersByStatus(OrderStatus status) {
        List<Order> orders = orderRepository.findByStatus(status);
        log.info("Fetched orders by status: {} | count: {}", status, orders.size());
        return orders;
    }

    public Order updateOrderStatus(Long orderId, OrderStatus newStatus) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> {
                    log.error("Order not found | orderId: {}", orderId);
                    return new IllegalArgumentException("Order not found");
                });

        OrderStatus oldStatus = order.getStatus();
        order.setStatus(newStatus);
        Order saved = orderRepository.save(order);
        log.info("Order status updated | orderId: {} | {} → {}", orderId, oldStatus, newStatus);

        try {
            emailService.sendOrderStatusEmail(
                    order.getUser().getEmail(),
                    saved.getId(),
                    newStatus.name()
            );
        } catch (Exception e) {
            log.error("Status email failed | orderId: {} | error: {}", orderId, e.getMessage());
        }

        return saved;
    }

    public Order cancelOrder(Long orderId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> {
                    log.error("Order not found for cancellation | orderId: {}", orderId);
                    return new IllegalArgumentException("Order not found");
                });

        if (order.getStatus() == OrderStatus.DELIVERED) {
            log.warn("Cannot cancel delivered order | orderId: {}", orderId);
            throw new IllegalArgumentException("Cannot cancel delivered order");
        }

        order.setStatus(OrderStatus.CANCELLED);
        Order saved = orderRepository.save(order);
        log.info("Order cancelled | orderId: {}", orderId);

        try {
            emailService.sendOrderStatusEmail(
                    order.getUser().getEmail(),
                    saved.getId(),
                    "CANCELLED"
            );
        } catch (Exception e) {
            log.error("Cancel email failed | orderId: {} | error: {}", orderId, e.getMessage());
        }

        return saved;
    }

    // ✅ NEW — Paginated methods (used by API)
    public Page<Order> getAllOrdersPaginated(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<Order> result = orderRepository.findAll(pageable);
        log.info("Fetched orders page: {}/{} | size: {}",
                page + 1, result.getTotalPages(), size);
        return result;
    }

    public Page<Order> getOrdersByUserPaginated(Long userId, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<Order> result = orderRepository.findByUserId(userId, pageable);
        log.info("Fetched orders for userId: {} | page: {}/{} | size: {}",
                userId, page + 1, result.getTotalPages(), size);
        return result;
    }
}