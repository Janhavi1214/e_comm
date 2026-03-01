<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error ${errorCode}</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: Arial; background: #f8f9fa;
            min-height: 100vh; display: flex;
            align-items: center; justify-content: center;
            padding: 20px;
        }

        .error-card {
            background: white; border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            padding: 50px 40px; text-align: center;
            max-width: 500px; width: 100%;
        }

        .error-code {
            font-size: 80px; font-weight: bold;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            line-height: 1; margin-bottom: 16px;
        }

        .error-icon { font-size: 48px; margin-bottom: 16px; }

        .error-title {
            font-size: 24px; font-weight: bold;
            color: #333; margin-bottom: 12px;
        }

        .error-message {
            font-size: 15px; color: #666;
            line-height: 1.6; margin-bottom: 32px;
        }

        .btn {
            display: inline-block; padding: 12px 24px;
            border-radius: 6px; text-decoration: none;
            font-size: 14px; font-weight: bold;
            margin: 6px; transition: all 0.2s;
        }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #764ba2; }
        .btn-secondary { background: #f3f4f6; color: #555; }
        .btn-secondary:hover { background: #e5e7eb; }

        .divider {
            border: none; border-top: 1px solid #f0f0f0;
            margin: 28px 0;
        }

        .hint { font-size: 12px; color: #aaa; }
    </style>
</head>
<body>
<div class="error-card">

    <!-- Icon based on error code -->
    <div class="error-icon">
        <c:choose>
            <c:when test="${errorCode == '404'}">🔍</c:when>
            <c:when test="${errorCode == '400'}">⚠️</c:when>
            <c:otherwise>💥</c:otherwise>
        </c:choose>
    </div>

    <div class="error-code">${errorCode}</div>
    <div class="error-title">${errorTitle}</div>
    <div class="error-message">${errorMessage}</div>

    <hr class="divider">

    <a href="/products" class="btn btn-primary">🏠 Go Home</a>
    <a href="javascript:history.back()" class="btn btn-secondary">← Go Back</a>

    <p class="hint" style="margin-top: 24px;">
        If this keeps happening, please contact support.
    </p>

</div>
</body>
</html>
