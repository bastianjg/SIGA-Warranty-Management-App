package com.siga.service;

import com.siga.dto.RegisterRequestDTO;
import com.siga.entity.VerificationCode;
import com.siga.repository.VerificationCodeRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;

@Service
public class VerificationCodeService {

    private final VerificationCodeRepository verificationCodeRepository;

    private final EmailService emailService;

    private final AuthService authService;

    public VerificationCodeService(
            VerificationCodeRepository verificationCodeRepository,
            EmailService emailService, AuthService authService
    ) {

        this.verificationCodeRepository =
                verificationCodeRepository;

        this.emailService = emailService;
        this.authService = authService;
    }

    public void enviarCodigo(
            String nombre,
            String email,
            String password
    ) {

        int codigo =
                100000 + new Random().nextInt(900000);

        // borrar código anterior si existe

        Optional<VerificationCode> existente =
                verificationCodeRepository.findByEmail(email);

        existente.ifPresent(
                verificationCodeRepository::delete
        );

        // crear nuevo código

        VerificationCode verificationCode =
                new VerificationCode();

        verificationCode.setNombre(nombre);

        verificationCode.setEmail(email);

        verificationCode.setPassword(password);

        verificationCode.setCodigo(codigo);

        verificationCode.setExpirationTime(
                LocalDateTime.now().plusMinutes(10)
        );

        verificationCodeRepository.save(
                verificationCode
        );

        // enviar email

        emailService.sendVerificationCode(
                email,
                String.valueOf(codigo)
        );
    }

    public void verificarCodigo(
            String email,
            int codigoIngresado) {

        VerificationCode verificationCode =
                verificationCodeRepository
                        .findByEmail(email)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Código no encontrado"));

        // VALIDAR EXPIRACIÓN
        if (verificationCode
                .getExpirationTime()
                .isBefore(LocalDateTime.now())) {

            throw new RuntimeException(
                    "Código expirado");
        }

        // VALIDAR CÓDIGO
        if (verificationCode.getCodigo()
                != codigoIngresado) {

            throw new RuntimeException(
                    "Código incorrecto");
        }

        // CREAR USUARIO
        RegisterRequestDTO request =
                new RegisterRequestDTO();

        request.setNombre(
                verificationCode.getNombre());

        request.setEmail(
                verificationCode.getEmail());

        request.setPassword(
                verificationCode.getPassword());

        authService.registerVerifiedUser(request);

        // ELIMINAR CÓDIGO USADO
        verificationCodeRepository
                .delete(verificationCode);
    }
}