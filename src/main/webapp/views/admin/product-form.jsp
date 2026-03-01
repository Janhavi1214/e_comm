<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${product.id == null ? 'Add Product' : 'Edit Product'}</title>
    <style>
        body { font-family: Arial; background: #f8f9fa; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; }

        .nav { margin-bottom: 20px; padding: 15px; background: #667eea; border-radius: 4px; }
        .nav a { color: white; text-decoration: none; margin-right: 20px; font-weight: bold; }

        .form-card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }

        h1 { color: #333; margin: 0 0 30px 0; }

        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; color: #333; }
        input, textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; font-family: Arial; }
        textarea { resize: vertical; min-height: 100px; }

        input:focus, textarea:focus { outline: none; border-color: #667eea; box-shadow: 0 0 5px rgba(102, 126, 234, 0.3); }

        .btn { display: inline-block; padding: 12px 25px; margin: 10px 10px 10px 0; border-radius: 4px; text-decoration: none; cursor: pointer; border: none; font-weight: bold; font-size: 16px; }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #764ba2; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #5a6268; }
    </style>
</head>
<body>
    <div class="container">
        <!-- Navigation -->
        <div class="nav">
            <a href="/admin/dashboard">📊 Dashboard</a>
            <a href="/admin/products">📦 Products</a>
            <a href="/logout">🚪 Logout</a>
        </div>

        <!-- Form -->
        <div class="form-card">
            <h1>${product.id == null ? '➕ Add New Product' : '✏️ Edit Product'}</h1>

            <form method="post" action="${product.id == null ? '/admin/products/save' : '/admin/products/update/' + product.id}">

                <div class="form-group">
                    <label for="name">Product Name:</label>
                    <input type="text" id="name" name="name" value="${product.name}" required>
                </div>

                <div class="form-group">
                    <label for="description">Description:</label>
                    <textarea id="description" name="description">${product.description}</textarea>
                </div>

                <div class="form-group">
                    <label for="price">Price (₹):</label>
                    <input type="number" id="price" name="price" value="${product.price}" step="0.01" required>
                </div>

                <div class="form-group">
                    <label for="stock">Stock Quantity:</label>
                    <input type="number" id="stock" name="stock" value="${product.stock}" required>
                </div>

                <div>
                    <button type="submit" class="btn btn-primary">
                        ${product.id == null ? '➕ Add Product' : '💾 Update Product'}
                    </button>
                    <a href="/admin/products" class="btn btn-secondary">❌ Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>