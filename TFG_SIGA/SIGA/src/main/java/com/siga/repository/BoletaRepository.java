package com.siga.repository;

import com.siga.entity.Boleta;
import com.siga.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface BoletaRepository extends JpaRepository<Boleta, Long> {

    List<Boleta> findByUsuarioEmail(String email);

    Optional<Boleta> findByNombreProductoAndFechaCompraAndUsuario(
            String nombreProducto,
            LocalDate fechaCompra,
            User usuario
    );

}
