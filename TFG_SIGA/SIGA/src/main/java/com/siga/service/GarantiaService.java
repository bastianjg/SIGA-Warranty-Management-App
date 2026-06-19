package com.siga.service;

import com.siga.entity.Boleta;
import com.siga.entity.TipoProducto;
import com.siga.enums.TipoProductoEnums;
import com.siga.repository.GarantiaRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

@Service
public class GarantiaService {

    public boolean garantiaVencida(LocalDate fechaCompra, int meses) {
        return fechaCompra.plusMonths(meses).isBefore(LocalDate.now());
    }

    public int obtenerMesesGarantia(TipoProducto tipoProducto) {
        return tipoProducto.getDuracionGarantiaMeses();
    }

    public LocalDate calcularFinGarantia(Boleta boleta, int mesesGarantia) {
        return boleta.getFechaCompra().plusMonths(mesesGarantia);
    }

}
