<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head><title>Login</title></head>
<body>
<h1>Login Page</h1>
<form onsubmit="handleLogin(event)">
<input type="text" id="username" placeholder="Username" required>
<input type="password" id="password" placeholder="Password" required>
<button type="submit">Sign In</button>
</form>
<script>
function handleLogin(event) {
event.preventDefault();
fetch('/api/login?username=' + encodeURIComponent(document.getElementById('username').value) + '&password=' + encodeURIComponent(document.getElementById('password').value), {method:'POST'})
.then(r=>r.text())
.then(d=>{if(d==='LOGIN_SUCCESS'){window.location.href='/success'}else{alert('Failed')}})
}
</script>
</body>
</html>