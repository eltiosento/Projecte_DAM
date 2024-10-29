import 'dart:convert';
import 'package:app_torneig/models/api_error.dart';
import 'package:app_torneig/models/jugador_dto.dart';
import 'package:app_torneig/models/jugador_simple_dto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JugadorRepository {
  static Future<JugadorDTO> obtenirJugador(String ip, int idJugador) async {
    String url = "http://$ip/api-torneig/jugador/$idJugador";

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('Inicia sessió per veure el/la jugador/a.');
    }

    http.Response response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final jugadorJSON = jsonDecode(body);

      return JugadorDTO.fromJSON(jugadorJSON);
    } else {
      if (response.statusCode == 404) {
        Map<String, dynamic> apiErrorJSON = jsonDecode(response.body);
        throw Exception(ApiError.fromJson(apiErrorJSON).toString());
      }
      throw Exception("Error amb la connexió: ${response.statusCode}");
    }
  }

  static Future<List<JugadorSimpleDTO>> obtenirAllJugadors(String ip) async {
    String url = "http://$ip/api-torneig/jugadors";

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('Inicia sessió per veure els/les jugadors/es.');
    }

    http.Response response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final List<dynamic> resultat = jsonDecode(body);
      List<JugadorSimpleDTO> elsJugadorsDTO =
          resultat.map((e) => JugadorSimpleDTO.fromJSON(e)).toList();

      return elsJugadorsDTO;
    } else {
      if (response.statusCode == 404) {
        Map<String, dynamic> apiErrorJSON = jsonDecode(response.body);
        throw Exception(ApiError.fromJson(apiErrorJSON).toString());
      }
      throw Exception("Error amb la connexió: ${response.statusCode}");
    }
  }

  static Future<List<JugadorSimpleDTO>> obtenirJugadorsMenorsCatorzeAnys(
      String ip) async {
    String url = "http://$ip/api-torneig/jugadors/delCentre";

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('Inicia sessió per veure els/les jugadors/es.');
    }

    http.Response response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final List<dynamic> resultat = jsonDecode(body);
      List<JugadorSimpleDTO> elsJugadorsDTO =
          resultat.map((e) => JugadorSimpleDTO.fromJSON(e)).toList();

      return elsJugadorsDTO;
    } else {
      if (response.statusCode == 404) {
        Map<String, dynamic> apiErrorJSON = jsonDecode(response.body);
        throw Exception(ApiError.fromJson(apiErrorJSON).toString());
      }
      throw Exception("Error amb la connexió: ${response.statusCode}");
    }
  }

  static Future<void> crearNouJugador(String ip, String nom, int edat) async {
    String url = "http://$ip/api-torneig/jugador";

// Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('No tens permés realitzar aquesta acció');
    }

    Map<String, dynamic> data = {
      "nom": nom,
      "edat": edat,
      "sancionat": false,
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
      throw Exception(
          "Error al crear al nou/nova jugador/a: ${response.statusCode}");
    }
  }

  static Future<void> updateJugador(
      String ip, int idJugador, String nom, int edat, bool esSancionat) async {
    String url = "http://$ip/api-torneig/jugador/$idJugador";

    // Recuperar el token JWT de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Verificar si el token es null
    if (token == null) {
      throw Exception('No tens permés realitzar aquesta acció');
    }

    Map<String, dynamic> data = {
      "nom": nom,
      "edat": edat,
      "sancionat": esSancionat,
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
          "Error al actualizar el jugador/a: ${response.statusCode}");
    }
  }

  static Future<void> borrarJugador(String ip, int idJugador) async {
    String url = 'http://$ip/api-torneig/jugador/$idJugador';

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
      throw Exception(
          "Error al borrar el/la jugador/a: ${response.statusCode}");
    }
  }
}
