package com.siga.service;

import com.siga.dto.BoletaDTO;
import com.siga.dto.OCRRequestDTO;
import com.siga.entity.Boleta;
import com.siga.entity.Garantia;
import com.siga.entity.TipoProducto;
import com.siga.entity.User;
import com.siga.repository.BoletaRepository;
import com.siga.repository.TipoProductoRepository;
import com.siga.repository.GarantiaRepository;
import com.siga.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class BoletaService {

    private final BoletaRepository boletaRepository;

    private final OCRService ocrService;

    private final GarantiaService garantiaService;

    private final UserRepository userRepository;

    private final GarantiaRepository garantiaRepository;

    private final TipoProductoService tipoProductoService;

    public BoletaService(BoletaRepository boletaRepository, TipoProductoRepository tipoProductoRepository,
                         OCRService ocrService,
                         GarantiaService garantiaService, UserRepository userRepository, GarantiaRepository garantiaRepository,
                         TipoProductoService tipoProductoService) {
        this.boletaRepository = boletaRepository;
        this.ocrService = ocrService;
        this.garantiaService = garantiaService;
        this.userRepository = userRepository;
        this.garantiaRepository = garantiaRepository;
        this.tipoProductoService = tipoProductoService;
    }

    public long diasRestantesGarantia(Garantia garantia) {
        return ChronoUnit.DAYS.between(LocalDate.now(), garantia.getFechaFin());
    }

    public Boleta crearDesdeOCR(OCRRequestDTO request) {

        String texto = request.getTextoOCR();

        LocalDate fecha = ocrService.extraerFecha(texto);
        Double precio = ocrService.extraerPrecio(texto);
        String tienda = ocrService.extraerTienda(texto);

        TipoProducto tipo = tipoProductoService.detectarTipo(texto);

        Integer diasOCR = ocrService.extraerDiasDevolucion(texto);

        User usuario = userRepository.findByEmail(
                request.getEmailUsuario()
        ).orElseThrow(() ->
                new RuntimeException("Usuario no encontrado"));

        // fallback si OCR no detecta días
        int diasGarantia;

        if (diasOCR != null) {
            diasGarantia = diasOCR;
            System.out.println("Días detectados por OCR: " + diasGarantia);
        } else {
            diasGarantia = tipo.getDiasDevolucion();
            System.out.println("Días por tipo producto: " + diasGarantia);
        }

        String nombreProducto = tipo.getNombre();

        Boleta boleta = new Boleta();
        boleta.setFechaCompra(fecha);
        boleta.setPrecio(precio);
        boleta.setNombreProducto(nombreProducto);
        boleta.setTipoProducto(tipo);
        boleta.setTextoOCR(texto);
        boleta.setUsuario(usuario);
        boleta.setTienda(tienda);
        boleta.setImagenPath(request.getImagenPath());

        Boleta guardada = boletaRepository.save(boleta);

        Garantia garantia = new Garantia();
        garantia.setBoleta(guardada);
        garantia.setFechaInicio(fecha);
        garantia.setFechaFin(fecha.plusDays(diasGarantia));
        garantia.setDuracionMeses(0);

        garantiaRepository.save(garantia);

        return guardada;
    }

    public List<BoletaDTO> obtenerPorUsuarioEmail(String email) {
        return boletaRepository.findByUsuarioEmail(email).stream()
                .map(boleta -> {

                    Optional<Garantia> garantiaOpt =
                            garantiaRepository.findByBoleta(boleta);

                    long diasRestantes = 0;

                    if (garantiaOpt.isPresent()) {
                        diasRestantes = diasRestantesGarantia(garantiaOpt.get());
                    }

                    return new BoletaDTO(
                            boleta.getIdBoleta(),
                            boleta.getNombreProducto(),
                            boleta.getFechaCompra(),
                            boleta.getPrecio(),
                            diasRestantes,
                            boleta.getTienda(),
                            boleta.getImagenPath(),
                            boleta.getTipoProducto().getNombre(),
                            garantiaOpt.map(Garantia::getFechaFin).orElse(null)
                    );
                })
                .collect(Collectors.toList());
    }

    public Boleta guardar(Boleta boleta){
        return boletaRepository.save(boleta);
    }

    @Transactional
    public void eliminarBoletaSegura(Long boletaId, String email) {

        Boleta boleta = boletaRepository.findById(boletaId)
                .orElseThrow(() -> new RuntimeException("Boleta no encontrada"));

        if (!boleta.getUsuario()
                .getEmail()
                .equals(email)) {
            throw new RuntimeException("No autorizado");
        }

        Optional<Garantia> garantia = garantiaRepository.findByBoleta(boleta);
        garantia.ifPresent(garantiaRepository::delete);
        boletaRepository.delete(boleta);
    }

}

