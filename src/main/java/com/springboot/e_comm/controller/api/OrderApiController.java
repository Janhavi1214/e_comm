package com.springboot.e_comm.controller.api;

import com.springboot.e_comm.dto.ApiResponse;
import com.springboot.e_comm.entity.Order;
import com.springboot.e_comm.entity.OrderStatus;
import com.springboot.e_comm.entity.User;
import com.springboot.e_comm.exception.ResourceNotFoundException;
import com.springboot.e_comm.repo.UserRepo;
import com.springboot.e_comm.service.OrderService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
@Tag(name = "Orders", description = "Order management — all endpoints require JWT token")
@SecurityRequirement(name = "Bearer Authentication")
public class OrderApiController {

    private final OrderService orderService;
    private final UserRepo userRepo;

    @GetMapping
    @Operation(summary = "Get my orders", description = "Returns paginated list of logged-in user's orders")
    public ResponseEntity<ApiResponse<Page<Order>>> getMyOrders(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "5") int size,
            HttpServletRequest request) {

        String username = (String) request.getAttribute("jwtUsername");
        User user = userRepo.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        Page<Order> orders = orderService.getOrdersByUserPaginated(user.getId(), page, size);
        return ResponseEntity.ok(ApiResponse.success(
                "Page " + (page + 1) + " of " + orders.getTotalPages()
                        + " | Total orders: " + orders.getTotalElements(), orders));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get order by ID", description = "User can only view their own orders; Admin can view all")
    public ResponseEntity<ApiResponse<Order>> getOrderById(@PathVariable Long id, HttpServletRequest request) {
        String username = (String) request.getAttribute("jwtUsername");
        String role = (String) request.getAttribute("jwtRole");

        Order order = orderService.getOrderById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Order", id));

        if (!"ADMIN".equals(role) && !order.getUser().getUsername().equals(username))
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error("Access denied"));

        return ResponseEntity.ok(ApiResponse.success("Order found", order));
    }

    @GetMapping("/all")
    @Operation(summary = "Get all orders (Admin)", description = "Admin only — paginated list of all orders")
    public ResponseEntity<ApiResponse<Page<Order>>> getAllOrders(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            HttpServletRequest request) {

        String role = (String) request.getAttribute("jwtRole");
        if (!"ADMIN".equals(role))
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error("Admin access required"));

        Page<Order> orders = orderService.getAllOrdersPaginated(page, size);
        return ResponseEntity.ok(ApiResponse.success(
                "Page " + (page + 1) + " of " + orders.getTotalPages()
                        + " | Total: " + orders.getTotalElements(), orders));
    }

    @PatchMapping("/{id}/status")
    @Operation(summary = "Update order status (Admin)", description = "Admin only — change order status")
    public ResponseEntity<ApiResponse<Order>> updateOrderStatus(
            @PathVariable Long id,
            @RequestParam OrderStatus newStatus,
            HttpServletRequest request) {

        String role = (String) request.getAttribute("jwtRole");
        if (!"ADMIN".equals(role))
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error("Admin access required"));

        return ResponseEntity.ok(ApiResponse.success("Order status updated", orderService.updateOrderStatus(id, newStatus)));
    }

    @DeleteMapping("/{id}/cancel")
    @Operation(summary = "Cancel order", description = "User can cancel their own order; Admin can cancel any")
    public ResponseEntity<ApiResponse<Order>> cancelOrder(@PathVariable Long id, HttpServletRequest request) {
        String username = (String) request.getAttribute("jwtUsername");
        String role = (String) request.getAttribute("jwtRole");

        Order order = orderService.getOrderById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Order", id));

        if (!"ADMIN".equals(role) && !order.getUser().getUsername().equals(username))
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error("Access denied"));

        return ResponseEntity.ok(ApiResponse.success("Order cancelled", orderService.cancelOrder(id)));
    }
}