import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
  padding: const EdgeInsets.all(20),

  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [

      const SizedBox(height: 60),

      const Center(
        child: Text(
          "SIGA",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      const Spacer(),

      SizedBox(
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/boletas',
                );
              },

              icon: const Icon(
                Icons.receipt_long,
              ),

              label: const Text(
                'Ver Boletas',
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/ocr',
                );
              },

              icon: const Icon(
                Icons.camera_alt,
              ),

              label: const Text(
                'Escanear Boleta',
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/perfil',
                );
              },

              icon: const Icon(
                Icons.person,
              ),

              label: const Text(
                'Perfil',
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 80),
    ],
  ),
),
    );
  }
}