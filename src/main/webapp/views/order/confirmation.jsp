<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation</title>
    <style>
        body { font-family: Arial; background: #f8f9fa; padding: 20px; }
        .container { max-width: 900px; margin: 0 auto; }

        .success-banner { background: #d4edda; color: #155724; padding: 20px; border-radius: 8px; margin: 20px 0; text-align: center; }
        .success-banner h1 { margin: 0 0 10px 0; font-size: 28px; }

        .order-card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin: 20px 0; }
        .order-header { background: #667eea; color: white; padding: 15px; border-radius: 4px; margin-bottom: 20px; }
        .order-header h2 { margin: 0; }

        .order-info { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin: 20px 0; }
        .info-box { background: #f8f9fa; padding: 15px; border-radius: 4px; }
        .info-box label { font-weight: bold; color: #333; display: block; margin-bottom: 5px; }
        .info-box value { color: #666; font-size: 16px; }

        .items-table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        .items-table th { background: #667eea; color: white; padding: 12px; text-align: left; }
        .items-table td { padding: 12px; border-bottom: 1px solid #ddd; }
        .items-table tr:hover { background: #f8f9fa; }

        .price { color: #28a745; font-weight: bold; }
        .total-section { background: #f8f9fa; padding: 20px; border-radius: 4px; text-align: right; margin: 20px 0; }
        .total-amount { font-size: 28px; color: #28a745; font-weight: bold; }

        .btn { display: inline-block; padding: 12px 25px; margin: 10px 10px 10px 0; border-radius: 4px; text-decoration: none; cursor: pointer; border: none; font-size: 16px; }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #764ba2; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #5a6268; }

        .nav { margin-bottom: 20px; }
        .nav a { margin-right: 15px; text-decoration: none; color: #667eea; }

        .status-badge { display: inline-block; padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: bold; }
        .status-pending { background: #fff3cd; color: #856404; }
    </style>
</head>
<body>
    <div class="container">
        <!-- Navigation -->
        <div class="nav">
            <a href="/products">Continue Shopping</a>
            <a href="/orders/history">View All Orders</a>
            <a href="/success">Dashboard</a>
            <a href="/logout">Logout</a>
        </div>

        <!-- Success Message -->
        <div class="success-banner">
            <h1>✅ Order Confirmed!</h1>
            <p>Thank you for your purchase. Your order has been successfully created.</p>
        </div>

        <!-- Order Details Card -->
        <div class="order-card">
            <div class="order-header">
                <h2>Order #${order.id}</h2>
            </div>

            <!-- Order Info Grid -->
            <div class="order-info">
                <div class="info-box">
                    <label>Order ID:</label>
                    <value>${order.id}</value>
                </div>
                <div class="info-box">
                    <label>Order Date:</label>
                    <value>${order.createdAt}</value>
                </div>
                <div class="info-box">
                    <label>Status:</label>
                    <value>
                        <span class="status-badge status-${order.status}">
                            ${order.status}
                        </span>
                    </value>
                </div>
                <div class="info-box">
                    <label>Customer:</label>
                    <value>${order.user.username}</value>
                </div>
            </div>

            <!-- Items Table -->
            <h3>Order Items</h3>
            <table class="items-table">
                <thead>
                    <tr>
                        <th>Product Name</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${order.orderItems}">
                        <tr>
                            <td>${item.product.name}</td>
                            <td class="price">₹${item.price}</td>
                            <td>${item.quantity}</td>
                            <td class="price">₹${item.subtotal}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Total Section -->
            <div class="total-section">
                <div style="margin-bottom: 10px;">
                    <strong>Total Amount:</strong>
                </div>
                <div class="total-amount">₹${order.totalAmount}</div>
            </div>

            <!-- Action Buttons -->
            <div style="margin-top: 30px; text-align: center;">
                <a href="/orders/history" class="btn btn-primary">View Order History</a>
                <a href="/products" class="btn btn-secondary">Continue Shopping</a>
            </div>
        </div>

        <!-- Order Processing Info -->
        <div class="order-card" style="background: #e7f3ff; border-left: 4px solid #667eea;">
            <h3>📦 What's Next?</h3>
            <p>Your order has been confirmed and is being processed. You will receive an email confirmation shortly.</p>
            <p>You can track your order status at any time from your order history page.</p>
        </div>
    </div>
</body>
</html>