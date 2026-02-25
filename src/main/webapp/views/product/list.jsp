<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Products</title>
    <style>
        body { font-family: Arial; background: #f8f9fa; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; }
        h1 { color: #333; }

        .search-box { margin: 20px 0; }
        .search-box input { padding: 10px; width: 300px; }
        .search-box button { padding: 10px 20px; background: #667eea; color: white; border: none; cursor: pointer; }

        .products { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; margin-top: 20px; }
        .product-card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .product-card h3 { margin: 0 0 10px 0; color: #333; }
        .product-card p { color: #666; margin: 5px 0; font-size: 14px; }
        .price { font-size: 20px; color: #28a745; font-weight: bold; }
        .stock { font-size: 12px; color: #999; }

        .btn { display: inline-block; padding: 8px 15px; margin: 10px 5px 0 0; border-radius: 4px; text-decoration: none; cursor: pointer; border: none; }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #764ba2; }
        .btn-success { background: #28a745; color: white; }
        .btn-success:hover { background: #218838; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-danger:hover { background: #c82333; }
        .btn-warning { background: #ffc107; color: black; }
        .btn-warning:hover { background: #e0a800; }
        .btn-disabled { background: #ccc; color: #666; cursor: not-allowed; }

        .nav { margin-bottom: 20px; }
        .nav a { margin-right: 15px; text-decoration: none; color: #667eea; }
        .cart-badge { background: #dc3545; color: white; padding: 2px 8px; border-radius: 20px; font-size: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="nav">
            <a href="/success">Dashboard</a>
            <a href="/cart">🛒 View Cart</a>
            <a href="/logout">Logout</a>
        </div>

        <h1>Products</h1>

        <!-- Search Box -->
        <div class="search-box">
            <form method="get" action="/products/search">
                <input type="text" name="name" placeholder="Search products..." required>
                <button type="submit">Search</button>
            </form>
        </div>

        <c:if test="${not empty searchQuery}">
            <p>Search results for: <strong>${searchQuery}</strong></p>
        </c:if>

        <!-- No products message -->
        <c:if test="${empty products}">
            <p>No products found. <a href="/products">View all products</a></p>
        </c:if>

        <!-- Products Grid -->
        <div class="products">
            <c:forEach var="product" items="${products}">
                <div class="product-card">
                    <h3>📦 ${product.name}</h3>
                    <p>${product.description}</p>
                    <p class="price">₹${product.price}</p>
                    <p class="stock">Stock: ${product.stock} units</p>

                    <!-- Buttons -->
                    <a href="/products/${product.id}" class="btn btn-primary">View Details</a>

                    <c:if test="${product.stock > 0}">
                        <form method="post" action="/cart/add" style="display: inline;">
                            <input type="hidden" name="productId" value="${product.id}">
                            <button type="submit" class="btn btn-success">🛒 Add to Cart</button>
                        </form>
                    </c:if>

                    <c:if test="${product.stock <= 0}">
                        <button class="btn btn-disabled" disabled>Out of Stock</button>
                    </c:if>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>