<%@ include file="/views/layout/header.jsp" %>

<div class="row justify-content-center">
    <div class="col-md-6">
        <div class="card shadow-lg">
            <div class="card-body p-5">
                <h2 class="text-center mb-4">Create Account</h2>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form method="POST" action="/register" novalidate>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="firstName" class="form-label">First Name</label>
                            <input type="text" class="form-control ${firstName != null ? 'is-invalid' : ''}"
                                   id="firstName" name="firstName" required>
                            <c:if test="${firstName != null}">
                                <div class="invalid-feedback">First name is required</div>
                            </c:if>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="lastName" class="form-label">Last Name</label>
                            <input type="text" class="form-control" id="lastName" name="lastName" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="username" class="form-label">Username</label>
                        <input type="text" class="form-control" id="username" name="username"
                               minlength="3" required>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" class="form-control" id="password" name="password"
                               minlength="6" required>
                        <small class="form-text text-muted">At least 6 characters</small>
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label">Phone (Optional)</label>
                        <input type="tel" class="form-control" id="phone" name="phone">
                    </div>

                    <button type="submit" class="btn btn-primary w-100">Register</button>
                </form>

                <p class="text-center mt-3">
                    Already have an account? <a href="/login">Login here</a>
                </p>
            </div>
        </div>
    </div>
</div>

<%@ include file="/views/layout/footer.jsp" %>