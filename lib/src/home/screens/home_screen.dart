import 'dart:developer';
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/home/services/home_services.dart';
import 'package:des/src/home/widgets/avaliation_view.dart';
import 'package:des/src/profile/screens/profile_page.dart';
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
        backgroundColor: const Color(0xFF1E1E1E),
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
        title: Text(
          'BEM VINDO ${userName?.toUpperCase() ?? ''}!',
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
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'AVALIAÇÕES',
                    style: principalFont.bold(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Mapeando os "AvaliationView" e colocando em uma lista
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
                                  evaId:
                                      '', // Deixe vazio, pois vamos coletar esses dados no clique do botão
                                ),
                                const SizedBox(height: 30),
                              ],
                            );
                          }),

                          SizedBox(
                            width: 330,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  backgroundColor: Colors.transparent,
                                  side: const BorderSide(color: Colors.white)),
                              onPressed: () {
                                List<AvaliationView> allEvaluations =
                                    judgments!.map((judgment) {
                                  return AvaliationView(
                                    evaluationName:
                                        judgment['item']['name'] ?? 'N/A',
                                    result:
                                        judgment['score']?.toString() ?? 'N/A',
                                    finalScore:
                                        judgment['score']?.toString() ?? 'N/A',
                                    itemId: judgment['item']['id'],
                                    allEvaluations: const [],
                                    evaId: '',
                                  );
                                }).toList();

                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        ProfilePage(
                                      allEvaluations: allEvaluations,
                                      evaluationName: '',
                                      result: '',
                                      finalScore: '',
                                    ),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      var fadeAnimation =
                                          Tween(begin: 0.0, end: 1.0)
                                              .animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOut,
                                      ));

                                      var slideAnimation = Tween(
                                              begin: const Offset(0.0, 0.05),
                                              end: Offset.zero)
                                          .animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOut,
                                      ));

                                      return FadeTransition(
                                        opacity: fadeAnimation,
                                        child: SlideTransition(
                                          position: slideAnimation,
                                          child: child,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                'VER PERFIL E RESULTADOS',
                                style:
                                    principalFont.medium(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
