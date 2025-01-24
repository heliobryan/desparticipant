import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  // Método para carregar o token
  Future<String> loadToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    return token ?? '';
  }

  // Buscar informações básicas do usuário (name, id, etc.)
  Future<Map<String, dynamic>?> userInfo(String token) async {
    try {
      var url = Uri.parse('https://api.des.versatecnologia.com.br/api/user');
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      log("Response status: ${response.statusCode}");
      log("Response body: ${fetchParticipantDetails(token)}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Retornar as informações do usuário logado
        return data as Map<String, dynamic>;
      }
    } catch (e) {
      log('Error fetching user info: $e');
    }
    return null;
  }

  // Buscar detalhes do participante com base no token
  Future<Map<String, dynamic>?> fetchParticipantDetails(String token) async {
    try {
      log("Fetching participant details for logged user");

      var url = Uri.parse('https://api.des.versatecnologia.com.br/api/user');
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      log("Response status: ${response.statusCode}");
      log("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Retornar as informações do participante diretamente
        final participant = data['participant'];

        if (participant != null) {
          log("Participant data: ${jsonEncode(participant)}");
          return participant as Map<String, dynamic>;
        } else {
          log("No participant data found");
        }
      } else if (response.statusCode == 403) {
        log("Authorization error: Verify token or permissions.");
      } else {
        log("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      log('Error fetching participant details: $e');
    }
    return null;
  }
}
