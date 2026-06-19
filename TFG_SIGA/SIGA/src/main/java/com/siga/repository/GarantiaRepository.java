package com.siga.repository;

import com.siga.entity.Boleta;
import com.siga.entity.Garantia;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface GarantiaRepository extends JpaRepository<Garantia, Long> {

    Optional<Garantia> findByBoleta(Boleta boleta);

    void deleteByBoleta(Boleta boleta);
}
