import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeServices {
  Future<String> loadToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    return token ?? '';
  }

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
        log('[fetchEvaluationId] Dados recebidos: $data');

        if (data['evaluations'] != null && data['evaluations'].isNotEmpty) {
          final evaluationId = data['evaluations'][0]['id'];
          log('[fetchEvaluationId] evaluation_id encontrado: $evaluationId');
          return evaluationId;
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
    return null;
  }

  Future<String?> fetchScore(String token, int evaluationId) async {
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

  Future<List<dynamic>?> fetchParticipants() async {
    final token = await loadToken();

    if (token.isEmpty) {
      debugPrint('[fetchParticipants] Token vazio ou inválido.');
      return null;
    }

    try {
      const apiUrl =
          'https://api.des.versatecnologia.com.br/api/participants?page=1&perPage=100&groupBySub=1';
      var url = Uri.parse(apiUrl);

      debugPrint('[fetchParticipants] Fazendo requisição para: $apiUrl');
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('[fetchParticipants] Response status: ${response.statusCode}');
      debugPrint('[fetchParticipants] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        debugPrint('[fetchParticipants] Dados decodificados: $decodedData');

        List<dynamic> participants = [];
        decodedData.forEach((key, value) {
          if (value is List) {
            participants.addAll(value);
          }
        });
        for (var participant in participants) {
          var category = participant['category'] ?? 'Categoria não disponível';
          debugPrint(
              '[fetchParticipants] Categoria do participante: $category');
        }

        return participants;
      } else {
        debugPrint(
            '[fetchParticipants] Erro na requisição: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('[fetchParticipants] Erro ao buscar participantes: $error');
    }

    return null;
  }
}
