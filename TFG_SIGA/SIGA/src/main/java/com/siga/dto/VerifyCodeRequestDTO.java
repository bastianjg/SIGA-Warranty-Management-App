package com.siga.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class VerifyCodeRequestDTO {

    private String email;

    private int codigo;
}