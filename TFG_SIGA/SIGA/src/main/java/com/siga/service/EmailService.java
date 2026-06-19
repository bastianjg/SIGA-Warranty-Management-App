package com.siga.service;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    private final JavaMailSender mailSender;

    public EmailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public void sendVerificationCode(String destino, String codigo) {

        SimpleMailMessage mensaje =
                new SimpleMailMessage();

        mensaje.setTo(destino);

        mensaje.setSubject(
                "Código de verificación SIGA"
        );

        mensaje.setText(
                "Tu código de verificación es: "
                        + codigo
        );

        mailSender.send(mensaje);
    }
}
