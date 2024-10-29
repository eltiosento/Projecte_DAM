import 'dart:convert';

import 'package:app_torneig/models/api_error.dart';
import 'package:app_torneig/models/grup_dto.dart';
import 'package:app_torneig/models/grup_equip_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GrupRepository {
  static Future<List<GrupEquipDTO>> obtenirGrups(
      String ip, int idTemporada) async {
    String url = "http://$ip/api-torneig/grups/temporada/$idTemporada";

// Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('Inicia sessió per veure els grups.');
    }

    http.Response resposta = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    });

    if (resposta.statusCode == 200) {
      String body = utf8.decode(resposta.bodyBytes);

      final List<dynamic> resultat = jsonDecode(body);

      List<GrupEquipDTO> elsGrups =
          resultat.map((e) => GrupEquipDTO.fromJSON(e)).toList();
      return elsGrups;
    } else {
      if (resposta.statusCode == 404) {
        Map<String, dynamic> apiErrorJSON = jsonDecode(resposta.body);
        throw Exception(ApiError.fromJson(apiErrorJSON).toString());
      }
      throw Exception("Error amb la connexió: ${resposta.statusCode}");
    }
  }

  static Future<GrupDTO> obtenirGrup(String ip, int idGrup) async {
    String url = "http://$ip/api-torneig/grup/$idGrup";
    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('Inicia sessió per veure els grups.');
    }

    http.Response resposta = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    });

    if (resposta.statusCode == 200) {
      String body = utf8.decode(resposta.bodyBytes);

      final grupJSON = jsonDecode(body);

      return GrupDTO.fromJSON(grupJSON);
    } else {
      if (resposta.statusCode == 404) {
        Map<String, dynamic> apiErrorJSON = jsonDecode(resposta.body);
        throw Exception(ApiError.fromJson(apiErrorJSON).toString());
      }
      throw Exception("Error amb la connexió: ${resposta.statusCode}");
    }
  }

  static Future<void> crearSorteigFaseGrups(String ip, int idTemporada) async {
    String url = "http://$ip/api-torneig/sorteigFaseGrups/$idTemporada";

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('Inicia sessió per veure els grups.');
    }

    // Realizar la petición POST
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      debugPrint('Sorteig Fase Grups creat correctament');
    } else {
      if (response.statusCode == 404 || response.statusCode == 400) {
        Map<String, dynamic> apiErrorJSON = jsonDecode(response.body);
        throw Exception(ApiError.fromJson(apiErrorJSON).toString());
      }
      throw Exception("Error amb la connexió: ${response.statusCode}");
    }
  }

  static Future<void> borrarSorteigFaseGrups(String ip, int idTemporada) async {
    String url =
        'http://$ip/api-torneig/borrar-Sorteig-FaseGrups/temporada/$idTemporada';

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('Inicia sessió per veure els grups.');
    }

    http.Response response = await http.delete(
      Uri.parse(url),
      headers: {
        //'Authorization': 'Bearer your_token_here',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Petición exitosa
      debugPrint('Sorteig Fase Grups borrat correctament');
    } else {
      // Error en la petición
      debugPrint('Error al borrar Sorteig Fase Grups: ${response.statusCode}');
    }
  }
}
