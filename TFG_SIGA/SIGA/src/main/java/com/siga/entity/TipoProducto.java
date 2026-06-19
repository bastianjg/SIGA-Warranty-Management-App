package com.siga.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@NoArgsConstructor
public class TipoProducto {

    public TipoProducto(String nombre,
                        Integer duracionGarantiaMeses,
                        Integer diasDevolucion,
                        String keywords,
                        boolean tieneGarantia) {

        this.nombre = nombre;
        this.duracionGarantiaMeses = duracionGarantiaMeses;
        this.diasDevolucion = diasDevolucion;
        this.keywords = keywords;
        this.tieneGarantia = tieneGarantia;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idTipo;

    private String nombre;

    private Integer duracionGarantiaMeses;

    private boolean tieneGarantia;

    private int diasDevolucion;

    @Column(name = "keywords")
    private String keywords;
}