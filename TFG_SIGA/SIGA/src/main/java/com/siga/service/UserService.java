package com.siga.service;

import com.siga.entity.User;
import com.siga.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserService {

    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public void eliminarUsuario(
            String email,
            String password
    ) {

        User usuario = userRepository.findByEmail(email)
                .orElseThrow(() ->
                        new RuntimeException("Usuario no encontrado"));

        if (!passwordEncoder.matches(
                password,
                usuario.getPassword()
        )) {
            throw new RuntimeException("Contraseña incorrecta");
        }

        userRepository.delete(usuario);

        System.out.println("Usuario eliminado correctamente");
    }
}