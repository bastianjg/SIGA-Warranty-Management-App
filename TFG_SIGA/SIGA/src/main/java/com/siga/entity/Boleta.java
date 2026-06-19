package com.siga.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Getter
@Setter
public class Boleta {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idBoleta;
    
    @ManyToOne
    @JoinColumn(name = "usuario_id")
    private User usuario;

    @NotNull
    private String nombreProducto;

    private String tienda;
    private Double precio;
    private LocalDate fechaCompra;
    private String imagenPath;

    @Column(name = "textoocr", columnDefinition = "TEXT")
    private String textoOCR;

    @ManyToOne
    @JoinColumn(name = "tipo_producto_id")
    private TipoProducto tipoProducto;

    @OneToOne(mappedBy = "boleta", cascade = CascadeType.ALL, orphanRemoval = true)
    private Garantia garantia;

}
