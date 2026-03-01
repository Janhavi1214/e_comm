<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Products</title>
    <style>
        body { font-family: Arial; background: #f8f9fa; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; }

        .nav { margin-bottom: 20px; padding: 15px; background: #667eea; border-radius: 4px; }
        .nav a { color: white; text-decoration: none; margin-right: 20px; font-weight: bold; }

        h1 { color: #333; }

        .btn { display: inline-block; padding: 10px 15px; margin: 5px; border-radius: 4px; text-decoration: none; cursor: pointer; border: none; font-weight: bold; }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #764ba2; }
        .btn-warning { background: #ffc107; color: black; }
        .btn-warning:hover { background: #e0a800; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-danger:hover { background: #c82333; }

        .products-table { width: 100%; border-collapse: collapse; background: white; margin: 20px 0; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .products-table th { background: #667eea; color: white; padding: 12px; text-align: left; }
        .products-table td { padding: 12px; border-bottom: 1px solid #ddd; }
        .products-table tr:hover { background: #f8f9fa; }

        .price { color: #28a745; font-weight: bold; }
        .stock { text-align: center; }

        .add-btn-section { margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <!-- Navigation -->
        <div class="nav">
            <a href="/admin/dashboard">📊 Dashboard</a>
            <a href="/admin/products">📦 Manage Products</a>
            <a href="/admin/orders">📋 Orders</a>
            <a href="/products">🛍️ Shop</a>
            <a href="/logout">🚪 Logout</a>
        </div>

        <h1>📦 Manage Products</h1>

        <!-- Add Product Button -->
        <div class="add-btn-section">
            <a href="/admin/products/add" class="btn btn-primary">➕ Add New Product</a>
        </div>

        <!-- No products message -->
        <c:if test="${empty products}">
            <p>No products found. <a href="/admin/products/add">Add one now!</a></p>
        </c:if>

        <!-- Products Table -->
        <c:if test="${not empty products}">
            <table class="products-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="product" items="${products}">
                        <tr>
                            <td>#${product.id}</td>
                            <td><strong>${product.name}</strong></td>
                            <td>${product.description}</td>
                            <td class="price">₹${product.price}</td>
                            <td class="stock">${product.stock}</td>
                            <td>
                                <a href="/admin/products/edit/${product.id}" class="btn btn-warning">✏️ Edit</a>
                                <a href="/admin/products/delete/${product.id}" class="btn btn-danger" onclick="return confirm('Delete this product?')">🗑️ Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
</body>
</html>