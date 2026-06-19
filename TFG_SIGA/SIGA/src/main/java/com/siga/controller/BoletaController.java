package com.siga.controller;

import com.siga.dto.BoletaDTO;
import com.siga.dto.OCRRequestDTO;
import com.siga.entity.Boleta;
import com.siga.service.BoletaService;
import com.siga.service.OCRService;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.security.core.Authentication;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@RestController
@RequestMapping("/api")
public class BoletaController {

    private final BoletaService boletaService;
    private final OCRService ocrService;

    public BoletaController(BoletaService boletaService, OCRService ocrService) {
        this.boletaService = boletaService;
        this.ocrService = ocrService;
    }

    @PostMapping("/boletas/ocr")
    public Boleta crearBoletaDesdeOCR(@RequestBody OCRRequestDTO request) {
        return boletaService.crearDesdeOCR(request);
    }

    @GetMapping("/boletas")
    public List<BoletaDTO> obtenerPorUsuario(
            Authentication authentication) {

        String email = authentication.getName();

        return boletaService.obtenerPorUsuarioEmail(email);
    }

    @PostMapping("/boletas")
    public Boleta crearBoleta(@RequestBody Boleta boleta) {
        return boletaService.guardar(boleta);
    }

    @PostMapping("/ocr")
    public ResponseEntity<String> recibirImagen(@RequestParam("file") MultipartFile file,
                                                Authentication authentication) {

        try {
            String uploadDir = System.getProperty("user.dir") + "/uploads/";
            File directorio = new File(uploadDir);
            if (!directorio.exists()) {
                directorio.mkdirs();
            }

            String nombreArchivo = System.currentTimeMillis() + "_" + file.getOriginalFilename();
            String ruta = uploadDir + nombreArchivo;

            File destino = new File(ruta);
            file.transferTo(destino);

            String texto = ocrService.extraerTextoDesdeImagen(ruta);
            texto = texto.replaceAll("[^\\x00-\\x7F]", "");

            System.out.println("Texto OCR:");
            System.out.println(texto);

            OCRRequestDTO dto = new OCRRequestDTO();
            dto.setTextoOCR(texto);
            String email = authentication.getName();
            dto.setEmailUsuario(email);
            dto.setImagenPath(nombreArchivo);

            Boleta boleta = boletaService.crearDesdeOCR(dto);

            return ResponseEntity.ok("Boleta creada con ID: " + boleta.getIdBoleta());

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Error OCR");
        }
    }

    @GetMapping("/uploads/{filename}")
    public ResponseEntity<Resource> getImage(@PathVariable String filename) {

        try {
            String uploadDir = System.getProperty("user.dir") + "/uploads/";

            Path filePath = Paths.get(uploadDir).resolve(filename).normalize();
            Resource resource = new UrlResource(filePath.toUri());

            if (!resource.exists() || !resource.isReadable()) {
                return ResponseEntity.notFound().build();
            }

            // detectar tipo de imagen (opcional pero mejor)
            String contentType = "image/jpeg";

            if (filename.toLowerCase().endsWith(".png")) {
                contentType = "image/png";
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .body(resource);

        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @DeleteMapping("/boletas/{id}")
    public ResponseEntity<Void> eliminarBoleta(
            @PathVariable Long id,
            Authentication authentication) {

        String email =
                authentication.getName();

        boletaService.eliminarBoletaSegura(
                id,
                email);

        return ResponseEntity.noContent().build();
    }

}
