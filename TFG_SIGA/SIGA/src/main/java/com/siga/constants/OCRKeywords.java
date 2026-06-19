package com.siga.constants;

import java.util.List;

public class OCRKeywords {

    public static final String[] TOTAL_KEYWORDS = {
            "TOTAL",
            "A PAGAR",
            "IMPORTE",
            "PRECIO",
            "TOTAL EUR"
    };

    public static final String[] INVALID_PRICE_CONTEXT = {
            "IVA",
            "%",
            "LU-SA",
            "HORARIO",
            "DO:"
    };

    public static final List<String> INVALID_PRODUCT_LINES = List.of(
            "TOTAL",
            "IVA",
            "FECHA",
            "FACTURA",
            "PEDIDO",
            "CLIENTE",
            "DEVOLUCION",
            "DEVOLUCIÓN",
            "RECLAMACION",
            "RECLAMACIÓN",
            "WWW",
            "HTTP",
            "NUMERO",
            "NÚMERO"
    );
}