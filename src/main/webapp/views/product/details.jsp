<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${product.name}</title>
    <style>
        body { font-family: Arial; background: #f8f9fa; padding: 20px; }
        .container { max-width: 1000px; margin: 0 auto; }
        .nav { margin-bottom: 20px; }
        .nav a { margin-right: 15px; text-decoration: none; color: #667eea; }

        .product-detail { background: white; padding: 30px; border-radius: 8px; display: grid; grid-template-columns: 1fr 1fr; gap: 30px; }
        .product-image { background: #f0f0f0; padding: 20px; border-radius: 8px; text-align: center; }
        .product-info h1 { color: #333; margin: 0 0 20px 0; }
        .price { font-size: 32px; color: #28a745; font-weight: bold; margin: 20px 0; }
        .stock { font-size: 16px; color: #666; margin: 10px 0; }
        .description { color: #555; line-height: 1.6; margin: 20px 0; }

        .quantity-section { margin: 30px 0; }
        .quantity-section label { display: block; margin-bottom: 10px; font-weight: bold; }
        .quantity-input { width: 100px; padding: 10px; font-size: 16px; }

        .btn { display: inline-block; padding: 12px 25px; margin: 10px 10px 10px 0; border-radius: 4px; text-decoration: none; cursor: pointer; border: none; font-size: 16px; }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #764ba2; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #5a6268; }

        .success-message { background: #d4edda; color: #155724; padding: 15px; border-radius: 4px; margin: 20px 0; display: none; }

        @media (max-width: 768px) {
            .product-detail { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Navigation -->
        <div class="nav">
            <a href="/products">← Back to Products</a>
            <a href="/cart">🛒 View Cart</a>
            <a href="/success">Dashboard</a>
            <a href="/logout">Logout</a>
        </div>

        <!-- Product Details -->
        <div class="product-detail">
            <!-- Product Image/Icon -->
            <div class="product-image">
                <h2>📦</h2>
                <p>${product.name}</p>
            </div>

            <!-- Product Info -->
            <div class="product-info">
                <h1>${product.name}</h1>

                <div class="price">₹${product.price}</div>

                <div class="stock">
                    <strong>Stock Available:</strong> ${product.stock} units
                </div>

                <div class="description">
                    <h3>Description:</h3>
                    <p>${product.description}</p>
                </div>

                <!-- Add to Cart Form -->
                <c:if test="${product.stock > 0}">
                    <form method="post" action="/cart/add">
                        <div class="quantity-section">
                            <label for="quantity">Quantity:</label>
                            <input type="hidden" name="productId" value="${product.id}">
                            <input type="number" id="quantity" name="quantity" value="1" min="1" max="${product.stock}" class="quantity-input" required>
                            <p style="font-size: 12px; color: #999;">Max available: ${product.stock}</p>
                        </div>

                        <button type="submit" class="btn btn-primary">🛒 Add to Cart</button>
                    </form>
                </c:if>

                <!-- Out of stock message -->
                <c:if test="${product.stock <= 0}">
                    <div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 4px; margin: 20px 0;">
                        <strong>Out of Stock</strong>
                    </div>
                </c:if>

                <a href="/products" class="btn btn-secondary">Continue Shopping</a>
            </div>
        </div>
    </div>

    <script>
        // Optional: You can add JavaScript here for dynamic behavior
        console.log("Product details page loaded");
    </script>
</body>
</html>