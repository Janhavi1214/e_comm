<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order History</title>
    <style>
        body { font-family: Arial; background: #f8f9fa; padding: 20px; }
        .container { max-width: 1000px; margin: 0 auto; }

        h1 { color: #333; margin-bottom: 20px; }

        .nav { margin-bottom: 20px; }
        .nav a { margin-right: 15px; text-decoration: none; color: #667eea; }

        .orders-table { width: 100%; border-collapse: collapse; background: white; }
        .orders-table th { background: #667eea; color: white; padding: 12px; text-align: left; }
        .orders-table td { padding: 12px; border-bottom: 1px solid #ddd; }
        .orders-table tr:hover { background: #f8f9fa; }

        .order-id { font-weight: bold; color: #667eea; }
        .price { color: #28a745; font-weight: bold; }

        .status-badge { display: inline-block; padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: bold; }
        .status-PENDING { background: #fff3cd; color: #856404; }
        .status-PROCESSING { background: #cfe2ff; color: #084298; }
        .status-DELIVERED { background: #d1e7dd; color: #0a3622; }
        .status-CANCELLED { background: #f8d7da; color: #842029; }

        .btn { display: inline-block; padding: 6px 12px; margin: 0 5px; border-radius: 4px; text-decoration: none; cursor: pointer; border: none; font-size: 14px; }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #764ba2; }

        .empty-message { text-align: center; padding: 40px; color: #999; }
        .empty-message a { color: #667eea; }
    </style>
</head>
<body>
    <div class="container">
        <!-- Navigation -->
        <div class="nav">
            <a href="/cart">🛒 View Cart</a>
            <a href="/products">Shop</a>
            <a href="/success">Dashboard</a>
            <a href="/logout">Logout</a>
        </div>

        <h1>📋 Order History</h1>

        <!-- No orders message -->
        <c:if test="${empty orders}">
            <div class="empty-message">
                <p>You haven't placed any orders yet.</p>
                <a href="/products" class="btn btn-primary">Start Shopping</a>
            </div>
        </c:if>

        <!-- Orders table -->
        <c:if test="${not empty orders}">
            <table class="orders-table">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Date</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td class="order-id">#${order.id}</td>
                            <td>${order.createdAt}</td>
                            <td class="price">₹${order.totalAmount}</td>
                            <td>
                                <span class="status-badge status-${order.status}">
                                    ${order.status}
                                </span>
                            </td>
                            <td>
                                <a href="/orders/${order.id}" class="btn btn-primary">View Details</a>
                                <a href="/orders/${order.id}/track" class="btn btn-primary">🚚 Track</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
</body>
</html>