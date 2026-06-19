package com.siga.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OCRRequestDTO {

    private String textoOCR;
    private String emailUsuario;
    private String imagenPath;

}
