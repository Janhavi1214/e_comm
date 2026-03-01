<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Track Order #${order.id}</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial; background: #f8f9fa; padding: 20px; }
        .container { max-width: 900px; margin: 0 auto; }

        .nav { margin-bottom: 20px; }
        .nav a { margin-right: 15px; text-decoration: none; color: #667eea; font-size: 14px; }

        h1 { color: #333; margin-bottom: 20px; }

        /* Order header card */
        .order-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white; padding: 24px 28px; border-radius: 8px;
            margin-bottom: 24px;
            display: flex; justify-content: space-between; align-items: center;
            flex-wrap: wrap; gap: 16px;
        }
        .order-header h2 { font-size: 22px; margin-bottom: 4px; }
        .order-header p { font-size: 13px; opacity: 0.85; }
        .order-total { text-align: right; }
        .order-total .amount { font-size: 32px; font-weight: bold; }
        .order-total .label { font-size: 12px; opacity: 0.8; }

        /* Card */
        .card {
            background: white; border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 20px; overflow: hidden;
        }
        .card-header {
            background: #667eea; color: white;
            padding: 14px 20px; font-size: 15px; font-weight: bold;
        }
        .card-body { padding: 24px; }

        /* ✅ TRACKING TIMELINE */
        .timeline { position: relative; padding: 10px 0; }

        .timeline-step {
            display: flex; align-items: flex-start; gap: 20px;
            position: relative; padding-bottom: 32px;
        }
        .timeline-step:last-child { padding-bottom: 0; }

        /* Vertical line connecting steps */
        .timeline-step:not(:last-child)::after {
            content: '';
            position: absolute;
            left: 19px; top: 40px;
            width: 2px; height: calc(100% - 8px);
            background: #e5e7eb;
        }
        .timeline-step.done:not(:last-child)::after { background: #667eea; }

        /* Circle icon */
        .step-icon {
            width: 40px; height: 40px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 16px; flex-shrink: 0;
            border: 2px solid #e5e7eb;
            background: white; color: #aaa;
            position: relative; z-index: 1;
        }
        .timeline-step.done .step-icon {
            background: #667eea; border-color: #667eea; color: white;
        }
        .timeline-step.active .step-icon {
            background: white; border-color: #667eea; color: #667eea;
            box-shadow: 0 0 0 4px rgba(102,126,234,0.15);
            animation: pulse 2s infinite;
        }
        .timeline-step.cancelled .step-icon {
            background: #dc3545; border-color: #dc3545; color: white;
        }

        @keyframes pulse {
            0%   { box-shadow: 0 0 0 0 rgba(102,126,234,0.4); }
            70%  { box-shadow: 0 0 0 8px rgba(102,126,234,0); }
            100% { box-shadow: 0 0 0 0 rgba(102,126,234,0); }
        }

        .step-content { padding-top: 8px; }
        .step-title {
            font-size: 15px; font-weight: bold; color: #333; margin-bottom: 2px;
        }
        .timeline-step.active .step-title { color: #667eea; }
        .timeline-step.cancelled .step-title { color: #dc3545; }
        .timeline-step:not(.done):not(.active):not(.cancelled) .step-title { color: #aaa; }
        .step-desc { font-size: 13px; color: #888; }
        .step-date { font-size: 12px; color: #667eea; margin-top: 4px; font-weight: bold; }

        /* Info grid */
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .info-item label {
            display: block; font-size: 12px; font-weight: bold;
            color: #888; text-transform: uppercase; margin-bottom: 4px;
        }
        .info-item value { display: block; font-size: 15px; color: #333; }

        /* Status badge */
        .badge {
            display: inline-block; padding: 4px 12px; border-radius: 20px;
            font-size: 12px; font-weight: bold;
        }
        .badge-PENDING   { background: #fff3cd; color: #856404; }
        .badge-CONFIRMED { background: #e0e7ff; color: #3730a3; }
        .badge-SHIPPED   { background: #cff4fc; color: #055160; }
        .badge-DELIVERED { background: #d1fae5; color: #065f46; }
        .badge-CANCELLED { background: #f8d7da; color: #721c24; }

        /* Items table */
        .items-table { width: 100%; border-collapse: collapse; }
        .items-table th { background: #f3f4f6; padding: 10px 12px; text-align: left; font-size: 13px; color: #555; }
        .items-table td { padding: 10px 12px; border-bottom: 1px solid #f3f4f6; font-size: 14px; }
        .items-table tr:last-child td { border-bottom: none; }
        .price { color: #28a745; font-weight: bold; }

        /* Total row */
        .total-row {
            display: flex; justify-content: space-between;
            padding: 14px 0; border-top: 2px solid #e5e7eb; margin-top: 8px;
        }
        .total-label { font-weight: bold; font-size: 16px; }
        .total-amount { font-size: 22px; font-weight: bold; color: #28a745; }

        /* Buttons */
        .btn { display: inline-block; padding: 10px 20px; border-radius: 6px; text-decoration: none; font-size: 14px; font-weight: bold; border: none; cursor: pointer; }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #764ba2; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #5a6268; }

        @media(max-width: 600px) { .info-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<div class="container">

    <!-- Nav -->
    <div class="nav">
        <a href="/orders/history">← Back to Orders</a>
        <a href="/products">🏠 Products</a>
        <a href="/cart">🛒 Cart</a>
        <a href="/logout">Logout</a>
    </div>

    <h1>📦 Track Order</h1>

    <!-- Order Header -->
    <div class="order-header">
        <div>
            <h2>Order #${order.id}</h2>
            <p>Placed on ${order.createdAt.toLocalDate()}</p>
        </div>
        <div class="order-total">
            <div class="label">Total Amount</div>
            <div class="amount">₹${order.totalAmount}</div>
        </div>
    </div>

    <!-- Tracking Timeline -->
    <div class="card">
        <div class="card-header">🚚 Order Tracking</div>
        <div class="card-body">
            <div class="timeline">

                <!-- Step 1: Order Placed (PENDING) -->
                <div class="timeline-step
                    <c:choose>
                        <c:when test="${order.status == 'CANCELLED'}">done</c:when>
                        <c:otherwise>done</c:otherwise>
                    </c:choose>">
                    <div class="step-icon">✅</div>
                    <div class="step-content">
                        <div class="step-title">Order Placed</div>
                        <div class="step-desc">Your order has been received and is awaiting confirmation.</div>
                        <div class="step-date">${order.createdAt.toLocalDate()}</div>
                    </div>
                </div>

                <!-- Step 2: Confirmed -->
                <c:choose>
                    <c:when test="${order.status == 'CANCELLED'}">
                        <div class="timeline-step cancelled">
                            <div class="step-icon">❌</div>
                            <div class="step-content">
                                <div class="step-title">Order Cancelled</div>
                                <div class="step-desc">This order has been cancelled.</div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>

                        <div class="timeline-step
                            <c:choose>
                                <c:when test="${order.status == 'CONFIRMED' || order.status == 'SHIPPED' || order.status == 'DELIVERED'}">done</c:when>
                                <c:when test="${order.status == 'PENDING'}">active</c:when>
                                <c:otherwise></c:otherwise>
                            </c:choose>">
                            <div class="step-icon">✔</div>
                            <div class="step-content">
                                <div class="step-title">Order Confirmed</div>
                                <div class="step-desc">Payment verified. Your order is being prepared.</div>
                            </div>
                        </div>

                        <!-- Step 3: Shipped -->
                        <div class="timeline-step
                            <c:choose>
                                <c:when test="${order.status == 'SHIPPED' || order.status == 'DELIVERED'}">done</c:when>
                                <c:when test="${order.status == 'CONFIRMED'}">active</c:when>
                                <c:otherwise></c:otherwise>
                            </c:choose>">
                            <div class="step-icon">🚚</div>
                            <div class="step-content">
                                <div class="step-title">Shipped</div>
                                <div class="step-desc">Your order is on the way to your address.</div>
                            </div>
                        </div>

                        <!-- Step 4: Delivered -->
                        <div class="timeline-step
                            <c:choose>
                                <c:when test="${order.status == 'DELIVERED'}">done</c:when>
                                <c:when test="${order.status == 'SHIPPED'}">active</c:when>
                                <c:otherwise></c:otherwise>
                            </c:choose>">
                            <div class="step-icon">📦</div>
                            <div class="step-content">
                                <div class="step-title">Delivered</div>
                                <div class="step-desc">Package delivered to your doorstep.</div>
                            </div>
                        </div>

                    </c:otherwise>
                </c:choose>

            </div>
        </div>
    </div>

    <!-- Order Info -->
    <div class="card">
        <div class="card-header">📋 Order Details</div>
        <div class="card-body">
            <div class="info-grid">
                <div class="info-item">
                    <label>Order ID</label>
                    <value>#${order.id}</value>
                </div>
                <div class="info-item">
                    <label>Current Status</label>
                    <value><span class="badge badge-${order.status}">${order.status}</span></value>
                </div>
                <div class="info-item">
                    <label>Customer</label>
                    <value>${order.user.firstName} ${order.user.lastName}</value>
                </div>
                <div class="info-item">
                    <label>Email</label>
                    <value>${order.user.email}</value>
                </div>
                <div class="info-item">
                    <label>Order Date</label>
                    <value>${order.createdAt.toLocalDate()}</value>
                </div>
                <div class="info-item">
                    <label>Estimated Delivery</label>
                    <value>
                        <c:choose>
                            <c:when test="${order.status == 'DELIVERED'}">✅ Delivered</c:when>
                            <c:when test="${order.status == 'CANCELLED'}">❌ Cancelled</c:when>
                            <c:otherwise>3-5 business days</c:otherwise>
                        </c:choose>
                    </value>
                </div>
            </div>
        </div>
    </div>

    <!-- Order Items -->
    <div class="card">
        <div class="card-header">🛒 Items Ordered</div>
        <div class="card-body">
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
                            <td class="price">₹${item.price}</td>
                            <td>${item.quantity}</td>
                            <td class="price">₹${item.price * item.quantity}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div class="total-row">
                <span class="total-label">Total</span>
                <span class="total-amount">₹${order.totalAmount}</span>
            </div>
        </div>
    </div>

    <!-- Actions -->
    <div style="display:flex; gap:12px; flex-wrap:wrap;">
        <a href="/orders/history" class="btn btn-primary">← Back to Orders</a>
        <a href="/products" class="btn btn-secondary">Continue Shopping</a>
    </div>

</div>
</body>
</html>
