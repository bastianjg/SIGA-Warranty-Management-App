import 'package:flutter/material.dart';
import '../models/boleta.dart';
import '../services/api_service.dart';
import '../utils/date_utils.dart';

class BoletaDetailScreen extends StatelessWidget {

  final Boleta boleta;

  final ApiService apiService = ApiService();

  BoletaDetailScreen({
    super.key,
    required this.boleta,
  });

  @override
  Widget build(BuildContext context) {
    
    final imageUrl = "${ApiService.baseUrl}/uploads/${boleta.imagenPath}";

    final bool vencida =
        boleta.diasRestantesGarantia < 0;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Detalle boleta"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // IMAGEN

            if (boleta.imagenPath != null)

            FutureBuilder<Map<String, String>>(

              future: apiService.getHeaders(),

              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final headers = snapshot.data!;

                return GestureDetector(

                  onTap: () {

                    showDialog(
                      context: context,

                      builder: (_) {

                        return Dialog(

                          backgroundColor: Colors.black,

                          child: InteractiveViewer(

                            child: Image.network(
                              imageUrl,
                              headers: headers,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    );
                  },

                  child: ClipRRect(

                    borderRadius: BorderRadius.circular(12),

                    child: Image.network(
                      imageUrl,
                      headers: headers,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // NOMBRE PRODUCTO

            Text(
              boleta.nombreProducto,

              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // INFO

            detalleItem(
              "Tienda",
              boleta.tienda ?? "No detectada",
            ),

            detalleItem(
              "Precio",
              "€${boleta.precio?.toStringAsFixed(2) ?? '0.00'}",
            ),

            detalleItem(
              "Fecha compra",
              formatearFecha(boleta.fechaCompra),
            ),

            detalleItem(
              "Categoría",
              boleta.categoria ?? "Sin categoría",
            ),

            if (boleta.fechaFinGarantia != null)

              detalleItem(
                "Garantía hasta",
                boleta.fechaFinGarantia!
                    .toString()
                    .split(' ')[0],
              ),

            const SizedBox(height: 24),

            // ESTADO GARANTÍA

            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(

                color: vencida
                    ? Colors.red.shade100
                    : Colors.green.shade100,

                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(

                children: [

                  Icon(
                    vencida
                        ? Icons.warning
                        : Icons.verified,

                    color:
                        vencida
                            ? Colors.red
                            : Colors.green,

                    size: 40,
                  ),

                  const SizedBox(height: 10),

                  Text(

                    vencida
                        ? "Garantía vencida"
                        : "Garantía activa",

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,

                      color:
                          vencida
                              ? Colors.red
                              : Colors.green,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(

                    vencida
                        ? "La garantía ya expiró"
                        : "Quedan ${boleta.diasRestantesGarantia} días",

                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detalleItem(String titulo, String valor) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 14),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(
            titulo,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            valor,

            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}