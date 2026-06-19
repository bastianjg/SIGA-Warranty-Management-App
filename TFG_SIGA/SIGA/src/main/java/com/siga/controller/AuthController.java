package com.siga.controller;

import com.siga.dto.*;
import com.siga.entity.User;
import com.siga.entity.VerificationCode;
import com.siga.repository.UserRepository;
import com.siga.service.AuthService;
import com.siga.service.VerificationCodeService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin("*")
public class AuthController {

    private final AuthService authService;

    private final VerificationCodeService verificationCodeService;

    public AuthController(AuthService authService,
                          VerificationCodeService verificationCodeService) {
        this.authService = authService;
        this.verificationCodeService = verificationCodeService;
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponseDTO> login(
            @RequestBody LoginRequestDTO request
    ) {

        return ResponseEntity.ok(
                authService.login(request)
        );
    }

    @PostMapping("/send-code")
    public ResponseEntity<String> sendCode(
            @RequestBody SendCodeRequestDTO request
    ) {

        verificationCodeService.enviarCodigo(
                request.getNombre(),
                request.getEmail(),
                request.getPassword()
        );

        return ResponseEntity.ok(
                "Código enviado correctamente"
        );
    }

    @PostMapping("/verify-code")
    public ResponseEntity<String> verifyCode(
            @RequestBody VerifyCodeRequestDTO request) {

        verificationCodeService.verificarCodigo(
                request.getEmail(),
                request.getCodigo()
        );

        return ResponseEntity.ok(
                "Cuenta verificada correctamente"
        );
    }
}