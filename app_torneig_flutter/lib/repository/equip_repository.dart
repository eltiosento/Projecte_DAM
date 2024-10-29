import 'dart:convert';
import 'package:app_torneig/models/api_error.dart';
import 'package:app_torneig/models/equip_dto.dart';
import 'package:app_torneig/models/equip_simple_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EquipRepository {
  static Future<List<EquipSimpleDTO>> obtenirEquipsTemporada(
      String ip, int idTemporada) async {
    String url = "http://$ip/api-torneig/equips/temporada/$idTemporada";

// Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('Inicia sessió per veure els equips.');
    }

    http.Response response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final List<dynamic> resultat = jsonDecode(body);

      List<EquipSimpleDTO> elsEquipsSimplesDTO =
          resultat.map((e) => EquipSimpleDTO.fromJSON(e)).toList();

      return elsEquipsSimplesDTO;
    } else {
      if (response.statusCode == 404) {
        Map<String, dynamic> apiErrorJSON = jsonDecode(response.body);
        throw Exception(ApiError.fromJson(apiErrorJSON).toString());
      }
      throw Exception("Error amb la connexió: ${response.statusCode}");
    }
  }

  static Future<List<EquipSimpleDTO>> obtenirAllEquips(String ip) async {
    String url = "http://$ip/api-torneig/equips";

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('Inicia sessió per veure els equips.');
    }

    http.Response response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final List<dynamic> resultat = jsonDecode(body);

      List<EquipSimpleDTO> elsEquipsSimplesDTO =
          resultat.map((e) => EquipSimpleDTO.fromJSON(e)).toList();

      return elsEquipsSimplesDTO;
    } else {
      if (response.statusCode == 404) {
        Map<String, dynamic> apiErrorJSON = jsonDecode(response.body);
        throw Exception(ApiError.fromJson(apiErrorJSON).toString());
      }
      throw Exception("Error amb la connexió: ${response.statusCode}");
    }
  }

  static Future<EquipDTO>? obtenirEquip(String ip, int idEquip) async {
    String url = "http://$ip/api-torneig/equip/$idEquip";

// Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception("Inicia sessió per veure  l'equips.");
    }

    http.Response response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final equipJSON = jsonDecode(body);

      return EquipDTO.fromJSON(equipJSON);
    } else {
      if (response.statusCode == 404) {
        Map<String, dynamic> apiErrorJSON = jsonDecode(response.body);
        throw Exception(ApiError.fromJson(apiErrorJSON).toString());
      }
      throw Exception("Error amb la connexió: ${response.statusCode}");
    }
  }

  static Future<void> crearEquip(String ip, int idTemporada, String nom,
      String curs, String imatge, List<int> idJugadors) async {
    String url = "http://$ip/api-torneig/equip/temporada/$idTemporada";

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('No tens permís per realitzar aquesta acció');
    }

    Map<String, dynamic> equipData = {
      'nom': nom,
      'curs': curs,
      'imatge': imatge,
      'esGuanyador': false,
      'idJugadors': idJugadors,
    };

    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(equipData),
    );

    if (response.statusCode == 201) {
      // El equipo se ha creado correctamente
      debugPrint("Equip creat amb èxit");
    } else {
      throw Exception("Error al crear l'equip: ${response.statusCode}");
    }
  }

  static Future<void> modificarEquip(
      String ip,
      int idEquip,
      String nom,
      String curs,
      String imatge,
      bool esGuanyador,
      List<int> idJugadors) async {
    String url = "http://$ip/api-torneig/equip/$idEquip";

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('No tens permés realitzar aquesta acció');
    }

    Map<String, dynamic> equipData = {
      'nom': nom,
      'curs': curs,
      'imatge': imatge,
      'esGuanyador': esGuanyador,
      'idJugadors': idJugadors,
    };

    http.Response response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(equipData),
    );

    if (response.statusCode == 200) {
      // El equipo se ha modificado correctamente
      debugPrint("Equip modificat amb èxit");
    } else {
      throw Exception("Error al modificar l'equip: ${response.statusCode}");
    }
  }

  static Future<void> borrarEquip(String ip, int idEquip) async {
    String url = "http://$ip/api-torneig/equip/$idEquip";

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

    if (response.statusCode == 200) {
      debugPrint("Equip eliminat amb èxit");
    } else {
      // Ho deixem per si de cas es ralla, borra l'equip i no refresca la pàgina. Així vegem si al tornar a polsar sobre el borrer que ix.
      if (response.statusCode == 404) {
        Map<String, dynamic> apiErrorJSON = jsonDecode(response.body);
        throw Exception(ApiError.fromJson(apiErrorJSON).toString());
      }
      throw Exception("Error al eliminar l'equip: ${response.statusCode}");
    }
  }
}
