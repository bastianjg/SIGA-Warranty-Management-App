class Boleta {

  final int idBoleta;
  final String nombreProducto;
  final String? tienda;
  final double? precio;
  final DateTime fechaCompra;
  final String? imagenPath;
  final String? textoOCR;
  final int diasRestantesGarantia;

  final String? categoria;
  final DateTime? fechaFinGarantia;

  Boleta({
    required this.idBoleta,
    required this.nombreProducto,
    required this.fechaCompra,
    required this.diasRestantesGarantia,

    this.tienda,
    this.precio,
    this.imagenPath,
    this.textoOCR,

    this.categoria,
    this.fechaFinGarantia,
  });

  factory Boleta.fromJson(Map<String, dynamic> json) {

    return Boleta(

      idBoleta: json['idBoleta'],

      nombreProducto: json['nombreProducto'],

      tienda: json['tienda'],

      precio: json['precio'] != null
          ? (json['precio'] as num).toDouble()
          : null,

      fechaCompra: DateTime.parse(json['fechaCompra']),

      imagenPath: json['imagenPath'],

      textoOCR: json['textoOCR'],

      diasRestantesGarantia:
          json['diasRestantesGarantia'] ?? 0,

      categoria: json['categoria'],

      fechaFinGarantia:
          json['fechaFinGarantia'] != null
              ? DateTime.parse(json['fechaFinGarantia'])
              : null,
    );
  }
}