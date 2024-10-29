import 'package:app_torneig/models/api_error.dart';
import 'package:app_torneig/models/temporada_dto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TemporadaRepository {
  static Future<List<TemporadaDTO>> getTemporades(String ip) async {
    String url = "http://$ip/api-torneig/temporades";

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('Inicia sessió per veure les temporades.');
    }

    http.Response response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final List<dynamic> resultat = jsonDecode(body);

      List<TemporadaDTO> lesTemporades =
          resultat.map((e) => TemporadaDTO.fromJSON(e)).toList();

      return lesTemporades;
    } else {
      if (response.statusCode == 404) {
        Map<String, dynamic> apiErrorJSON = jsonDecode(response.body);
        throw Exception(ApiError.fromJson(apiErrorJSON).toString());
      }
      throw Exception(
          "Error amb la connexió: ${response.statusCode}, prova a iniciar sessió");
    }
  }

  static Future<void> crearNovaTemporada(String ip, String nom) async {
    String url = "http://$ip/api-torneig/temporada";

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('No tens permés realitzar aquesta acció.');
    }

    Map<String, dynamic> data = {
      "nom": nom,
    };

    String body = jsonEncode(data);

    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode != 201) {
      throw Exception("Error al afegir la temporada: ${response.statusCode}");
    }
  }

  static Future<void> updateTemporada(String ip, int id, String nom) async {
    String url = "http://$ip/api-torneig/temporada/$id";

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('No tens permés realitzar aquesta acció.');
    }

    Map<String, dynamic> data = {
      "nom": nom,
    };

    String body = jsonEncode(data);

    http.Response response = await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception(
          "Error al actualizar la temporada: ${response.statusCode}");
    }
  }

  static Future<void> borrarTemporada(String ip, int idTemporada) async {
    String url = 'http://$ip/api-torneig/temporada/$idTemporada';

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('No tens permés realitzar aquesta acció');
    }

    http.Response response = await http.delete(
      Uri.parse(url),
      headers: {
        //'Authorization': 'Bearer your_token_here',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Error al borrar la temporada: ${response.statusCode}");
    }
  }
}
