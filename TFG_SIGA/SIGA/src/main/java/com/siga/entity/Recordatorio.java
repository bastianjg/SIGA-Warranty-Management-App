package com.siga.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Getter
@Setter
public class Recordatorio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idRecordatorio;
   
    @ManyToOne
    @JoinColumn(name = "garantia_id")
    private Garantia garantia;
    
    private LocalDate fechaAviso;
    private Boolean enviado;
}
