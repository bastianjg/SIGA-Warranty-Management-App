package com.siga.service;

import com.siga.entity.TipoProducto;
import com.siga.repository.TipoProductoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TipoProductoService {

    private final TipoProductoRepository tipoProductoRepository;

    public TipoProductoService (TipoProductoRepository tipoProductoRepository) {
        this.tipoProductoRepository = tipoProductoRepository;
    }

    public TipoProducto detectarTipo(String texto) {
        texto = texto.toLowerCase();

        List<TipoProducto> tipos = tipoProductoRepository.findAll();

        for (TipoProducto tipo : tipos) {

            if (tipo.getKeywords() == null) continue;

            String[] keywords = tipo.getKeywords().split(",");

            for (String keyword : keywords) {
                if (texto.contains(keyword.trim())) {
                    return tipo;
                }
            }
        }

        // fallback
        return tipoProductoRepository.findByNombreIgnoreCase("OTRO");
    }
}
