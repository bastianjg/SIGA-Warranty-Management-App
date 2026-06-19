package com.siga.service;

import com.siga.dto.AuthResponseDTO;
import com.siga.dto.LoginRequestDTO;
import com.siga.dto.RegisterRequestDTO;
import com.siga.entity.User;
import com.siga.repository.UserRepository;
import com.siga.security.JWTUtil;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JWTUtil jwtUtil;
    private final EmailService emailService;

    public AuthService(UserRepository userRepository,
                       PasswordEncoder passwordEncoder,
                       JWTUtil jwtUtil, EmailService emailService) {

        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtil = jwtUtil;
        this.emailService = emailService;
    }

    public AuthResponseDTO login(LoginRequestDTO request) {

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() ->
                        new RuntimeException("Usuario no encontrado"));

        if (!user.isVerified()) {
            throw new RuntimeException(
                    "Debes verificar tu correo"
            );
        }

        boolean passwordCorrect =
                passwordEncoder.matches(
                        request.getPassword(),
                        user.getPassword()
                );

        if (!passwordCorrect) {
            throw new RuntimeException("Password incorrecta");
        }

        String token = jwtUtil.generateToken(user.getEmail());

        return new AuthResponseDTO(
                token,
                user.getNombre()
        );
    }

    public void registerVerifiedUser(RegisterRequestDTO request) {

        if (userRepository
                .findByEmail(request.getEmail())
                .isPresent()) {

            throw new RuntimeException(
                    "Ya existe un usuario con ese email");
        }

        User user = new User();

        user.setNombre(request.getNombre());

        user.setEmail(request.getEmail());

        user.setPassword(
                passwordEncoder.encode(
                        request.getPassword()
                )
        );

        user.setFechaRegistro(
                LocalDate.now());

        user.setVerified(true);

        userRepository.save(user);
    }
}