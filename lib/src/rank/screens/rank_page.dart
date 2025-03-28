// ignore_for_file: unused_local_variable, deprecated_member_use

import 'dart:convert';
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/rank/widgets/filter_gender.dart';
import 'package:des/src/rank/widgets/filter_rank.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/rank_card.dart';

class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  List<dynamic> participantsList = [];
  List<dynamic> filteredParticipantsList = [];
  bool isLoading = false;
  String selectedCategory = 'SUB 10';

  @override
  void initState() {
    super.initState();
    loadParticipants();
  }

  Future<String> loadToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    debugPrint('[loadToken] Token carregado: $token');
    return token ?? '';
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

        // Filtra participantes com overall >= 1
        participants = participants.where((p) {
          final overall = (p['overall'] ?? 0).toDouble();
          return overall >= 1;
        }).toList();

        // Mantém apenas os primeiros 14 participantes
        participants = participants.take(14).toList();

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

  Future<void> loadParticipants() async {
    setState(() {
      isLoading = true;
    });

    final participants = await fetchParticipants();

    setState(() {
      if (participants != null) {
        participantsList = participants;
        filteredParticipantsList = participants;
        debugPrint(
            '[loadParticipants] Lista de participantes carregada: $participantsList');
      } else {
        debugPrint('[loadParticipants] Nenhum participante encontrado.');
      }
      isLoading = false;
    });
  }

  void filterByCategory(String category) {
    debugPrint('[filterByCategory] Categoria selecionada: $category');
    setState(() {
      selectedCategory = category;
      String normalizedCategory =
          category.trim().toUpperCase().replaceAll('-', 'z ');

      debugPrint(
          '[filterByCategory] Categoria selecionada (normalizada): $normalizedCategory');

      filteredParticipantsList = participantsList.where((participant) {
        var participantCategory = participant['category'] ?? '';
        String normalizedParticipantCategory =
            participantCategory.trim().toUpperCase().replaceAll('-', ' ');
        debugPrint(
            '[filterByCategory] Verificando categoria participante: $participantCategory');
        debugPrint(
            '[filterByCategory] Categoria participante (normalizada): $normalizedParticipantCategory');

        return normalizedParticipantCategory == normalizedCategory;
      }).toList();

      filteredParticipantsList.sort((a, b) {
        final overallA = a['overall'] ?? 0;
        final overallB = b['overall'] ?? 0;
        return overallB.compareTo(overallA);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: const Color(0XFFA6B92E),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0), // Espaçamento externo
            child: Container(
              width: 50, // Tamanho do círculo
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Deixa a borda arredondada
                border:
                    Border.all(color: Colors.white, width: 2), // Define a borda
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.exit_to_app_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => const ExitButton(),
                ),
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Colors.black,
                const Color(0xFF42472B).withOpacity(0.5),
              ],
            ),
          ),
        ),
        title: Image.asset(
          Assets.homelogo,
          width: 250,
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF121212),
      body: Stack(children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Assets.background1,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                'Ranking',
                style: principalFont.bold(color: Colors.white, fontSize: 40),
              ),
              Text(
                'Filtros',
                style: secondFont.bold(color: Color(0XFFA6B92E), fontSize: 20),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilterRank(onCategorySelected: filterByCategory),
                  const FilterGender(),
                ],
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: filteredParticipantsList.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.warning_amber_rounded,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Nenhum participante encontrado para a categoria selecionada.',
                                    textAlign:
                                        TextAlign.center, // Centraliza o texto
                                    style: principalFont.medium(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredParticipantsList.length,
                              itemBuilder: (context, index) {
                                // Ordena a lista de participantes com base no overall (maior para menor)
                                filteredParticipantsList.sort((a, b) {
                                  final overallA = a['overall'] ?? 0;
                                  final overallB = b['overall'] ?? 0;
                                  return overallB.compareTo(overallA);
                                });

                                final participant =
                                    filteredParticipantsList[index];
                                final user = participant['user'];
                                final fullName = user != null
                                    ? '${user['name']} ${user['last_name']}'
                                    : 'Nome não disponível';
                                final position = participant['position'] ??
                                    'Posição não disponível';
                                final team = participant['team']['name'] ??
                                    'Time não disponível';
                                final score = participant['overall'] ?? 0;
                                final category = participant['category'] ??
                                    'Categoria não disponível';

                                // Define a cor da borda
                                Color borderColor;
                                if (index < 2) {
                                  borderColor = const Color(
                                      0xFFB0E0E6); // Primeiros 15 colocados
                                } else {
                                  // Calcula a cor proporcional para os demais
                                  final int maxIndex =
                                      filteredParticipantsList.length - 15;
                                  final double ratio = (index - 15) / maxIndex;
                                  borderColor = Color.lerp(
                                      const Color(0xFFC52613),
                                      const Color(0xFFC52613),
                                      ratio)!;
                                }

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0, vertical: 8.0),
                                  child: RankCard(
                                    name: fullName,
                                    position: (index + 1).toString(),
                                    team: team,
                                    ranking: index + 1,
                                    score: score,
                                    category: category,
                                    borderColor: borderColor,
                                  ),
                                );
                              },
                            ),
                    ),
            ],
          ),
        ),
      ]),
    );
  }
}
