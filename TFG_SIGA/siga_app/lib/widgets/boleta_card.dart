import 'package:flutter/material.dart';
import '../utils/date_utils.dart';

class BoletaCard extends StatelessWidget {
  final String nombre;
  final DateTime fechaCompra;
  final double precio;
  final int diasRestantes;

  final VoidCallback onDelete;
  final VoidCallback onView;

  const BoletaCard({
    super.key,
    required this.nombre,
    required this.fechaCompra,
    required this.precio,
    required this.diasRestantes,
    required this.onDelete,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final bool vencida = diasRestantes < 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      child: ListTile(
        leading: Icon(
          vencida ? Icons.warning : Icons.check_circle,
          color: vencida ? Colors.red : Colors.green,
        ),

        title: Text(nombre),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Precio: €$precio"),
            Text(
              "Compra: ${formatearFecha(fechaCompra)}",
            ),

            Text(
              vencida
                  ? "Garantía vencida"
                  : "Quedan $diasRestantes días",

              style: TextStyle(
                color: vencida ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            // BOTÓN VER DETALLE
            IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: onView,
            ),

            // BOTÓN ELIMINAR
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

}