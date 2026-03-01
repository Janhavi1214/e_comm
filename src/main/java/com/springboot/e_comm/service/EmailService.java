package com.springboot.e_comm.service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    public void sendWelcomeEmail(String toEmail, String firstName) {
        log.info("Sending welcome email | to: {}", toEmail);
        String subject = "Welcome to Our Store! 🎉";
        String body = """
                <h2>Hi %s, welcome!</h2>
                <p>Your account has been created successfully.</p>
                <p>Start shopping now and enjoy exclusive deals!</p>
                """.formatted(firstName);
        sendHtmlEmail(toEmail, subject, body);
    }

    public void sendOrderConfirmationEmail(String toEmail, Long orderId, Double totalAmount) {
        log.info("Sending order confirmation email | to: {} | orderId: {}", toEmail, orderId);
        String subject = "Order Confirmed #" + orderId;
        String body = """
                <h2>Your order is confirmed! ✅</h2>
                <p>Order ID: <strong>#%d</strong></p>
                <p>Total: <strong>₹%.2f</strong></p>
                <p>We'll notify you when it ships.</p>
                """.formatted(orderId, totalAmount);
        sendHtmlEmail(toEmail, subject, body);
    }

    public void sendOrderStatusEmail(String toEmail, Long orderId, String status) {
        log.info("Sending status update email | to: {} | orderId: {} | status: {}", toEmail, orderId, status);
        String subject = "Order #" + orderId + " Status Update";
        String body = """
                <h2>Order Update 📦</h2>
                <p>Your order <strong>#%d</strong> is now: <strong>%s</strong></p>
                """.formatted(orderId, status);
        sendHtmlEmail(toEmail, subject, body);
    }

    public void sendHtmlEmail(String to, String subject, String htmlBody) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setFrom(fromEmail);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(htmlBody, true);
            mailSender.send(message);
            log.info("Email sent successfully | to: {} | subject: {}", to, subject);
        } catch (MessagingException e) {
            log.error("Email send failed | to: {} | subject: {} | error: {}", to, subject, e.getMessage());
            throw new RuntimeException("Email sending failed", e);
        }
    }

    public void sendSimpleEmail(String to, String subject, String text) {
        log.info("Sending simple email | to: {} | subject: {}", to, subject);
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(to);
            message.setSubject(subject);
            message.setText(text);
            mailSender.send(message);
            log.info("Simple email sent | to: {}", to);
        } catch (Exception e) {
            log.error("Simple email failed | to: {} | error: {}", to, e.getMessage());
        }
    }
}