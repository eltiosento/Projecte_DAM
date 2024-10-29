import 'dart:convert';

import 'package:app_torneig/models/api_error.dart';
import 'package:app_torneig/models/grup_partit_dto.dart';
import 'package:app_torneig/models/partit_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PartitRepository {
  static Future<List<GrupPartitDTO>> obtenirPartitsPerGrup(
      String ip, int idTemporada) async {
    String url = "http://$ip/api-torneig/partits/temporada/$idTemporada/grups";

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('Inicia sessió per veure els partits.');
    }

    http.Response response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final List<dynamic> resultat = jsonDecode(body);

      List<GrupPartitDTO> elsGrupsPartitsDTO =
          resultat.map((e) => GrupPartitDTO.fromJSON(e)).toList();

      return elsGrupsPartitsDTO;
    } else {
      if (response.statusCode == 404) {
        Map<String, dynamic> apiErrorJSON = jsonDecode(response.body);
        throw Exception(ApiError.fromJson(apiErrorJSON).toString());
      }
      throw Exception("Error amb la connexió: ${response.statusCode}");
    }
  }

  static Future<List<PartitDTO>> obtenirPartitsPerFase(
      String ip, int idTemporada, int idFase) async {
    String url =
        "http://$ip/api-torneig/partits/temporada/$idTemporada/fase/$idFase";

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('Inicia sessió per veure els partits.');
    }

    http.Response response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final List<dynamic> resultat = jsonDecode(body);

      List<PartitDTO> elsPartitsDTO =
          resultat.map((e) => PartitDTO.fromJSON(e)).toList();

      return elsPartitsDTO;
    } else {
      if (response.statusCode == 404) {
        Map<String, dynamic> apiErrorJSON = jsonDecode(response.body);
        throw Exception(ApiError.fromJson(apiErrorJSON).toString());
      }
      throw Exception("Error amb la connexió: ${response.statusCode}");
    }
  }

  static Future<void> updatePartit(String ip, int idPartit, String dataPartit,
      int resultatLocal, int resultatVisitant, bool partitJugat) async {
    String url = "http://$ip/api-torneig/partit/$idPartit";

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('Inicia sessió per veure els partits.');
    }

    Map<String, dynamic> partitData = {
      "idPartit": idPartit,
      "dataPartit": dataPartit,
      "resultatLocal": resultatLocal,
      "resultatVisitant": resultatVisitant,
      "partitJugat": partitJugat
    };

    String body = jsonEncode(partitData);

    http.Response response = await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception("Error al actualizar el partit: ${response.statusCode}");
    }
  }

  static Future<void> crearPartitsFaseGrups(String ip, int idTemporada) async {
    String url = "http://$ip/api-torneig/sorteigPartitsGrups/$idTemporada";

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('Inicia sessió per veure els partits.');
    }

    // Realizar la petición POST
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      }, // Agrega headers si es necesario
    );

    if (response.statusCode == 200) {
    } else {
      if (response.statusCode == 404) {
        Map<String, dynamic> apiErrorJSON = jsonDecode(response.body);
        throw Exception(ApiError.fromJson(apiErrorJSON).toString());
      }
      throw Exception("Error al realizar el sorteig: ${response.statusCode}");
    }
  }

  static Future<void> crearPartitsOctaus(String ip, int idTemporada) async {
    String url = "http://$ip/api-torneig/sorteigOctaus/$idTemporada";

// Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('Inicia sessió per veure els partits.');
    }
    // Realizar la petición POST
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      }, // Agrega headers si es necesario
    );

    if (response.statusCode == 200) {
    } else {
      if (response.statusCode == 404) {
        Map<String, dynamic> apiErrorJSON = jsonDecode(response.body);
        throw Exception(ApiError.fromJson(apiErrorJSON).toString());
      }
      throw Exception("Error al crear els partits: ${response.statusCode}");
    }
  }

  static Future<void> crearPartitsDirecteQuarts(
      String ip, int idTemporada) async {
    String url = "http://$ip/api-torneig/sorteigQuarts/$idTemporada";

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('Inicia sessió per veure els partits.');
    }

    // Realizar la petición POST
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      }, // Agrega headers si es necesario
    );

    if (response.statusCode == 200) {
    } else {
      if (response.statusCode == 404) {
        Map<String, dynamic> apiErrorJSON = jsonDecode(response.body);
        throw Exception(ApiError.fromJson(apiErrorJSON).toString());
      }
      throw Exception("Error al crear els partits: ${response.statusCode}");
    }
  }

  static Future<void> crearPartitsEliminatoris(
      String ip, int idTemporada, int idFase) async {
    String url =
        "http://$ip/api-torneig/sorteigEliminacions/$idTemporada/fase/$idFase";

// Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('Inicia sessió per veure els partits.');
    }

    // Realizar la petición POST
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      }, // Agrega headers si es necesario
    );

    if (response.statusCode == 200) {
    } else {
      if (response.statusCode == 400) {
        Map<String, dynamic> apiErrorJSON = jsonDecode(response.body);
        throw Exception(ApiError.fromJson(apiErrorJSON).toString());
      }
      throw Exception("Error al crear els partits: ${response.statusCode}");
    }
  }

  static Future<void> borrarPartitsPerFase(
      String ip, int idTemporada, int idFase) async {
    String url =
        'http://$ip/api-torneig/partits/temporada/$idTemporada/fase/$idFase';

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('Inicia sessió per veure els partits.');
    }

    http.Response response = await http.delete(
      Uri.parse(url),
      headers: {
        //'Authorization': 'Bearer your_token_here',
        'Content-Type': 'application/json', 'Authorization': 'Bearer $token',
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
