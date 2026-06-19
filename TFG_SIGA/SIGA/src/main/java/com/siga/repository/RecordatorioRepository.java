package com.siga.repository;

import com.siga.entity.Recordatorio;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RecordatorioRepository extends JpaRepository<Recordatorio, Long> {
}
