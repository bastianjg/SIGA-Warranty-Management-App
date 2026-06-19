package com.siga.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Getter
@Setter
public class Garantia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idGarantia;

    @OneToOne @JoinColumn(name = "boleta_id")
    private Boleta boleta;

    @ManyToOne
    @JoinColumn(name = "tipo_producto_id")
    private TipoProducto tipoProducto;

    private Integer duracionMeses;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
}
