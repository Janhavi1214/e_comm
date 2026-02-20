package com.springboot.e_comm.config;

import jakarta.websocket.ClientEndpointConfig;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;

public class AuthenticationManagerBuilder {
    public ClientEndpointConfig.Builder authenticationProvider(DaoAuthenticationProvider daoAuthenticationProvider) {
        return null;
    }
}
