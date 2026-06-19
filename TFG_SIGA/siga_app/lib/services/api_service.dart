import 'dart:convert';
import 'dart:io';
import '../models/boleta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String serverUrl = "http://192.168.1.134:8080";

  static const String baseUrl = "$serverUrl/api";


  Future<List<Boleta>> getBoletas() async {
    final response = await http.get(Uri.parse('$baseUrl/boletas'), 
    headers: await getHeaders());

    if (response.statusCode == 200) {

      final List data = jsonDecode(response.body);

      return data.map((e) => Boleta.fromJson(e)).toList();
    }

    throw Exception('Error al cargar boletas');
  }
    

  Future<void> enviarImagenOCR(
      File imagen,
  ) async {

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/ocr'),
    );

    request.headers.addAll(
      await getHeaders(),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imagen.path,
      ),
    );

    var response = await request.send();

    if (response.statusCode == 200) {

      print("Imagen enviada correctamente");

    } else {

      print(
        "Error al enviar imagen: ${response.statusCode}",
      );
    }
  }

  Future<void> deleteBoleta(int boletaId,) async {

    final url =
        '$baseUrl/boletas/$boletaId';

    final response = await http.delete(

      Uri.parse(url),

      headers: await getHeaders(),
    );

    if (response.statusCode != 204) {

      throw Exception(
        "Error al eliminar boleta: ${response.statusCode}",
      );
    }
  }

  Future<void> deleteUsuario(String password) async {

    final response = await http.delete(
      Uri.parse(
        '$baseUrl/users?password=$password', ), 
        headers: await getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception("Error eliminando usuario");
    }
  }

  Future<Map<String, String>> getHeaders() async {

  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString('token');

  return {
    'Authorization': 'Bearer $token',
  };
}
}