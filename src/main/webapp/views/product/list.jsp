<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Products</title>
    <style>
        body { font-family: Arial; background: #f8f9fa; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; }
        h1 { color: #333; }
        .btn { display: inline-block; padding: 10px 20px; background: #667eea; color: white; text-decoration: none; border-radius: 4px; margin: 20px 0; }
        .nav { margin-bottom: 20px; }
        .nav a { margin-right: 15px; text-decoration: none; color: #667eea; }
    </style>
</head>
<body>
    <div class="container">
        <div class="nav">
            <a href="/success">Dashboard</a>
            <a href="/logout">Logout</a>
        </div>
        <h1>Products</h1>
        <p>No products yet.</p>
        <a href="/products/admin/add" class="btn">Add Product</a>
    </div>
</body>
</html>