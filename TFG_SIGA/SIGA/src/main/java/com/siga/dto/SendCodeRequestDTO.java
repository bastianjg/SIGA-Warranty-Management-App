package com.siga.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SendCodeRequestDTO {

    private String nombre;

    private String email;

    private String password;
}