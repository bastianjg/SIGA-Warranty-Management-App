package com.siga.controller;

import com.siga.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;

@RestController
@RequestMapping("/api/users")
@CrossOrigin("*")
public class UserController {

    private final UserService userService;

    public UserController (UserService userService){
        this.userService = userService;
    }

    @DeleteMapping
    public ResponseEntity<Void> eliminarUsuario(
            @RequestParam String password,
            Authentication authentication
    ) {

        String email = authentication.getName();

        userService.eliminarUsuario(
                email,
                password
        );

        return ResponseEntity.noContent().build();
    }
}
