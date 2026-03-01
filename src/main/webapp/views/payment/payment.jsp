<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body { font-family: Arial; background: #f8f9fa; padding: 20px; }
        .container { max-width: 950px; margin: 0 auto; }

        .nav { margin-bottom: 20px; }
        .nav a { margin-right: 15px; text-decoration: none; color: #667eea; font-size: 14px; }

        /* Page layout: left = payment, right = order summary */
        .page-grid {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 24px;
            align-items: start;
        }
        @media(max-width: 768px) { .page-grid { grid-template-columns: 1fr; } }

        /* Cards */
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            overflow: hidden;
            margin-bottom: 20px;
        }
        .card-header {
            background: #667eea;
            color: white;
            padding: 16px 24px;
            font-size: 16px;
            font-weight: bold;
        }
        .card-body { padding: 24px; }

        /* Payment method selector */
        .method-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
            margin-bottom: 28px;
        }
        @media(max-width: 500px) { .method-grid { grid-template-columns: repeat(2, 1fr); } }

        .method-btn {
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            padding: 14px 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
            background: white;
            user-select: none;
        }
        .method-btn:hover { border-color: #667eea; background: #f0f2ff; }
        .method-btn.selected { border-color: #667eea; background: #eef0ff; }
        .method-icon { font-size: 24px; margin-bottom: 6px; }
        .method-label { font-size: 12px; font-weight: bold; color: #555; }

        /* Form panels */
        .payment-panel { display: none; }
        .payment-panel.active { display: block; }

        /* Fields */
        .field { margin-bottom: 16px; }
        .field label { display: block; font-size: 13px; font-weight: bold; color: #333; margin-bottom: 6px; }
        .field input, .field select {
            width: 100%;
            padding: 11px 14px;
            border: 1.5px solid #e5e7eb;
            border-radius: 6px;
            font-size: 14px;
            color: #333;
            outline: none;
            transition: border-color 0.2s;
        }
        .field input:focus, .field select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
        }
        .field input::placeholder { color: #b0b7c3; }

        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }

        /* Card number formatting */
        .card-number-wrapper { position: relative; }
        .card-number-wrapper input { letter-spacing: 2px; font-size: 16px; }
        .card-type-icon { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); font-size: 20px; }

        /* Secure badge */
        .secure-badge {
            display: flex; align-items: center; gap: 8px;
            background: #f0fdf4; border: 1px solid #bbf7d0;
            border-radius: 6px; padding: 10px 14px;
            font-size: 13px; color: #166534;
            margin-bottom: 20px;
        }

        /* Alert */
        .alert-error {
            background: #fef2f2; color: #b91c1c;
            border: 1px solid #fecaca;
            border-radius: 6px; padding: 12px 16px;
            font-size: 14px; margin-bottom: 20px;
        }

        /* Pay button */
        .btn-pay {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            margin-top: 8px;
        }
        .btn-pay:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(102,126,234,0.35); }
        .btn-pay:active { transform: translateY(0); }

        /* COD info box */
        .cod-box {
            background: #fffbeb; border: 1px solid #fde68a;
            border-radius: 8px; padding: 20px;
            text-align: center;
        }
        .cod-box .cod-icon { font-size: 48px; margin-bottom: 12px; }
        .cod-box h3 { color: #92400e; margin-bottom: 8px; }
        .cod-box p { color: #78350f; font-size: 14px; line-height: 1.5; }

        /* UPI apps */
        .upi-apps { display: flex; gap: 10px; margin-bottom: 16px; flex-wrap: wrap; }
        .upi-app {
            border: 1.5px solid #e5e7eb; border-radius: 8px;
            padding: 8px 14px; cursor: pointer; font-size: 13px;
            font-weight: bold; color: #555; transition: all 0.2s;
            background: white;
        }
        .upi-app:hover { border-color: #667eea; color: #667eea; }
        .upi-app.selected { border-color: #667eea; background: #eef0ff; color: #667eea; }

        /* Net banking banks */
        .bank-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-bottom: 16px; }
        .bank-btn {
            border: 1.5px solid #e5e7eb; border-radius: 8px;
            padding: 12px 8px; text-align: center; cursor: pointer;
            font-size: 12px; font-weight: bold; color: #555;
            transition: all 0.2s; background: white;
        }
        .bank-btn:hover { border-color: #667eea; }
        .bank-btn.selected { border-color: #667eea; background: #eef0ff; color: #667eea; }
        .bank-icon { font-size: 20px; margin-bottom: 4px; }

        /* Order summary */
        .summary-table { width: 100%; border-collapse: collapse; margin-bottom: 16px; }
        .summary-table td { padding: 8px 0; font-size: 14px; border-bottom: 1px solid #f3f4f6; color: #555; }
        .summary-table td:last-child { text-align: right; font-weight: bold; color: #333; }
        .summary-table tr:last-child td { border-bottom: none; }

        .total-row { display: flex; justify-content: space-between; align-items: center; padding: 14px 0; border-top: 2px solid #e5e7eb; margin-top: 8px; }
        .total-label { font-weight: bold; font-size: 16px; color: #333; }
        .total-amount { font-size: 24px; font-weight: bold; color: #28a745; }

        .steps {
            display: flex; align-items: center; gap: 0;
            margin-bottom: 24px; font-size: 13px;
        }
        .step { color: #aaa; padding: 0 6px; }
        .step.done { color: #28a745; }
        .step.active { color: #667eea; font-weight: bold; }
        .step-sep { color: #ddd; }
    </style>
</head>
<body>
<div class="container">

    <!-- Nav -->
    <div class="nav">
        <a href="/cart">← Back to Cart</a>
        <a href="/products">🏠 Products</a>
        <a href="/orders/history">📦 My Orders</a>
        <a href="/logout">Logout</a>
    </div>

    <!-- Steps indicator -->
    <div class="steps">
        <span class="step done">✅ Cart</span>
        <span class="step-sep"> › </span>
        <span class="step done">✅ Checkout</span>
        <span class="step-sep"> › </span>
        <span class="step active">💳 Payment</span>
        <span class="step-sep"> › </span>
        <span class="step">📋 Confirmation</span>
    </div>

    <form method="post" action="/payment/process" id="paymentForm">
        <input type="hidden" name="orderId" value="${order.id}">
        <input type="hidden" name="paymentMethod" id="selectedMethod" value="">

        <div class="page-grid">

            <!-- LEFT: Payment Methods -->
            <div>
                <div class="card">
                    <div class="card-header">💳 Choose Payment Method</div>
                    <div class="card-body">

                        <!-- Error alert -->
                        <c:if test="${not empty paymentError}">
                            <div class="alert-error">❌ ${paymentError}</div>
                        </c:if>

                        <!-- Secure badge -->
                        <div class="secure-badge">
                            🔒 <span>This is a mock payment page. No real money will be charged.</span>
                        </div>

                        <!-- Method selector -->
                        <div class="method-grid">
                            <div class="method-btn" onclick="selectMethod('CARD')" id="method-CARD">
                                <div class="method-icon">💳</div>
                                <div class="method-label">Credit/Debit Card</div>
                            </div>
                            <div class="method-btn" onclick="selectMethod('UPI')" id="method-UPI">
                                <div class="method-icon">📱</div>
                                <div class="method-label">UPI</div>
                            </div>
                            <div class="method-btn" onclick="selectMethod('NETBANKING')" id="method-NETBANKING">
                                <div class="method-icon">🏦</div>
                                <div class="method-label">Net Banking</div>
                            </div>
                            <div class="method-btn" onclick="selectMethod('COD')" id="method-COD">
                                <div class="method-icon">💵</div>
                                <div class="method-label">Cash on Delivery</div>
                            </div>
                        </div>

                        <!-- CARD PANEL -->
                        <div class="payment-panel" id="panel-CARD">
                            <div class="field">
                                <label>Card Number</label>
                                <div class="card-number-wrapper">
                                    <input type="text" name="cardNumber" id="cardNumber"
                                           placeholder="1234 5678 9012 3456" maxlength="19"
                                           oninput="formatCardNumber(this)">
                                    <span class="card-type-icon" id="cardTypeIcon">💳</span>
                                </div>
                            </div>
                            <div class="field">
                                <label>Cardholder Name</label>
                                <input type="text" name="cardHolder" placeholder="Name as on card">
                            </div>
                            <div class="form-row">
                                <div class="field">
                                    <label>Expiry Date</label>
                                    <input type="text" name="expiry" placeholder="MM/YY" maxlength="5"
                                           oninput="formatExpiry(this)">
                                </div>
                                <div class="field">
                                    <label>CVV</label>
                                    <input type="password" name="cvv" placeholder="•••" maxlength="4">
                                </div>
                            </div>
                        </div>

                        <!-- UPI PANEL -->
                        <div class="payment-panel" id="panel-UPI">
                            <p style="font-size:13px; color:#888; margin-bottom:14px;">Select app or enter UPI ID</p>
                            <div class="upi-apps">
                                <div class="upi-app" onclick="selectUpiApp(this, 'gpay')">Google Pay</div>
                                <div class="upi-app" onclick="selectUpiApp(this, 'phonepe')">PhonePe</div>
                                <div class="upi-app" onclick="selectUpiApp(this, 'paytm')">Paytm</div>
                                <div class="upi-app" onclick="selectUpiApp(this, 'bhim')">BHIM</div>
                            </div>
                            <div class="field">
                                <label>UPI ID</label>
                                <input type="text" name="upiId" id="upiId" placeholder="yourname@upi">
                            </div>
                        </div>

                        <!-- NET BANKING PANEL -->
                        <div class="payment-panel" id="panel-NETBANKING">
                            <p style="font-size:13px; color:#888; margin-bottom:14px;">Select your bank</p>
                            <div class="bank-grid">
                                <div class="bank-btn" onclick="selectBank(this, 'SBI')">
                                    <div class="bank-icon">🏦</div>SBI
                                </div>
                                <div class="bank-btn" onclick="selectBank(this, 'HDFC')">
                                    <div class="bank-icon">🏦</div>HDFC
                                </div>
                                <div class="bank-btn" onclick="selectBank(this, 'ICICI')">
                                    <div class="bank-icon">🏦</div>ICICI
                                </div>
                                <div class="bank-btn" onclick="selectBank(this, 'AXIS')">
                                    <div class="bank-icon">🏦</div>Axis
                                </div>
                                <div class="bank-btn" onclick="selectBank(this, 'KOTAK')">
                                    <div class="bank-icon">🏦</div>Kotak
                                </div>
                                <div class="bank-btn" onclick="selectBank(this, 'PNB')">
                                    <div class="bank-icon">🏦</div>PNB
                                </div>
                            </div>
                            <div class="field">
                                <label>Or select from list</label>
                                <select name="bank" id="bankSelect">
                                    <option value="">-- Select Bank --</option>
                                    <option value="SBI">State Bank of India</option>
                                    <option value="HDFC">HDFC Bank</option>
                                    <option value="ICICI">ICICI Bank</option>
                                    <option value="AXIS">Axis Bank</option>
                                    <option value="KOTAK">Kotak Mahindra Bank</option>
                                    <option value="PNB">Punjab National Bank</option>
                                    <option value="BOB">Bank of Baroda</option>
                                    <option value="CANARA">Canara Bank</option>
                                    <option value="IDBI">IDBI Bank</option>
                                </select>
                            </div>
                        </div>

                        <!-- COD PANEL -->
                        <div class="payment-panel" id="panel-COD">
                            <div class="cod-box">
                                <div class="cod-icon">💵</div>
                                <h3>Cash on Delivery</h3>
                                <p>Pay when your order arrives at your doorstep.<br>
                                Keep exact change ready for a smooth delivery experience.</p>
                            </div>
                        </div>

                        <!-- Pay button (shown after method selected) -->
                        <div id="payBtnWrapper" style="display:none; margin-top:20px;">
                            <button type="submit" class="btn-pay" onclick="return validateAndSubmit()">
                                🔒 Pay ₹${order.totalAmount}
                            </button>
                        </div>

                    </div>
                </div>
            </div>

            <!-- RIGHT: Order Summary -->
            <div>
                <div class="card">
                    <div class="card-header">🧾 Order Summary</div>
                    <div class="card-body">
                        <p style="font-size:13px; color:#888; margin-bottom:12px;">Order #${order.id}</p>

                        <table class="summary-table">
                            <c:forEach var="item" items="${order.orderItems}">
                                <tr>
                                    <td>${item.product.name} × ${item.quantity}</td>
                                    <td>₹${item.price * item.quantity}</td>
                                </tr>
                            </c:forEach>
                        </table>

                        <div class="total-row">
                            <span class="total-label">Total</span>
                            <span class="total-amount">₹${order.totalAmount}</span>
                        </div>

                        <div style="margin-top:16px; font-size:12px; color:#aaa; line-height:1.6;">
                            🔒 Secured by mock payment gateway<br>
                            📦 Estimated delivery: 3-5 business days
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">📋 Order Details</div>
                    <div class="card-body">
                        <table class="summary-table">
                            <tr><td>Order ID</td><td>#${order.id}</td></tr>
                            <tr><td>Customer</td><td>${order.user.firstName} ${order.user.lastName}</td></tr>
                            <tr><td>Status</td><td>Pending Payment</td></tr>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </form>
</div>

<script>
    function selectMethod(method) {
        // Update hidden input
        document.getElementById('selectedMethod').value = method;

        // Toggle method button styles
        ['CARD','UPI','NETBANKING','COD'].forEach(m => {
            document.getElementById('method-' + m).classList.toggle('selected', m === method);
        });

        // Show correct panel
        ['CARD','UPI','NETBANKING','COD'].forEach(m => {
            document.getElementById('panel-' + m).classList.toggle('active', m === method);
        });

        // Update pay button text
        const totalText = document.querySelector('.btn-pay');
        if (method === 'COD') {
            totalText.textContent = '✅ Place Order (Pay on Delivery)';
        } else {
            totalText.innerHTML = '🔒 Pay ₹${order.totalAmount}';
        }

        // Show pay button
        document.getElementById('payBtnWrapper').style.display = 'block';
    }

    function selectUpiApp(el, app) {
        document.querySelectorAll('.upi-app').forEach(a => a.classList.remove('selected'));
        el.classList.add('selected');
        document.getElementById('upiId').placeholder = 'yourname@' + app;
    }

    function selectBank(el, bank) {
        document.querySelectorAll('.bank-btn').forEach(b => b.classList.remove('selected'));
        el.classList.add('selected');
        document.getElementById('bankSelect').value = bank;
    }

    function formatCardNumber(input) {
        let val = input.value.replace(/\D/g, '').substring(0, 16);
        input.value = val.replace(/(.{4})/g, '$1 ').trim();

        // Detect card type
        const icon = document.getElementById('cardTypeIcon');
        if (val.startsWith('4')) icon.textContent = '💙'; // Visa
        else if (val.startsWith('5')) icon.textContent = '🔴'; // Mastercard
        else if (val.startsWith('3')) icon.textContent = '🟡'; // Amex
        else icon.textContent = '💳';
    }

    function formatExpiry(input) {
        let val = input.value.replace(/\D/g, '').substring(0, 4);
        if (val.length >= 2) val = val.substring(0,2) + '/' + val.substring(2);
        input.value = val;
    }

    function validateAndSubmit() {
        const method = document.getElementById('selectedMethod').value;
        if (!method) {
            alert('Please select a payment method.');
            return false;
        }
        return true;
    }

    // If returning with error, re-select the method
    window.onload = function() {
        <c:if test="${not empty paymentError}">
            // Re-open whichever panel was active — default to CARD
            selectMethod('CARD');
        </c:if>
    };
</script>
</body>
</html>
