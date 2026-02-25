<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart</title>
    <style>
        body { font-family: Arial; background: #f8f9fa; padding: 20px; }
        .container { max-width: 1000px; margin: 0 auto; }
        h1 { color: #333; }
        .nav { margin-bottom: 20px; }
        .nav a { margin-right: 15px; text-decoration: none; color: #667eea; }

        .cart-table { width: 100%; border-collapse: collapse; background: white; margin: 20px 0; }
        .cart-table th { background: #667eea; color: white; padding: 10px; text-align: left; }
        .cart-table td { padding: 10px; border-bottom: 1px solid #ddd; }
        .cart-table tr:hover { background: #f5f5f5; }

        .product-name { font-weight: bold; color: #333; }
        .price { color: #28a745; font-weight: bold; }
        .quantity-input { width: 60px; padding: 5px; }

        .btn { display: inline-block; padding: 10px 20px; margin: 5px; border-radius: 4px; text-decoration: none; cursor: pointer; border: none; font-weight: bold; }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #764ba2; }
        .btn-success { background: #28a745; color: white; }
        .btn-success:hover { background: #218838; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-danger:hover { background: #c82333; }
        .btn-warning { background: #ffc107; color: black; }
        .btn-warning:hover { background: #e0a800; }

        .cart-summary { background: white; padding: 20px; border-radius: 8px; text-align: right; margin: 20px 0; }
        .summary-row { display: flex; justify-content: space-between; margin: 10px 0; font-size: 16px; }
        .total { font-size: 24px; font-weight: bold; color: #28a745; margin: 20px 0; }

        .checkout-section { margin-top: 30px; display: flex; gap: 10px; justify-content: flex-end; }

        .empty-cart { text-align: center; padding: 40px; color: #999; }
        .empty-cart p { font-size: 18px; }
    </style>
</head>
<body>
    <div class="container">
        <!-- Navigation -->
        <div class="nav">
            <a href="/success">Dashboard</a>
            <a href="/products">Continue Shopping</a>
            <a href="/orders/history">📋 Order History</a>
            <a href="/logout">Logout</a>
        </div>

        <h1>🛒 Shopping Cart</h1>

        <!-- Empty cart message -->
        <c:if test="${empty cartItems}">
            <div class="empty-cart">
                <p>Your cart is empty</p>
                <a href="/products" class="btn btn-primary">Continue Shopping</a>
            </div>
        </c:if>

        <!-- Cart items table -->
        <c:if test="${not empty cartItems}">
            <table class="cart-table">
                <thead>
                    <tr>
                        <th>Product Name</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Subtotal</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${cartItems}">
                        <tr>
                            <td class="product-name">${item.product.name}</td>
                            <td class="price">₹${item.product.price}</td>
                            <td>
                                <form method="post" action="/cart/update/${item.id}" style="display: inline;">
                                    <input type="number" name="quantity" value="${item.quantity}" min="1" class="quantity-input">
                                    <button type="submit" class="btn btn-warning">Update</button>
                                </form>
                            </td>
                            <td class="price">₹${item.subtotal}</td>
                            <td>
                                <a href="/cart/remove/${item.id}" class="btn btn-danger" onclick="return confirm('Remove this item?')">Remove</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Cart summary with checkout -->
            <div class="cart-summary">
                <div class="summary-row">
                    <span>Total Items:</span>
                    <span><strong>${itemCount}</strong></span>
                </div>
                <div class="summary-row">
                    <span>Subtotal:</span>
                    <span class="price">₹${total}</span>
                </div>

                <div class="total">
                    Total: ₹${total}
                </div>

                <!-- CHECKOUT BUTTON! -->
                <div class="checkout-section">
                    <a href="/cart/clear" class="btn btn-danger" onclick="return confirm('Clear entire cart?')">Clear Cart</a>

                    <form method="post" action="/orders/checkout" style="margin: 0;">
                        <button type="submit" class="btn btn-success">✓ Proceed to Checkout</button>
                    </form>
                </div>
            </div>
        </c:if>
    </div>
</body>
</html>