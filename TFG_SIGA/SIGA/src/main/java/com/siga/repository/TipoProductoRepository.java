package com.siga.repository;

import com.siga.entity.TipoProducto;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TipoProductoRepository extends JpaRepository<TipoProducto, Long> {

    TipoProducto findByNombreIgnoreCase(String nombreProducto);
}
