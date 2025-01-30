import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

  final String baseUrl = 'https://api.des.versatecnologia.com.br/api/participants';

  Future<List<Participant>> fetchParticipants(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl?page=1&perPage=10&groupBySub=1'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> participantsJson = json.decode(response.body);
      // Filtra participantes com 'overall' não nulo
      return participantsJson
          .map((json) => Participant.fromJson(json))
          .where((participant) => participant.overall != null)
          .toList();
    } else {
      throw Exception('Erro ao carregar participantes');
    }
  }

class Participant {
  final String name;
  final String position;
  final String category;
  final int? overall;
  final String photo;

  Participant({
    required this.name,
    required this.position,
    required this.category,
    this.overall,
    required this.photo,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      name: json['user']['name'],
      position: json['position'],
      category: json['category'],
      overall: json['overall'],
      photo: json['user']['photo'] ?? '',
    );
  }
