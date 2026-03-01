<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body { font-family: Arial; background: #f8f9fa; padding: 20px; }
        .container { max-width: 900px; margin: 0 auto; }

        /* Nav */
        .nav { margin-bottom: 20px; }
        .nav a { margin-right: 15px; text-decoration: none; color: #667eea; font-size: 14px; }
        .nav a:hover { text-decoration: underline; }

        /* Page header */
        .page-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 30px;
            border-radius: 8px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .avatar {
            width: 70px; height: 70px;
            background: rgba(255,255,255,0.25);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 28px;
            flex-shrink: 0;
        }
        .page-header h1 { font-size: 24px; margin-bottom: 4px; }
        .page-header p { font-size: 14px; opacity: 0.85; }

        /* Cards */
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 24px;
            overflow: hidden;
        }
        .card-header {
            background: #667eea;
            color: white;
            padding: 16px 24px;
            font-size: 16px;
            font-weight: bold;
        }
        .card-body { padding: 24px; }

        /* Info grid (read-only view) */
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        .info-item label {
            display: block;
            font-size: 12px;
            font-weight: bold;
            color: #888;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        .info-item value {
            display: block;
            font-size: 15px;
            color: #333;
        }
        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        .badge-user   { background: #e0e7ff; color: #3730a3; }
        .badge-admin  { background: #fef3c7; color: #92400e; }
        .badge-seller { background: #d1fae5; color: #065f46; }

        /* Form fields */
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        .field { margin-bottom: 16px; }
        .field label {
            display: block;
            font-size: 13px;
            font-weight: bold;
            color: #333;
            margin-bottom: 6px;
        }
        .field input {
            width: 100%;
            padding: 10px 14px;
            border: 1.5px solid #e5e7eb;
            border-radius: 6px;
            font-size: 14px;
            color: #333;
            outline: none;
            transition: border-color 0.2s;
        }
        .field input:focus { border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,0.1); }

        /* Buttons */
        .btn {
            padding: 10px 22px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            border: none;
            transition: background 0.2s, transform 0.1s;
        }
        .btn:active { transform: scale(0.98); }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #764ba2; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-danger:hover { background: #b02a37; }

        /* Alerts */
        .alert {
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
            font-weight: 500;
        }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error   { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        /* Stats bar */
        .stats-bar {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }
        .stat-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border-top: 3px solid #667eea;
        }
        .stat-number { font-size: 28px; font-weight: bold; color: #667eea; }
        .stat-label  { font-size: 13px; color: #888; margin-top: 4px; }

        /* Tabs inside profile card */
        .section-tabs { display: flex; gap: 4px; margin-bottom: 24px; }
        .section-tab {
            padding: 8px 18px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            color: #888;
            background: #f3f4f6;
            border: none;
            transition: all 0.2s;
        }
        .section-tab.active { background: #667eea; color: white; }

        .section-panel { display: none; }
        .section-panel.active { display: block; }

        @media(max-width: 600px) {
            .form-row, .info-grid, .stats-bar { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="container">

    <!-- Navigation -->
    <div class="nav">
        <a href="/products">🏠 Home</a>
        <a href="/cart">🛒 Cart</a>
        <a href="/orders/history">📦 My Orders</a>
        <a href="/logout">🚪 Logout</a>
    </div>

    <!-- Alerts -->
    <c:if test="${not empty success}">
        <div class="alert alert-success">✅ ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">❌ ${error}</div>
    </c:if>

    <!-- Page Header -->
    <div class="page-header">
        <div class="avatar">👤</div>
        <div>
            <h1>${user.firstName} ${user.lastName}</h1>
            <p>@${user.username} &nbsp;•&nbsp; Member since ${user.createdAt.toLocalDate()}</p>
        </div>
    </div>

    <!-- Stats Bar -->
    <div class="stats-bar">
        <div class="stat-card">
            <div class="stat-number">${user.orders.size()}</div>
            <div class="stat-label">Total Orders</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">${user.role}</div>
            <div class="stat-label">Account Type</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">${user.isActive ? '✅' : '❌'}</div>
            <div class="stat-label">Account Status</div>
        </div>
    </div>

    <!-- Profile Card with Tabs -->
    <div class="card">
        <div class="card-header">👤 My Profile</div>
        <div class="card-body">

            <!-- Tabs -->
            <div class="section-tabs">
                <button class="section-tab active" onclick="showSection('info')">Account Info</button>
                <button class="section-tab" onclick="showSection('edit')">Edit Profile</button>
                <button class="section-tab" onclick="showSection('password')">Change Password</button>
            </div>

            <!-- SECTION 1: Account Info (read-only) -->
            <div class="section-panel active" id="section-info">
                <div class="info-grid">
                    <div class="info-item">
                        <label>First Name</label>
                        <value>${user.firstName}</value>
                    </div>
                    <div class="info-item">
                        <label>Last Name</label>
                        <value>${user.lastName}</value>
                    </div>
                    <div class="info-item">
                        <label>Username</label>
                        <value>@${user.username}</value>
                    </div>
                    <div class="info-item">
                        <label>Email</label>
                        <value>${user.email}</value>
                    </div>
                    <div class="info-item">
                        <label>Phone</label>
                        <value>${not empty user.phone ? user.phone : '—'}</value>
                    </div>
                    <div class="info-item">
                        <label>Role</label>
                        <value>
                            <span class="badge badge-${user.role.toString().toLowerCase()}">${user.role}</span>
                        </value>
                    </div>
                    <div class="info-item">
                        <label>Member Since</label>
                        <value>${user.createdAt.toLocalDate()}</value>
                    </div>
                    <div class="info-item">
                        <label>Last Updated</label>
                        <value>${user.updatedAt.toLocalDate()}</value>
                    </div>
                </div>
            </div>

            <!-- SECTION 2: Edit Profile -->
            <div class="section-panel" id="section-edit">
                <form method="post" action="/profile/update">
                    <div class="form-row">
                        <div class="field">
                            <label>First Name</label>
                            <input type="text" name="firstName" value="${user.firstName}" required>
                        </div>
                        <div class="field">
                            <label>Last Name</label>
                            <input type="text" name="lastName" value="${user.lastName}" required>
                        </div>
                    </div>
                    <div class="field">
                        <label>Email Address</label>
                        <input type="email" name="email" value="${user.email}" required>
                    </div>
                    <div class="field">
                        <label>Phone (optional)</label>
                        <input type="text" name="phone" value="${user.phone}" placeholder="e.g. 9876543210">
                    </div>
                    <button type="submit" class="btn btn-primary">💾 Save Changes</button>
                </form>
            </div>

            <!-- SECTION 3: Change Password -->
            <div class="section-panel" id="section-password">
                <c:if test="${not empty passwordSuccess}">
                    <div class="alert alert-success">✅ ${passwordSuccess}</div>
                </c:if>
                <c:if test="${not empty passwordError}">
                    <div class="alert alert-error">❌ ${passwordError}</div>
                </c:if>

                <form method="post" action="/profile/change-password">
                    <div class="field">
                        <label>Current Password</label>
                        <input type="password" name="oldPassword" placeholder="Enter current password" required>
                    </div>
                    <div class="field">
                        <label>New Password</label>
                        <input type="password" name="newPassword" placeholder="At least 6 characters" required>
                    </div>
                    <div class="field">
                        <label>Confirm New Password</label>
                        <input type="password" name="confirmPassword" placeholder="Repeat new password" required>
                    </div>
                    <button type="submit" class="btn btn-danger">🔒 Change Password</button>
                </form>
            </div>

        </div>
    </div>

    <!-- Quick Links -->
    <div class="card">
        <div class="card-header">🔗 Quick Links</div>
        <div class="card-body" style="display:flex; gap:12px; flex-wrap:wrap;">
            <a href="/orders/history" class="btn btn-primary">📦 View My Orders</a>
            <a href="/products" class="btn" style="background:#6c757d;color:white;">🛒 Continue Shopping</a>
        </div>
    </div>

</div>

<script>
    function showSection(name) {
        // Hide all panels and deactivate all tabs
        document.querySelectorAll('.section-panel').forEach(p => p.classList.remove('active'));
        document.querySelectorAll('.section-tab').forEach(t => t.classList.remove('active'));

        // Show selected
        document.getElementById('section-' + name).classList.add('active');
        event.target.classList.add('active');
    }

    // Auto-open correct tab if there's a password alert
    window.onload = function() {
        const hasPasswordMsg = ${not empty passwordSuccess or not empty passwordError};
        if (hasPasswordMsg) showSectionByName('password');

        const hasProfileMsg = ${not empty success or not empty error};
        if (hasProfileMsg) showSectionByName('edit');
    }

    function showSectionByName(name) {
        document.querySelectorAll('.section-panel').forEach(p => p.classList.remove('active'));
        document.querySelectorAll('.section-tab').forEach(t => t.classList.remove('active'));
        document.getElementById('section-' + name).classList.add('active');
        document.querySelectorAll('.section-tab')[name === 'info' ? 0 : name === 'edit' ? 1 : 2].classList.add('active');
    }
</script>
</body>
</html>
