// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/home/services/home_services.dart';
import 'package:des/src/home/widgets/avaliation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        toolbarHeight: 65,
        backgroundColor: const Color(0XFFA6B92E),
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
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
      body: isLoading
          ? Stack(children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.background),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ])
          : Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.background),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60),
                        Stack(children: [
                          Center(
                            child: CustomPaint(
                              size: Size(350, 50),
                              painter: TitleVetor('AVALIAÇÕES'),
                            ),
                          ),
                        ]),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
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
                                            evaluationName: judgment['item']
                                                    ['name'] ??
                                                'N/A',
                                            result:
                                                judgment['score']?.toString() ??
                                                    'N/A',
                                            finalScore:
                                                judgment['score']?.toString() ??
                                                    'N/A',
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
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class TitleVetor extends CustomPainter {
  final String text;
  TitleVetor(this.text);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0XFFA6B92E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path()
      ..moveTo(30, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - 30, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);

    final textPainter = TextPainter(
      text: TextSpan(
          text: text,
          style: secondFont.bold(color: Colors.white, fontSize: 25)),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
