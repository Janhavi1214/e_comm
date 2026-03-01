<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        body { font-family: Arial; background: #f8f9fa; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; }

        h1 { color: #333; margin-bottom: 30px; }

        .nav { margin-bottom: 20px; padding: 15px; background: #667eea; border-radius: 4px; }
        .nav a { color: white; text-decoration: none; margin-right: 20px; font-weight: bold; }
        .nav a:hover { text-decoration: underline; }

        .welcome { font-size: 18px; color: #333; margin-bottom: 30px; }
        .welcome strong { color: #667eea; }

        /* Main stats */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin: 20px 0; }
        .stat-card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); text-align: center; }
        .stat-card h2 { margin: 0 0 10px 0; color: #666; font-size: 16px; }
        .stat-value { font-size: 36px; font-weight: bold; color: #667eea; }

        /* Order status grid */
        .status-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 12px; margin: 20px 0; }
        .status-card { background: white; padding: 16px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.06); text-align: center; border-top: 3px solid #ddd; }
        .status-card.pending   { border-top-color: #ffc107; }
        .status-card.confirmed { border-top-color: #667eea; }
        .status-card.shipped   { border-top-color: #17a2b8; }
        .status-card.delivered { border-top-color: #28a745; }
        .status-card.cancelled { border-top-color: #dc3545; }
        .status-count { font-size: 28px; font-weight: bold; color: #333; }
        .status-label { font-size: 12px; color: #888; margin-top: 4px; }

        .card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin: 20px 0; }
        .card h3 { margin: 0 0 15px 0; color: #333; }

        .btn { display: inline-block; padding: 10px 20px; margin: 5px; border-radius: 4px; text-decoration: none; cursor: pointer; border: none; font-weight: bold; }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #764ba2; }

        @media(max-width: 768px) { .status-grid { grid-template-columns: repeat(3, 1fr); } }
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

    <div class="welcome">Welcome back, <strong>${username}</strong>! 👋</div>

    <h1>📊 Admin Dashboard</h1>

    <!-- Main Stats -->
    <div class="stats-grid">
        <div class="stat-card">
            <h2>Total Products</h2>
            <div class="stat-value">${totalProducts}</div>
        </div>
        <div class="stat-card">
            <h2>Total Orders</h2>
            <div class="stat-value">${totalOrders}</div>
        </div>
        <div class="stat-card">
            <h2>Total Revenue</h2>
            <div class="stat-value">₹${totalRevenue}</div>
        </div>
    </div>

    <!-- Order Status Breakdown -->
    <div class="card">
        <h3>📦 Orders by Status</h3>
        <div class="status-grid">
            <div class="status-card pending">
                <div class="status-count">${pendingCount}</div>
                <div class="status-label">⏳ Pending</div>
            </div>
            <div class="status-card confirmed">
                <div class="status-count">${confirmedCount}</div>
                <div class="status-label">✅ Confirmed</div>
            </div>
            <div class="status-card shipped">
                <div class="status-count">${shippedCount}</div>
                <div class="status-label">🚚 Shipped</div>
            </div>
            <div class="status-card delivered">
                <div class="status-count">${deliveredCount}</div>
                <div class="status-label">📦 Delivered</div>
            </div>
            <div class="status-card cancelled">
                <div class="status-count">${cancelledCount}</div>
                <div class="status-label">❌ Cancelled</div>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="card">
        <h3>⚡ Quick Actions</h3>
        <a href="/admin/products" class="btn btn-primary">📦 View Products</a>
        <a href="/admin/products/add" class="btn btn-primary">➕ Add Product</a>
        <a href="/admin/orders" class="btn btn-primary">📋 Manage Orders</a>
    </div>

</div>
</body>
</html>
