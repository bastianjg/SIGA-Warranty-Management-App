import 'package:flutter/material.dart';
import '../models/boleta.dart';
import '../services/api_service.dart';
import '../widgets/boleta_card.dart';
import '../services/auth_service.dart';
import 'boleta_detail_screen.dart';
import '../services/notification_service.dart';
import '../services/preferences_service.dart';

class BoletasListScreen extends StatefulWidget {
  const BoletasListScreen({super.key});

  @override
  State<BoletasListScreen> createState() => _BoletasListScreenState();
}

class _BoletasListScreenState extends State<BoletasListScreen> {
  Future<List<Boleta>>? boletasFuture;

  final ApiService apiService = ApiService();
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();

    cargarBoletas();
  }

  Future<void> cargarBoletas() async {

  final boletas =
    await apiService.getBoletas();

    await verificarGarantias(boletas);

    setState(() {
      boletasFuture =
          Future.value(boletas);
    });
  }

  Future<void> verificarGarantias(
    List<Boleta> boletas,
  ) async {

    final notificacionesActivadas =
        await PreferencesService
            .obtenerNotificaciones();

    if (!notificacionesActivadas) {
      return;
    }

    final diasAviso = [14, 7, 5, 3, 1, 0];

    for (final boleta in boletas) {

      final dias =
          boleta.diasRestantesGarantia;

      if (!diasAviso.contains(dias)) {
        continue;
      }

      final yaEnviada =
          await PreferencesService
              .notificacionYaEnviada(
                boleta.idBoleta,
                dias,
              );

      if (yaEnviada) {
        continue;
      }

      String mensaje;

      if (dias == 0) {

        mensaje =
            "La garantía de ${boleta.nombreProducto} vence hoy";

      } else if (dias == 1) {

        mensaje =
            "La garantía de ${boleta.nombreProducto} vence mañana";

      } else {

        mensaje =
            "La garantía de ${boleta.nombreProducto} vence en $dias días";
      }

      await NotificationService
          .mostrarNotificacion(
            titulo: "SIGA",
            mensaje: mensaje,
          );

      await PreferencesService
          .marcarNotificacionEnviada(
            boleta.idBoleta,
            dias,
          );
    }
  }

  Future<void> mostrarDialogoEliminar(Boleta boleta) async {

    final bool tieneGarantia =
        boleta.diasRestantesGarantia > 0;

    final String mensaje = tieneGarantia
        ? "Esta boleta aún tiene garantía activa.\n\n¿Estás seguro de que deseas eliminarla?"
        : "¿Deseas eliminar esta boleta?";

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(

          title: const Text("Eliminar boleta"),

          content: Text(mensaje),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancelar"),
            ),

            ElevatedButton( 
              onPressed: () async {
                Navigator.pop(context); 
                try {
                  await apiService.deleteBoleta( boleta.idBoleta,); 
                  await cargarBoletas(); 
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Boleta eliminada"), 
                    ), 
                  ); 
                } 
                catch (e) { 
                  print(e); 
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar( 
                      content: Text("Error eliminando boleta"), 
                      ), 
                      ); 
                      }
              }, 
              child: const Text("Eliminar"), 
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis boletas")),

      body: boletasFuture == null
    ? const Center(
        child: CircularProgressIndicator(),
      )
    : FutureBuilder<List<Boleta>>(
        future: boletasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final boletas = snapshot.data!;

            if (boletas.isEmpty) {
              return const Center(
                child: Text("No hay boletas registradas"),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await cargarBoletas();
              },
              child: ListView.builder(
                itemCount: boletas.length,
                itemBuilder: (context, index) {
                  final boleta = boletas[index];

                  return BoletaCard(
                    nombre: boleta.nombreProducto,
                    fechaCompra: boleta.fechaCompra,
                    precio: boleta.precio ?? 0,
                    diasRestantes: boleta.diasRestantesGarantia,

                    onView: () { 
                      Navigator.push( 
                        context, 
                        MaterialPageRoute( 
                          builder: (_) => 
                          BoletaDetailScreen( 
                            boleta: boleta, 
                          ), 
                        ), 
                      ); 
                    },

                    onDelete: () {
                      mostrarDialogoEliminar(boleta);
                    },
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}