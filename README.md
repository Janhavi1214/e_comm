# 🛒 E-Commerce Application — Spring Boot

A full-stack e-commerce web application built with Spring Boot, featuring a complete shopping experience for users and a powerful admin panel. Also includes a production-ready REST API with JWT authentication.

---

## 🚀 Features

### 👤 User Features
- Register & login with session-based authentication
- Browse and search products
- Add to cart, update quantities, remove items
- Checkout with mock payment gateway (Card, UPI, Net Banking, COD)
- View order history and track order status
- Manage profile (edit details, change password)
- Email notifications (welcome, order confirmed, status updates)

### 👑 Admin Features
- Admin dashboard with business stats (revenue, order counts)
- Manage products (add, edit, delete)
- View and manage all orders
- Update order status (Pending → Confirmed → Shipped → Delivered)
- Automatic email sent to customer on every status change

### 🔌 REST API
- JWT-based authentication
- Full CRUD for products (public GET, admin POST/PUT/DELETE)
- Order management with pagination
- User management (admin only)
- Swagger UI for interactive API docs

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Backend | Java 17, Spring Boot 3.2 |
| Web | Spring MVC, JSP, JSTL |
| Security | Spring Security, JWT (jjwt 0.11.5) |
| Database | MySQL, Spring Data JPA, Hibernate |
| Email | JavaMail (Gmail SMTP) |
| API Docs | SpringDoc OpenAPI / Swagger UI |
| Build | Maven |
| Utilities | Lombok, BCrypt |

---

## 📁 Project Structure

```
src/main/java/com/springboot/e_comm/
├── config/           # SecurityConfig, SwaggerConfig
├── controller/       # MVC Controllers (JSP views)
│   └── api/          # REST API Controllers (JSON)
├── dto/              # Data Transfer Objects
├── entity/           # JPA Entities
├── exception/        # GlobalExceptionHandler, ResourceNotFoundException
├── repo/             # Spring Data JPA Repositories
├── security/         # JwtUtil, JwtFilter
└── service/          # Business Logic Layer

src/main/webapp/WEB-INF/views/
├── admin/            # Admin dashboard, products, orders
├── cart/             # Cart page
├── error/            # Custom error pages
├── order/            # Order history, confirmation, tracking
├── payment/          # Payment page
├── product/          # Product list, details
└── user/             # Profile page
```

---

## ⚙️ Setup & Installation

### Prerequisites
- Java 17+
- Maven
- MySQL 8+
- Gmail account (for email notifications)

### 1. Clone the repository
```bash
git clone https://github.com/yourusername/ecommerce-springboot.git
cd ecommerce-springboot
```

### 2. Create MySQL database
```sql
CREATE DATABASE ecommerce_db;
```

### 3. Configure `application.properties`
```properties
# Database
spring.datasource.url=jdbc:mysql://localhost:3306/ecommerce_db
spring.datasource.username=your_mysql_username
spring.datasource.password=your_mysql_password

# JPA
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

# Email (Gmail)
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=your_email@gmail.com
spring.mail.password=your_app_password
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true

# View resolver
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp

# Swagger
springdoc.swagger-ui.path=/swagger-ui
springdoc.api-docs.path=/api-docs
```

### 4. Run the application
```bash
mvn spring-boot:run
```

### 5. Access the app
| URL | Description |
|---|---|
| `http://localhost:8080/login` | Login page |
| `http://localhost:8080/products` | Product listing |
| `http://localhost:8080/admin/dashboard` | Admin panel |
| `http://localhost:8080/swagger-ui` | API documentation |

---

## 🔑 Default Users

> If sample data initialization is enabled, the following accounts are created on startup:

| Username | Password | Role |
|---|---|---|
| `admin` | `admin123` | ADMIN |
| `john` | `john123` | USER |

---

## 📡 REST API Endpoints

### Authentication (Public)
| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/auth/login` | Login → returns JWT token |
| POST | `/api/auth/signup` | Register new account |

### Products (GET is public, others require Admin JWT)
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/products?page=0&size=10&sortBy=price` | Get paginated products |
| GET | `/api/products/{id}` | Get product by ID |
| GET | `/api/products/search?name=laptop` | Search products |
| POST | `/api/products` | Create product (Admin) |
| PUT | `/api/products/{id}` | Update product (Admin) |
| DELETE | `/api/products/{id}` | Delete product (Admin) |

### Orders (Requires JWT)
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/orders?page=0&size=5` | Get my orders |
| GET | `/api/orders/{id}` | Get order by ID |
| GET | `/api/orders/all` | Get all orders (Admin) |
| PATCH | `/api/orders/{id}/status` | Update status (Admin) |
| DELETE | `/api/orders/{id}/cancel` | Cancel order |

### Users (Requires JWT)
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/users/me` | Get my profile |
| GET | `/api/users` | Get all users (Admin) |
| PATCH | `/api/users/{id}/activate` | Activate user (Admin) |
| PATCH | `/api/users/{id}/deactivate` | Deactivate user (Admin) |

### Using the API
1. Login via `POST /api/auth/login` to get a token
2. Add header to protected requests: `Authorization: Bearer <token>`
3. Or use Swagger UI at `http://localhost:8080/swagger-ui` — click **Authorize** and paste token

---

## 📸 App Screenshots

> Add screenshots of your app here after deployment

- Login page
- Product listing
- Shopping cart
- Payment page
- Order tracking
- Admin dashboard

---

## 🏗️ Key Design Decisions

- **Dual auth system** — Session-based for browser (JSP), JWT for REST API
- **Service layer** — All business logic in `@Service` classes, controllers stay thin
- **DTO pattern** — Separate request/response objects for API, validated with `@Valid`
- **Global exception handling** — `@ControllerAdvice` catches all exceptions, returns JSON for API and error page for MVC
- **Pagination** — Spring Data `Pageable` on all list endpoints
- **Email is non-blocking** — Email failures are caught and logged, never break the main flow

---

## 📝 License

This project is for educational purposes.

---

## 👨‍💻 Author

Built with ❤️ using Spring Boot
