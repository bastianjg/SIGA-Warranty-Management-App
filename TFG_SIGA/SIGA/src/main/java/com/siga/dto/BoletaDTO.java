package com.siga.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
public class BoletaDTO {

    private Long idBoleta;
    private String nombreProducto;
    private LocalDate fechaCompra;
    private Double precio;
    private long diasRestantesGarantia;
    private String tienda;
    private String imagenPath;
    private String categoria;
    private LocalDate fechaFinGarantia;

    public BoletaDTO(Long idBoleta, String nombreProducto, LocalDate fechaCompra,
                     Double precio, long diasRestantesGarantia, String tienda,
                     String imagenPath, String categoria, LocalDate fechaFinGarantia) {
        this.idBoleta = idBoleta;
        this.nombreProducto = nombreProducto;
        this.fechaCompra = fechaCompra;
        this.precio = precio;
        this.diasRestantesGarantia = diasRestantesGarantia;
        this.tienda = tienda;
        this.imagenPath = imagenPath;
        this.categoria = categoria;
        this.fechaFinGarantia = fechaFinGarantia;
    }
}
