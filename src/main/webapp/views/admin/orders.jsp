<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - Manage Orders</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial; background: #f8f9fa; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; }

        /* Nav */
        .nav { margin-bottom: 20px; padding: 15px; background: #667eea; border-radius: 4px; }
        .nav a { color: white; text-decoration: none; margin-right: 20px; font-weight: bold; }
        .nav a:hover { text-decoration: underline; }

        h1 { color: #333; margin-bottom: 20px; }

        /* Alerts */
        .alert { padding: 12px 16px; border-radius: 6px; margin-bottom: 20px; font-size: 14px; font-weight: 500; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error   { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        /* Filter bar */
        .filter-bar {
            background: white; padding: 16px 20px; border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08); margin-bottom: 20px;
            display: flex; gap: 10px; align-items: center; flex-wrap: wrap;
        }
        .filter-bar label { font-size: 13px; font-weight: bold; color: #555; }
        .filter-bar select {
            padding: 8px 12px; border: 1.5px solid #e5e7eb; border-radius: 6px;
            font-size: 13px; color: #333; outline: none; cursor: pointer;
        }
        .filter-bar select:focus { border-color: #667eea; }

        /* Stats mini bar */
        .mini-stats { display: flex; gap: 10px; margin-bottom: 20px; flex-wrap: wrap; }
        .mini-stat {
            background: white; padding: 12px 18px; border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.06); font-size: 13px;
            display: flex; align-items: center; gap: 8px;
        }
        .mini-stat .count { font-weight: bold; font-size: 18px; }
        .dot { width: 10px; height: 10px; border-radius: 50%; }
        .dot-pending   { background: #ffc107; }
        .dot-confirmed { background: #667eea; }
        .dot-shipped   { background: #17a2b8; }
        .dot-delivered { background: #28a745; }
        .dot-cancelled { background: #dc3545; }

        /* Table */
        .table-wrapper { background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.08); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #667eea; }
        th { color: white; padding: 12px 16px; text-align: left; font-size: 13px; }
        td { padding: 12px 16px; border-bottom: 1px solid #f3f4f6; font-size: 14px; color: #333; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #f9f9ff; }

        /* Status badges */
        .badge {
            display: inline-block; padding: 4px 10px; border-radius: 20px;
            font-size: 11px; font-weight: bold; text-transform: uppercase;
        }
        .badge-PENDING   { background: #fff3cd; color: #856404; }
        .badge-CONFIRMED { background: #e0e7ff; color: #3730a3; }
        .badge-SHIPPED   { background: #cff4fc; color: #055160; }
        .badge-DELIVERED { background: #d1fae5; color: #065f46; }
        .badge-CANCELLED { background: #f8d7da; color: #721c24; }

        /* Status update form */
        .status-form { display: flex; gap: 6px; align-items: center; }
        .status-select {
            padding: 6px 10px; border: 1.5px solid #e5e7eb; border-radius: 6px;
            font-size: 12px; color: #333; outline: none; cursor: pointer;
            transition: border-color 0.2s;
        }
        .status-select:focus { border-color: #667eea; }
        .btn-update {
            padding: 6px 12px; background: #667eea; color: white;
            border: none; border-radius: 6px; font-size: 12px;
            font-weight: bold; cursor: pointer; transition: background 0.2s;
            white-space: nowrap;
        }
        .btn-update:hover { background: #764ba2; }

        /* Order items toggle */
        .btn-items {
            padding: 5px 10px; background: #f3f4f6; color: #555;
            border: 1px solid #e5e7eb; border-radius: 6px; font-size: 11px;
            cursor: pointer; transition: all 0.2s;
        }
        .btn-items:hover { background: #e5e7eb; }

        .items-row { display: none; }
        .items-row td { background: #f9f9ff; padding: 12px 16px; }
        .items-table { width: 100%; border-collapse: collapse; font-size: 13px; }
        .items-table th { background: #e9ecef; padding: 8px 12px; text-align: left; color: #555; }
        .items-table td { padding: 8px 12px; border-bottom: 1px solid #e9ecef; color: #333; }

        .empty-state { text-align: center; padding: 40px; color: #aaa; font-size: 16px; }
    </style>
</head>
<body>
<div class="container">

    <!-- Nav -->
    <div class="nav">
        <a href="/admin/dashboard">📊 Dashboard</a>
        <a href="/admin/products">📦 Products</a>
        <a href="/admin/orders">📋 Orders</a>
        <a href="/products">🛍️ Shop</a>
        <a href="/logout">🚪 Logout</a>
    </div>

    <h1>📋 Manage Orders</h1>

    <!-- Alerts -->
    <c:if test="${not empty success}">
        <div class="alert alert-success">✅ ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">❌ ${error}</div>
    </c:if>

    <!-- Mini stats -->
    <div class="mini-stats">
        <div class="mini-stat"><div class="dot dot-pending"></div><span>Pending</span><span class="count">${pendingCount}</span></div>
        <div class="mini-stat"><div class="dot dot-confirmed"></div><span>Confirmed</span><span class="count">${confirmedCount}</span></div>
        <div class="mini-stat"><div class="dot dot-shipped"></div><span>Shipped</span><span class="count">${shippedCount}</span></div>
        <div class="mini-stat"><div class="dot dot-delivered"></div><span>Delivered</span><span class="count">${deliveredCount}</span></div>
        <div class="mini-stat"><div class="dot dot-cancelled"></div><span>Cancelled</span><span class="count">${cancelledCount}</span></div>
    </div>

    <!-- Filter bar -->
    <div class="filter-bar">
        <label>Filter by status:</label>
        <select id="statusFilter" onchange="filterOrders(this.value)">
            <option value="ALL">All Orders</option>
            <option value="PENDING">Pending</option>
            <option value="CONFIRMED">Confirmed</option>
            <option value="SHIPPED">Shipped</option>
            <option value="DELIVERED">Delivered</option>
            <option value="CANCELLED">Cancelled</option>
        </select>
        <label style="margin-left:10px;">Total: <strong id="orderCount">${orders.size()}</strong> orders</label>
    </div>

    <!-- Orders Table -->
    <div class="table-wrapper">
        <c:choose>
            <c:when test="${empty orders}">
                <div class="empty-state">📭 No orders found</div>
            </c:when>
            <c:otherwise>
                <table id="ordersTable">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Items</th>
                            <th>Total</th>
                            <th>Current Status</th>
                            <th>Date</th>
                            <th>Update Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}">
                            <!-- Main row -->
                            <tr class="order-row" data-status="${order.status}">
                                <td><strong>#${order.id}</strong></td>
                                <td>
                                    ${order.user.firstName} ${order.user.lastName}<br>
                                    <small style="color:#888;">${order.user.email}</small>
                                </td>
                                <td>
                                    <button class="btn-items" onclick="toggleItems(${order.id})">
                                        📦 ${order.orderItems.size()} item(s)
                                    </button>
                                </td>
                                <td><strong style="color:#28a745;">₹${order.totalAmount}</strong></td>
                                <td>
                                    <span class="badge badge-${order.status}">${order.status}</span>
                                </td>
                                <td style="font-size:12px; color:#888;">
                                    ${order.createdAt.toLocalDate()}
                                </td>
                                <td>
                                    <!-- ✅ Status update form -->
                                    <c:if test="${order.status != 'CANCELLED' && order.status != 'DELIVERED'}">
                                        <form method="post" action="/admin/orders/update-status" class="status-form">
                                            <input type="hidden" name="orderId" value="${order.id}">
                                            <select name="newStatus" class="status-select">
                                                <c:forEach var="status" items="${statuses}">
                                                    <option value="${status}"
                                                        ${order.status == status ? 'selected' : ''}>
                                                        ${status}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <button type="submit" class="btn-update">Update</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${order.status == 'DELIVERED'}">
                                        <span style="color:#28a745; font-size:12px;">✅ Delivered</span>
                                    </c:if>
                                    <c:if test="${order.status == 'CANCELLED'}">
                                        <span style="color:#dc3545; font-size:12px;">❌ Cancelled</span>
                                    </c:if>
                                </td>
                            </tr>
                            <!-- Items expandable row -->
                            <tr class="items-row" id="items-${order.id}">
                                <td colspan="7">
                                    <table class="items-table">
                                        <thead>
                                            <tr>
                                                <th>Product</th>
                                                <th>Price</th>
                                                <th>Qty</th>
                                                <th>Subtotal</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${order.orderItems}">
                                                <tr>
                                                    <td>${item.product.name}</td>
                                                    <td>₹${item.price}</td>
                                                    <td>${item.quantity}</td>
                                                    <td>₹${item.price * item.quantity}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

</div>

<script>
    // Expand/collapse order items
    function toggleItems(orderId) {
        const row = document.getElementById('items-' + orderId);
        row.style.display = row.style.display === 'table-row' ? 'none' : 'table-row';
    }

    // Filter orders by status
    function filterOrders(status) {
        const rows = document.querySelectorAll('.order-row');
        let count = 0;
        rows.forEach(row => {
            const itemsRow = row.nextElementSibling; // items row
            if (status === 'ALL' || row.dataset.status === status) {
                row.style.display = '';
                count++;
            } else {
                row.style.display = 'none';
                if (itemsRow) itemsRow.style.display = 'none';
            }
        });
        document.getElementById('orderCount').textContent = count;
    }

    // Auto-hide alerts after 4 seconds
    setTimeout(() => {
        document.querySelectorAll('.alert').forEach(a => a.style.display = 'none');
    }, 4000);
</script>
</body>
</html>
