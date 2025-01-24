import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeServices {
  // Método para carregar o token
  Future<String> loadToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    return token ?? '';
  }

  // Método para buscar informações básicas do usuário
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
        return data as Map<String, dynamic>;
      }
    } catch (e) {
      log('[userInfo] Erro ao buscar informações do usuário: $e');
    }
    return null;
  }

  // Método para buscar evaluation_id com base no participantId
  Future<int?> fetchEvaluationId(String token, int participantId) async {
    final url = Uri.parse(
        'https://api.des.versatecnologia.com.br/api/participants/$participantId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log('[fetchEvaluationId] Dados recebidos: $data'); // Loga o JSON recebido

        if (data['evaluations'] != null && data['evaluations'].isNotEmpty) {
          final evaluationId = data['evaluations'][0]['id'];
          log('[fetchEvaluationId] evaluation_id encontrado: $evaluationId'); // Loga o evaluation_id encontrado
          return evaluationId; // Retorna o primeiro evaluation_id
        } else {
          log('[fetchEvaluationId] Nenhuma avaliação encontrada para o participantId: $participantId');
        }
      } else {
        log('[fetchEvaluationId] Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      log('[fetchEvaluationId] Erro ao buscar evaluation_id: $e');
    }

    log('[fetchEvaluationId] Retornando null para o evaluation_id.');
    return null; // Retorna null caso não encontre ou ocorra erro
  }

  // Método para buscar o score com base no evaluation_id
  Future<String?> fetchScore(String token, int evaluationId) async {
    // A URL agora usa o evaluation_id para fazer a requisição
    final url = Uri.parse(
        'https://api.des.versatecnologia.com.br/api/evaluations/$evaluationId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Log da resposta completa da API
      log('[fetchScore] Response status: ${response.statusCode}');
      log('[fetchScore] Response body: ${response.body}');

      // Verifica se a resposta está ok
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log('[fetchScore] Dados retornados do julgamento: $data'); // Loga os dados do julgamento

        // Verifica se o campo 'judgments' existe e possui dados
        if (data['judgments'] != null && data['judgments'].isNotEmpty) {
          final score = data['judgments'][0]['score'];
          log('[fetchScore] Score encontrado: $score'); // Loga o score encontrado
          return score; // Retorna o score
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
    return null; // Retorna null caso não encontre ou ocorra erro
  }

  // Novo método para buscar todos os julgamentos (judgments)
  Future<List<Map<String, dynamic>>> fetchJudgments(
      String token, int evaluationId) async {
    final url = Uri.parse(
        'https://api.des.versatecnologia.com.br/api/evaluations/$evaluationId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      log('[fetchJudgments] Response status: ${response.statusCode}');
      log('[fetchJudgments] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log('[fetchJudgments] Dados dos julgamentos: $data');
        if (data['judgments'] != null && data['judgments'].isNotEmpty) {
          return List<Map<String, dynamic>>.from(data['judgments']);
        } else {
          log('[fetchJudgments] Nenhum julgamento encontrado.');
        }
      } else {
        log('[fetchJudgments] Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      log('[fetchJudgments] Erro ao buscar julgamentos: $e');
    }

    return [];
  }
}
