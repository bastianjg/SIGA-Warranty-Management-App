package com.siga.service;

import com.siga.constants.OCRKeywords;
import com.siga.constants.OCRStores;
import com.siga.entity.Boleta;
import net.sourceforge.tess4j.ITesseract;
import net.sourceforge.tess4j.Tesseract;
import org.springframework.stereotype.Service;

import java.io.File;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class OCRService {

    public LocalDate extraerFecha(String texto) {

        // dd/MM/yy
        Pattern pattern1 =
                Pattern.compile("(\\d{2}/\\d{2}/\\d{2})");

        Matcher matcher1 = pattern1.matcher(texto);

        if (matcher1.find()) {

            DateTimeFormatter formatter =
                    DateTimeFormatter.ofPattern("dd/MM/yy");

            return LocalDate.parse(
                    matcher1.group(1),
                    formatter
            );
        }

        // dd.MM.yyyy
        Pattern pattern2 =
                Pattern.compile("(\\d{2}\\.\\d{2}\\.\\d{4})");

        Matcher matcher2 = pattern2.matcher(texto);

        if (matcher2.find()) {

            DateTimeFormatter formatter =
                    DateTimeFormatter.ofPattern("dd.MM.yyyy");

            return LocalDate.parse(matcher2.group(1), formatter);
        }

        return LocalDate.now();
    }

    public Double extraerPrecio(String texto) {

        texto = texto.toUpperCase();

        // 1. Buscamos precio por contexto, palabras como TOTAL

        for (String keyword : OCRKeywords.TOTAL_KEYWORDS) {

            Pattern pattern = Pattern.compile(
                    keyword + "\\s*[:]?\\s*(\\d+[.,]\\d{2})"
            );

            Matcher matcher = pattern.matcher(texto);

            if (matcher.find()) {

                String valor = matcher.group(1)
                        .replace(",", ".");

                return Double.parseDouble(valor);
            }
        }

        // 2. Fallback inteligente, obtiene el más alto, evitando obtener códigos largos

        Pattern pattern = Pattern.compile("\\b(\\d+[.,]\\d{2})\\b");
        Matcher matcher = pattern.matcher(texto);

        double max = 0.0;

        while (matcher.find()) {

            String valorTexto = matcher.group(1);

            int start = matcher.start();
            int end = matcher.end();

            boolean pareceFecha = false;

            if (start >= 3 && end + 5 <= texto.length()) {

                String alrededor = texto.substring(start - 3, end + 5);

                if (alrededor.matches(".*\\d{2}[./-]\\d{2}[./-]\\d{4}.*")) {
                    pareceFecha = true;
                }
            }

            if (pareceFecha) {
                continue;
            }

            String contexto = texto.substring(
                    Math.max(0, start - 5),
                    Math.min(texto.length(), end + 5)
            );

            // ignorar horas y porcentajes
            boolean invalido = false;

            for (String invalid : OCRKeywords.INVALID_PRICE_CONTEXT) {

                if (contexto.contains(invalid)) {
                    invalido = true;
                    break;
                }
            }

            if (invalido) {
                continue;
            }

            double valor = Double.parseDouble(
                    valorTexto.replace(",", ".")
            );

            if (valor > max && valor < 10000) {
                max = valor;
            }
        }

        return max > 0 ? max : null;
    }

    public String extraerTextoDesdeImagen(String rutaImagen) {
        try {
            ITesseract tesseract = new Tesseract();

            tesseract.setDatapath("src/main/resources/tessdata");
            tesseract.setLanguage("spa");

            return tesseract.doOCR(new File(rutaImagen));

        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public Integer extraerDiasDevolucion(String textoOCR) {

        textoOCR = textoOCR.toLowerCase();

        Pattern pattern = Pattern.compile("(\\d{1,3})\\s*d[ií]as");
        Matcher matcher = pattern.matcher(textoOCR);

        if (matcher.find()) {
            return Integer.parseInt(matcher.group(1));
        }

        return null;
    }

    public String extraerTienda(String textoOCR) {

        String texto = textoOCR.toLowerCase();

        for (Map.Entry<String, String> entry :
                OCRStores.STORES.entrySet()) {

            if (texto.contains(entry.getKey())) {
                return entry.getValue();
            }
        }

        return "Desconocida";
    }

    public String extraerNombreProducto(String textoOCR) {

        String[] lineas = textoOCR.split("\\n");

        for (String linea : lineas) {

            linea = linea.trim();

            if (linea.isEmpty()) continue;

            if (linea.length() < 4) continue;

            if (linea.matches(".*\\d{6,}.*")) continue;

            final String lineaUpper = linea.toUpperCase();

            boolean invalida = OCRKeywords.INVALID_PRODUCT_LINES.stream()
                    .anyMatch(keyword ->
                            lineaUpper.contains(keyword)
                    );

            if (invalida) continue;

            return linea;
        }

        return "Producto desconocido";
    }

}
