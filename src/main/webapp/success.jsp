<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head><title>Success</title></head>
<body>
<h1>Login Successful!</h1>
<p>Welcome <%= session.getAttribute("loggedInUser") %></p>
<a href="/logout">Logout</a>
</body>
</html>