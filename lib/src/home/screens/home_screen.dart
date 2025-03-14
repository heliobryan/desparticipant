import 'dart:developer';
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/home/services/home_services.dart';
import 'package:des/src/home/widgets/avaliation_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlternateHome extends StatefulWidget {
  const AlternateHome(
      {super.key,
      String? userName,
      String? userId,
      String? participantId,
      List? judgments});

  @override
  State<AlternateHome> createState() => _AlternateHomeState();
}

class _AlternateHomeState extends State<AlternateHome> {
  final homeService = HomeServices();

  String? userId;
  String? userName;
  String? participantId;
  List<dynamic>? judgments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    try {
      log("[loadUser] Iniciando carregamento do usuário...");
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      userName = sharedPreferences.getString('userName');
      userId = sharedPreferences.getString('userId');
      participantId = sharedPreferences.getString('participantId');

      if (userName != null && userId != null && participantId != null) {
        log("[loadUser] Dados do usuário encontrados no SharedPreferences.");

        final loadtoken = await homeService.loadToken();
        final evalId = await homeService.fetchEvaluationId(
            loadtoken, int.parse(participantId!));

        log("[loadUser] evaluation_id retornado: $evalId");

        if (evalId != null) {
          final fetchedJudgments =
              await homeService.fetchJudgments(loadtoken, evalId);

          log("[loadUser] Julgamentos retornados: $fetchedJudgments");

          setState(() {
            judgments = fetchedJudgments;
            isLoading = false;
          });
        }
      } else {
        log("[loadUser] Informações não encontradas no SharedPreferences. Buscando na API...");
        final loadtoken = await homeService.loadToken();
        final data = await homeService.userInfo(loadtoken);

        log("[loadUser] Dados do usuário carregados da API: $data");

        setState(() {
          userName = data?['name'] ?? 'N/A';
          userId = data?['id']?.toString() ?? 'N/A';
          participantId = data?['participant']?['id']?.toString() ?? 'N/A';
        });

        sharedPreferences.setString('userName', userName ?? '');
        sharedPreferences.setString('userId', userId ?? '');
        sharedPreferences.setString('participantId', participantId ?? '');

        final evalId = await homeService.fetchEvaluationId(
            loadtoken, int.parse(participantId!));

        log("[loadUser] evaluation_id retornado após requisição: $evalId");

        if (evalId != null) {
          final fetchedJudgments =
              await homeService.fetchJudgments(loadtoken, evalId);

          log("[loadUser] Julgamentos retornados: $fetchedJudgments");

          setState(() {
            judgments = fetchedJudgments;
            isLoading = false;
          });
        }
      }

      log("[loadUser] Finalizado carregamento de informações.");
    } catch (e) {
      log("[loadUser] Erro ao carregar o usuário: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFFb0c32e),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => const ExitButton(),
            ),
          ),
        ],
        centerTitle: true,
        title: Text(
          'AVALIAÇÕES',
          style: principalFont.bold(color: Colors.white, fontSize: 25),
        ),
      ),
      backgroundColor: const Color(0xFF121212),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          ...judgments!.map((judgment) {
                            return Column(
                              children: [
                                AvaliationView(
                                  evaluationName:
                                      judgment['item']['name'] ?? 'N/A',
                                  result:
                                      judgment['score']?.toString() ?? 'N/A',
                                  finalScore:
                                      judgment['score']?.toString() ?? 'N/A',
                                  itemId: judgment['item']['id'],
                                  allEvaluations: const [],
                                  evaId: '',
                                  measurement: judgment['item']
                                          ['measurement_unit'] ??
                                      '',
                                ),
                                const SizedBox(height: 30),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
