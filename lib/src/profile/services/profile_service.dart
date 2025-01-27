import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
      log("Response body: ${response.body}");

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

  // Buscar o score do julgamento baseado no evaluationId
  Future<String?> fetchScore(String token, int evaluationId) async {
    final url = Uri.parse(
      'https://api.des.versatecnologia.com.br/api/evaluations/$evaluationId',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      log('[fetchScore] Response status: ${response.statusCode}');
      log('[fetchScore] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log('[fetchScore] Dados retornados do julgamento: $data');
        if (data['judgments'] != null && data['judgments'].isNotEmpty) {
          final score = data['judgments'][0]['score'];
          log('[fetchScore] Score encontrado: $score');
          return score;
        } else {
          log('[fetchScore] Nenhuma avaliação encontrada no campo judgments.');
        }
      } else {
        log('[fetchScore] Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      log('[fetchScore] Erro ao buscar score: $e');
    }

    log('[fetchScore] Retornando null para o score.');
    return null;
  }

  // Buscar todos os julgamentos
  Future<Map<String, dynamic>?> fetchParticipantScores(
      String token, String participantId) async {
    try {
      log("Fetching participant scores for participant ID: $participantId");

      var url = Uri.parse(
          'https://api.des.versatecnologia.com.br/api/participant/$participantId/scores');
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

        // Retorna os scores do participante
        return data['scores']; // Supondo que o JSON tenha a chave 'scores'
      } else {
        log("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      log('Error fetching participant scores: $e');
    }
    return null;
  }
}
