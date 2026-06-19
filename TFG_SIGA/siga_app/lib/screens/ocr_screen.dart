import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class OCRScreen extends StatefulWidget {
  const OCRScreen({super.key});

  @override
  State<OCRScreen> createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final ApiService apiService = ApiService();
  final AuthService authService = AuthService();
  bool isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear Boleta')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Tomar Foto'),
            ),

            const SizedBox(height: 20),

            if (_image != null)
              Center(
                child: SizedBox(
                  width: 300,
                  child: Image.file(
                    _image!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

            if (_image != null)
              const SizedBox(height: 20),

            if (_image != null)
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() => isLoading = true);

                        await apiService.enviarImagenOCR(
                          _image!,
                        );

                        setState(() => isLoading = false);
                      },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Guardar boleta"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}