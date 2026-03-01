<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>ShopEasy — Login</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --primary: #667eea;
            --primary-dark: #4f63d2;
            --secondary: #764ba2;
            --success: #28a745;
            --danger: #dc3545;
            --text: #1a1a2e;
            --text-light: #6b7280;
            --border: #e5e7eb;
            --bg: #f3f4f8;
            --white: #ffffff;
            --card-shadow: 0 20px 60px rgba(102,126,234,0.15);
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        /* Animated background blobs */
        body::before {
            content: '';
            position: fixed;
            width: 600px; height: 600px;
            background: radial-gradient(circle, rgba(102,126,234,0.18) 0%, transparent 70%);
            top: -200px; left: -200px;
            border-radius: 50%;
            animation: blob1 8s ease-in-out infinite;
        }
        body::after {
            content: '';
            position: fixed;
            width: 500px; height: 500px;
            background: radial-gradient(circle, rgba(118,75,162,0.15) 0%, transparent 70%);
            bottom: -150px; right: -150px;
            border-radius: 50%;
            animation: blob2 10s ease-in-out infinite;
        }

        @keyframes blob1 { 0%,100%{transform:translate(0,0) scale(1)} 50%{transform:translate(40px,30px) scale(1.05)} }
        @keyframes blob2 { 0%,100%{transform:translate(0,0) scale(1)} 50%{transform:translate(-30px,-20px) scale(1.08)} }

        .page-wrapper {
            display: flex;
            align-items: center;
            gap: 60px;
            padding: 20px;
            z-index: 1;
            width: 100%;
            max-width: 1000px;
        }

        /* Left branding panel */
        .brand-panel {
            flex: 1;
            display: none;
        }
        @media(min-width: 900px) { .brand-panel { display: block; } }

        .brand-logo {
            font-family: 'Playfair Display', serif;
            font-size: 42px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 16px;
        }
        .brand-tagline {
            font-size: 18px;
            color: var(--text-light);
            line-height: 1.6;
            margin-bottom: 40px;
        }
        .brand-features { list-style: none; }
        .brand-features li {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 0;
            color: var(--text);
            font-size: 15px;
            border-bottom: 1px solid var(--border);
        }
        .brand-features li:last-child { border-bottom: none; }
        .feature-icon {
            width: 36px; height: 36px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            flex-shrink: 0;
        }

        /* Card */
        .card {
            background: var(--white);
            border-radius: 24px;
            box-shadow: var(--card-shadow);
            padding: 48px 40px;
            width: 100%;
            max-width: 440px;
            animation: slideUp 0.5s ease forwards;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .card-title {
            font-family: 'Playfair Display', serif;
            font-size: 28px;
            color: var(--text);
            margin-bottom: 6px;
        }
        .card-subtitle {
            color: var(--text-light);
            font-size: 14px;
            margin-bottom: 32px;
        }

        /* Tabs */
        .tabs {
            display: flex;
            background: var(--bg);
            border-radius: 12px;
            padding: 4px;
            margin-bottom: 32px;
        }
        .tab {
            flex: 1;
            text-align: center;
            padding: 10px;
            border-radius: 9px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            color: var(--text-light);
            transition: all 0.25s ease;
            user-select: none;
        }
        .tab.active {
            background: var(--white);
            color: var(--primary);
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        /* Forms */
        .form-panel { display: none; }
        .form-panel.active { display: block; }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        .field {
            margin-bottom: 18px;
        }
        .field label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: var(--text);
            margin-bottom: 6px;
        }
        .field input {
            width: 100%;
            padding: 12px 16px;
            border: 1.5px solid var(--border);
            border-radius: 10px;
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            color: var(--text);
            background: var(--white);
            transition: border-color 0.2s, box-shadow 0.2s;
            outline: none;
        }
        .field input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(102,126,234,0.12);
        }
        .field input::placeholder { color: #b0b7c3; }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border: none;
            border-radius: 12px;
            font-family: 'DM Sans', sans-serif;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s, opacity 0.2s;
            margin-top: 8px;
            position: relative;
            overflow: hidden;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102,126,234,0.35);
        }
        .btn-submit:active { transform: translateY(0); }
        .btn-submit:disabled { opacity: 0.7; cursor: not-allowed; transform: none; }

        /* Loading spinner inside button */
        .btn-submit .spinner {
            display: none;
            width: 18px; height: 18px;
            border: 2px solid rgba(255,255,255,0.4);
            border-top-color: white;
            border-radius: 50%;
            animation: spin 0.7s linear infinite;
            margin: 0 auto;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
        .btn-submit.loading .btn-text { display: none; }
        .btn-submit.loading .spinner { display: block; }

        /* Alert messages */
        .alert {
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 20px;
            display: none;
        }
        .alert.error { background: #fef2f2; color: #b91c1c; border: 1px solid #fecaca; display: block; }
        .alert.success { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; display: block; }

        .divider {
            text-align: center;
            color: var(--text-light);
            font-size: 12px;
            margin: 20px 0;
            position: relative;
        }
        .divider::before, .divider::after {
            content: '';
            position: absolute;
            top: 50%;
            width: 42%;
            height: 1px;
            background: var(--border);
        }
        .divider::before { left: 0; }
        .divider::after { right: 0; }
    </style>
</head>
<body>

<div class="page-wrapper">

    <!-- Left Branding -->
    <div class="brand-panel">
        <div class="brand-logo">ShopEasy</div>
        <p class="brand-tagline">Your one-stop destination for everything you love. Fast, reliable, and always delivered.</p>
        <ul class="brand-features">
            <li>
                <div class="feature-icon">🛒</div>
                <span>Thousands of products across all categories</span>
            </li>
            <li>
                <div class="feature-icon">📦</div>
                <span>Real-time order tracking & notifications</span>
            </li>
            <li>
                <div class="feature-icon">🔒</div>
                <span>Secure payments & buyer protection</span>
            </li>
            <li>
                <div class="feature-icon">⚡</div>
                <span>Fast delivery right to your door</span>
            </li>
        </ul>
    </div>

    <!-- Auth Card -->
    <div class="card">
        <h1 class="card-title">Welcome back 👋</h1>
        <p class="card-subtitle" id="card-subtitle">Sign in to your account to continue</p>

        <!-- Tabs -->
        <div class="tabs">
            <div class="tab active" id="tab-login" onclick="switchTab('login')">Sign In</div>
            <div class="tab" id="tab-signup" onclick="switchTab('signup')">Create Account</div>
        </div>

        <!-- LOGIN FORM -->
        <div class="form-panel active" id="panel-login">
            <div id="login-alert" class="alert"></div>

            <div class="field">
                <label>Username</label>
                <input type="text" id="login-username" placeholder="Enter your username" required>
            </div>
            <div class="field">
                <label>Password</label>
                <input type="password" id="login-password" placeholder="Enter your password" required>
            </div>

            <button class="btn-submit" id="login-btn" onclick="handleLogin()">
                <span class="btn-text">Sign In</span>
                <div class="spinner"></div>
            </button>

            <div class="divider">Don't have an account?</div>
            <button class="btn-submit" style="background: var(--bg); color: var(--primary); box-shadow: none; border: 1.5px solid var(--primary);"
                    onclick="switchTab('signup')">
                <span class="btn-text">Create Account</span>
            </button>
        </div>

        <!-- SIGNUP FORM -->
        <div class="form-panel" id="panel-signup">
            <div id="signup-alert" class="alert"></div>

            <div class="form-row">
                <div class="field">
                    <label>First Name</label>
                    <input type="text" id="signup-firstname" placeholder="John" required>
                </div>
                <div class="field">
                    <label>Last Name</label>
                    <input type="text" id="signup-lastname" placeholder="Doe" required>
                </div>
            </div>

            <div class="field">
                <label>Username</label>
                <input type="text" id="signup-username" placeholder="Choose a username" required>
            </div>

            <div class="field">
                <label>Email Address</label>
                <input type="email" id="signup-email" placeholder="john@example.com" required>
            </div>

            <div class="field">
                <label>Password</label>
                <input type="password" id="signup-password" placeholder="At least 6 characters" required>
            </div>

            <button class="btn-submit" id="signup-btn" onclick="handleSignup()">
                <span class="btn-text">Create Account</span>
                <div class="spinner"></div>
            </button>

            <div class="divider">Already have an account?</div>
            <button class="btn-submit" style="background: var(--bg); color: var(--primary); box-shadow: none; border: 1.5px solid var(--primary);"
                    onclick="switchTab('login')">
                <span class="btn-text">Sign In</span>
            </button>
        </div>
    </div>
</div>

<script>
    function switchTab(tab) {
        document.getElementById('tab-login').classList.toggle('active', tab === 'login');
        document.getElementById('tab-signup').classList.toggle('active', tab === 'signup');
        document.getElementById('panel-login').classList.toggle('active', tab === 'login');
        document.getElementById('panel-signup').classList.toggle('active', tab === 'signup');

        const subtitle = document.getElementById('card-subtitle');
        subtitle.textContent = tab === 'login'
            ? 'Sign in to your account to continue'
            : 'Create your free account today';

        // Clear alerts on tab switch
        document.getElementById('login-alert').className = 'alert';
        document.getElementById('signup-alert').className = 'alert';
    }

    function setLoading(btnId, loading) {
        const btn = document.getElementById(btnId);
        btn.disabled = loading;
        btn.classList.toggle('loading', loading);
    }

    function showAlert(id, message, type) {
        const el = document.getElementById(id);
        el.textContent = message;
        el.className = 'alert ' + type;
    }

    function handleLogin() {
        const username = document.getElementById('login-username').value.trim();
        const password = document.getElementById('login-password').value.trim();

        if (!username || !password) {
            showAlert('login-alert', 'Please fill in all fields.', 'error');
            return;
        }

        setLoading('login-btn', true);

        fetch('/api/login?username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password), {
            method: 'POST'
        })
        .then(r => r.text())
        .then(data => {
            if (data === 'LOGIN_SUCCESS') {
                showAlert('login-alert', '✅ Login successful! Redirecting...', 'success');
                setTimeout(() => window.location.href = '/products', 800);
            } else {
                showAlert('login-alert', '❌ Invalid username or password.', 'error');
                setLoading('login-btn', false);
            }
        })
        .catch(() => {
            showAlert('login-alert', '❌ Something went wrong. Try again.', 'error');
            setLoading('login-btn', false);
        });
    }

    function handleSignup() {
        const firstName = document.getElementById('signup-firstname').value.trim();
        const lastName  = document.getElementById('signup-lastname').value.trim();
        const username  = document.getElementById('signup-username').value.trim();
        const email     = document.getElementById('signup-email').value.trim();
        const password  = document.getElementById('signup-password').value.trim();

        if (!firstName || !lastName || !username || !email || !password) {
            showAlert('signup-alert', 'Please fill in all fields.', 'error');
            return;
        }
        if (password.length < 6) {
            showAlert('signup-alert', 'Password must be at least 6 characters.', 'error');
            return;
        }

        setLoading('signup-btn', true);

        const params = new URLSearchParams({ username, password, email, firstName, lastName });

        fetch('/api/signup?' + params.toString(), { method: 'POST' })
        .then(r => r.text())
        .then(data => {
            if (data === 'SIGNUP_SUCCESS') {
                showAlert('signup-alert', '✅ Account created! A welcome email has been sent. Redirecting to login...', 'success');
                setTimeout(() => switchTab('login'), 2000);
                setLoading('signup-btn', false);
            } else if (data === 'USERNAME_TAKEN') {
                showAlert('signup-alert', '❌ Username already taken. Try another.', 'error');
                setLoading('signup-btn', false);
            } else {
                showAlert('signup-alert', '❌ Signup failed. Please try again.', 'error');
                setLoading('signup-btn', false);
            }
        })
        .catch(() => {
            showAlert('signup-alert', '❌ Something went wrong. Try again.', 'error');
            setLoading('signup-btn', false);
        });
    }

    // Allow Enter key to submit
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
            const loginActive = document.getElementById('panel-login').classList.contains('active');
            if (loginActive) handleLogin();
            else handleSignup();
        }
    });
</script>

</body>
</html>
```
