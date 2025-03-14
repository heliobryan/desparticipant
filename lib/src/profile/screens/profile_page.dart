// ignore_for_file: use_build_context_synchronously, unused_field, unused_local_variable

import 'dart:developer';
import 'dart:io';
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/home/widgets/avaliation_view.dart';
import 'package:des/src/profile/cards/card.dart';
import 'package:des/src/profile/datauser/data_user.dart';
import 'package:des/src/profile/graph/graph.dart';
import 'package:des/src/profile/services/profile_service.dart';
import 'package:des/src/profile/widgets/data_card.dart';
import 'package:des/src/profile/widgets/avaliation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String evaluationName;
  final String result;
  final String finalScore;

  final List<AvaliationView> allEvaluations;

  const ProfilePage({
    super.key,
    required this.evaluationName,
    required this.result,
    required this.finalScore,
    required this.allEvaluations,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final homeService = ProfileService();
  String? userName;
  String? userId;
  String? category;
  String? position;
  String? name;
  bool isLoading = true;
  List<dynamic>? judgments = [];
  bool _isLoading = false;

  bool _isDatacard = false;
  late final AnimationController _controller;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
        _saveImageToSharedPreferences(_image!.path);
      }
    });
  }

  Future<void> _saveImageToSharedPreferences(String imagePath) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('userImagePath', imagePath);

      log("Caminho da imagem salvo em SharedPreferences: $imagePath");
    } catch (e) {
      log("Erro ao salvar o caminho da imagem no SharedPreferences: $e");
    }
  }

  Future<void> loadImageFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedImagePath = prefs.getString('userImagePath');

    if (savedImagePath != null) {
      setState(() {
        _image = XFile(savedImagePath);
      });
    } else {
      log("Nenhuma imagem salva encontrada.");
    }
  }

  @override
  void initState() {
    super.initState();
    log("Inicializando ProfilePage...");
    loadUserData();
    loadImageFromSharedPreferences();
    loadJudgments();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  void loadJudgments() async {
    try {
      log("[loadJudgments] Iniciando carregamento dos julgamentos...");
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      String? token = sharedPreferences.getString('token');
      String? evaluationId = sharedPreferences.getString('evaluationId');
      String? participantId = sharedPreferences.getString('participantId');

      log("[loadJudgments] Dados carregados do SharedPreferences:");
      log(" - token: $token");
      log(" - evaluationId: $evaluationId");
      log(" - participantId: $participantId");

      if (token != null && evaluationId != null) {
        log("[loadJudgments] Token e Evaluation ID encontrados. Buscando julgamentos...");

        final fetchedJudgments =
            await homeService.fetchJudgments(token, int.parse(evaluationId));

        log("[loadJudgments] Julgamentos retornados: $fetchedJudgments");

        setState(() {
          judgments = fetchedJudgments;
          isLoading = false;
        });
      } else {
        log("[loadJudgments] Token ou Evaluation ID não encontrados. Buscando na API...");

        final loadToken = await homeService.loadToken();
        log("[loadJudgments] Novo token carregado da API: $loadToken");

        if (participantId == null) {
          log("[loadJudgments] participantId não encontrado. Buscando na API...");
          final userData = await homeService.userInfo(loadToken);
          participantId = userData?['participant']?['id']?.toString();

          log("[loadJudgments] Dados retornados de userInfo: $userData");
          log("[loadJudgments] participantId obtido: $participantId");

          if (participantId != null) {
            sharedPreferences.setString('participantId', participantId);
          } else {
            log("[loadJudgments] Falha ao obter participantId.");
            setState(() => isLoading = false);
            return;
          }
        }

        final fetchedEvaluationId = await homeService.fetchEvaluationId(
            loadToken, int.parse(participantId));

        log("[loadJudgments] Evaluation ID obtido: $fetchedEvaluationId");

        if (fetchedEvaluationId != null) {
          sharedPreferences.setString('token', loadToken);
          sharedPreferences.setString(
              'evaluationId', fetchedEvaluationId.toString());

          final fetchedJudgments =
              await homeService.fetchJudgments(loadToken, fetchedEvaluationId);

          log("[loadJudgments] Julgamentos retornados após requisição: $fetchedJudgments");

          setState(() {
            judgments = fetchedJudgments;
            isLoading = false;
          });
        } else {
          log("[loadJudgments] Falha ao obter evaluation_id.");
          setState(() => isLoading = false);
        }
      }

      log("[loadJudgments] Finalizado carregamento de informações.");
    } catch (e) {
      log("[loadJudgments] Erro ao carregar os julgamentos: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> loadUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    userName = sharedPreferences.getString('userName');
    userId = sharedPreferences.getString('userId');
    category = sharedPreferences.getString('category');
    position = sharedPreferences.getString('position');

    if (userName != null &&
        userId != null &&
        category != null &&
        position != null) {
      debugPrint("Dados encontrados no SharedPreferences.");
      setState(() {});
    } else {
      debugPrint(
          "Dados não encontrados no SharedPreferences, buscando na API...");
      String token = await homeService.loadToken();
      final responseData = await homeService.fetchParticipantDetails(token);

      if (responseData != null) {
        debugPrint("Dados recebidos no loadUserData: $responseData");

        final participant = responseData;
        final user = participant['user'] ?? {};

        setState(() {
          userName = user['name'] ?? 'Sem Nome';
          userId = user['id'] != null ? user['id'].toString() : 'Sem ID';
          category = participant['category'] ?? 'Sem Categoria';
          position = participant['position'] ?? 'Sem Posição';
        });

        await sharedPreferences.setString('userName', userName ?? '');
        await sharedPreferences.setString('userId', userId ?? '');
        await sharedPreferences.setString('category', category ?? '');
        await sharedPreferences.setString('position', position ?? '');
      } else {
        debugPrint("Falha ao obter os dados do participante.");
      }
    }
  }

  Future<void> toggleRadarGraph() async {
    final item61 = widget.allEvaluations.firstWhere(
      (evaluation) => evaluation.itemId == 61,
      orElse: () => const AvaliationView(
        itemId: 61,
        evaluationName: 'Sprint',
        result: '',
        finalScore: '',
        allEvaluations: [],
        evaId: '',
        measurement: '',
      ),
    );
    final item17 = widget.allEvaluations.firstWhere(
      (evaluation) => evaluation.itemId == 17,
      orElse: () => const AvaliationView(
        itemId: 17,
        evaluationName: 'Altura',
        result: '',
        finalScore: '',
        allEvaluations: [],
        evaId: '',
        measurement: '',
      ),
    );

    final item55 = widget.allEvaluations.firstWhere(
      (evaluation) => evaluation.itemId == 55,
      orElse: () => const AvaliationView(
        itemId: 55,
        evaluationName: 'Finalização',
        result: '',
        finalScore: '',
        allEvaluations: [],
        evaId: '',
        measurement: '',
      ),
    );
    final item54 = widget.allEvaluations.firstWhere(
      (evaluation) => evaluation.itemId == 54,
      orElse: () => const AvaliationView(
        itemId: 54,
        evaluationName: 'Passe',
        result: '',
        finalScore: '',
        allEvaluations: [],
        evaId: '',
        measurement: '',
      ),
    );

    final passValue = item54.result;
    final finalValue = item55.result;
    final alturaValue = item17.result;
    final agiValeu = item61.result;

    String calculatedAgi =
        calculateFinalScore(61, double.tryParse(agiValeu) ?? 0);
    String calculatedFis =
        calculateFinalScore(16, double.tryParse(alturaValue) ?? 0);
    String calculatedFin =
        calculateFinalScore(55, double.tryParse(finalValue) ?? 0);
    String calculatedPas =
        calculateFinalScore(54, double.tryParse(passValue) ?? 0);
    String calculatedRit = calculateFinalScore(41, 75);
    String calculatedDri = calculateFinalScore(59, 60);

    if (calculatedRit == '0.0') calculatedRit = '60';
    if (calculatedDri == '0.0') calculatedDri = '60';

    double agi = double.tryParse(calculatedAgi) ?? 0;
    double fis = double.tryParse(calculatedFis) ?? 0;
    double rit = double.tryParse(calculatedRit) ?? 0;
    double fin = double.tryParse(calculatedFin) ?? 0;
    double pas = double.tryParse(calculatedPas) ?? 0;
    double dri = double.tryParse(calculatedDri) ?? 0;

    debugPrint('calculatedAgi: $calculatedAgi');
    debugPrint('calculatedFis: $calculatedFis');
    debugPrint('calculatedRit: $calculatedRit');
    debugPrint('calculatedFin: $calculatedFin');
    debugPrint('calculatedPas: $calculatedPas');
    debugPrint('calculatedDri: $calculatedDri');

    debugPrint(
        'Verificando valores para radar: $agi, $fis, $rit, $fin, $pas, $dri');

    if (agi == 0 || fis == 0 || rit == 0 || fin == 0 || pas == 0 || dri == 0) {
      debugPrint('Um ou mais valores estão zerados!');
    }
    List<List<double>> data = [
      [
        fin, // Finalização
        rit, // Ritmo
        dri, // Drible
        agi, // Agilidade
        fis, // Físico
        pas, // Passe
      ],
    ];

    List<String> features = [
      'Finalização',
      'Ritmo',
      'Drible',
      'Agilidade',
      'Físico',
      'Passe',
    ];

    debugPrint('Data para gráfico: ${data[0]}');
    debugPrint('Features para gráfico: $features');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: RadarGraph(
              data: data,
              features: features,
            ),
          ),
        );
      },
    );
  }

  void togglePlayerCard() async {
    setState(() {
      // Ativando o loading antes de carregar os dados
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final userImagePath = prefs.getString('userImagePath') ?? '';
    final currentUserName = userName ?? prefs.getString('userName') ?? '';
    final currentPosition = position ?? prefs.getString('position') ?? '';

    final List<int> expectedItemIds = [61, 16, 17, 41, 55, 54, 59];

    // Mapeando os scores com base nos judgments
    final Map<int, String> resultsMap = {
      for (var judgment in judgments!)
        if (judgment != null &&
            judgment['item'] != null &&
            judgment['item']['id'] != null)
          judgment['item']['id']: judgment['score']?.toString() ?? 'N/A',
    };

    final agiValue = resultsMap[61] ?? '';
    final pesoValue = resultsMap[17] ?? '';
    final alturaValue = resultsMap[16] ?? '';
    final embaixaValue = resultsMap[41] ?? '';
    final finValue = resultsMap[107] ?? '';
    final passValue = resultsMap[54] ?? '';
    final pass2Value = resultsMap[35] ?? '';
    final driValue = resultsMap[59] ?? '';
    final fin2Value = resultsMap[108] ?? '';

    debugPrint("Toggle Player Card:");
    debugPrint("Agilidade (item 61): $agiValue");
    debugPrint("Peso (item 16): $pesoValue");
    debugPrint("Altura (item 17): $alturaValue");
    debugPrint("Embaixadinha (item 41): $embaixaValue");
    debugPrint("Finalização (item 55): $finValue");
    debugPrint("Finalização (item 55): $fin2Value");
    debugPrint("Passe (item 54): $passValue");
    debugPrint("Drible (item 59): $driValue");
    debugPrint("Username: $currentUserName, Position: $currentPosition");

    // Simulando um pequeno delay para o loading
    await Future.delayed(Duration(milliseconds: 1));

    setState(() {
      // Desativando o loading após o delay
      _isLoading = false;
    });

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: PlayerCard(
              agiValue: agiValue,
              pesoValue: pesoValue,
              alturaValue: alturaValue,
              embaixaValue: embaixaValue,
              finalValue: finValue,
              passValue: passValue,
              driValue: driValue,
              userName: currentUserName,
              position: currentPosition,
              userImagePath: userImagePath,
              passValue2: pass2Value,
              final2Value: fin2Value,
            ),
          ),
        );
      },
    );
  }

  void toggleDadosUser() async {
    // Buscar as preferências do usuário
    final prefs = await SharedPreferences.getInstance();
    final currentUserName = userName ?? prefs.getString('userName') ?? '';
    final currentPosition = position ?? prefs.getString('position') ?? '';

    // Mapeando os scores de Peso (item 16) e Altura (item 17) a partir dos judgments
    final Map<int, String> resultsMap = {
      for (var judgment in judgments!)
        if (judgment != null &&
            judgment['item'] != null &&
            judgment['item']['id'] != null)
          judgment['item']['id']: judgment['score']?.toString() ?? 'N/A',
    };

    final pesoValue = resultsMap[16] ?? '';
    final alturaValue = resultsMap[17] ?? '';

    // Log para verificar os dados de Peso e Altura
    debugPrint("Toggle Dados User:");
    debugPrint("Peso (item 16): $pesoValue");
    debugPrint("Altura (item 17): $alturaValue");
    debugPrint("Username: $currentUserName, Position: $currentPosition");

    if (!_isDatacard) {
      setState(() {
        _isDatacard = true;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: DadosUser(
                peso: pesoValue,
                altura: alturaValue,
                onClose: () {
                  setState(() {
                    _isDatacard = false;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    debugPrint("Disposing ProfilePage...");
    _controller.dispose();
    super.dispose();
  }

  String calculateFinalScore(int? itemId, double? score) {
    if (score == null || score == 0) {
      return '0';
    }

    switch (itemId) {
      case 16:
        if (score <= 140) {
          return (70 + (score / 140) * 10).toInt().toString();
        } else if (score <= 160) {
          return (80 + ((score - 140) / 20) * 5).toInt().toString();
        } else if (score <= 180) {
          return (85 + ((score - 160) / 20) * 15).toInt().toString();
        } else if (score == 0) {
          return '0';
        }
        break;
      case 17:
        if (score <= 35) {
          return '80';
        } else if (score <= 45) {
          return '85';
        } else if (score <= 60) {
          return '90';
        } else if (score == 0) {
          return '0';
        }
        break;
      case 59:
        final adjustedScore = score - 2;
        if (adjustedScore < 15) {
          return '100';
        } else if (adjustedScore >= 16 && adjustedScore <= 17) {
          return '90';
        } else if (adjustedScore > 17 && adjustedScore <= 22) {
          final proportionalScore =
              90 - ((adjustedScore - 17) / (22 - 17) * 20);
          return proportionalScore.toStringAsFixed(1);
        } else if (adjustedScore > 23) {
          return '70';
        } else if (score == 0) {
          return '0';
        }
        break;
      case 60:
        if (score < 15.00) {
          return '100';
        } else if (score >= 16.00 && score <= 17.00) {
          return '90';
        } else if (score > 17.00 && score <= 22.00) {
          final proportionalScore = 90 - ((score - 17) / (22 - 17) * 20);
          return proportionalScore.toInt().toString();
        } else if (score > 23.00) {
          return '70';
        } else if (score == 0) {
          return '0';
        }
        break;
      case 61:
        if (score <= 1.8) {
          return '100';
        } else if (score > 1.8 && score <= 2.5) {
          final proportionalScore = 100 - ((score - 1.8) / (2.5 - 1.8) * 20);
          return proportionalScore.toInt().toString();
        } else if (score > 2.5) {
          final proportionalScore = 60 + ((score - 2.5) / (3.5 - 2.5) * 10);
          return proportionalScore.clamp(60, 70).toInt().toString();
        } else if (score == 0) {
          return '0';
        }
        break;
      case 62:
        if (score >= 120 && score <= 150) {
          return '85';
        } else if (score > 150 && score <= 170) {
          return '90';
        } else if (score > 170) {
          final proportionalScore = 90 + ((score - 170) / (180 - 170) * 10);
          return proportionalScore.clamp(90, 100).toInt().toString();
        } else if (score == 0) {
          return '0';
        }
        break;
      case 41:
        if (score <= 60) {
          return '60';
        } else if (score > 60 && score <= 70) {
          return '80';
        } else if (score > 70 && score <= 80) {
          return '90';
        } else if (score > 100) {
          final proportionalScore = 100 - ((score - 100) / (120 - 100) * 20);
          return proportionalScore.clamp(100, 100).toStringAsFixed(1);
        } else if (score == 0) {
          return '0';
        }
        break;
      case 54:
      case 55:
      case 56:
      case 35:
        return (score * 10).toInt().toString();
      default:
        return score.toInt().toString();
    }
    return '0';
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Construindo a interface do usuário...");
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0XFFb0c32e),
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
        title: Image.asset(
          Assets.homelogo,
          width: 200,
          color: Colors.white,
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0XFFb0c32e),
                          width: 4,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage: _image == null
                            ? null
                            : FileImage(File(_image!.path)),
                        backgroundColor: Colors.transparent,
                        child: _image == null
                            ? const Icon(
                                Icons.account_circle_outlined,
                                size: 120,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  (userName ?? 'Carregando...').toUpperCase(),
                  style:
                      principalFont.medium(color: Colors.white, fontSize: 30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category ?? '',
                      style: principalFont.regular(
                          color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '-',
                      style: principalFont.regular(
                          color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      position ?? '',
                      style: principalFont.regular(
                          color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        ...judgments!
                            .where((judgment) =>
                                judgment != null &&
                                judgment['item'] != null &&
                                judgment['item']['id'] != null &&
                                judgment['item']['name'] != null)
                            .map<Widget>((judgment) {
                          int itemId = judgment['item']['id'];
                          String result =
                              judgment['score']?.toString() ?? 'N/A';

                          return Visibility(
                            visible: false,
                            child: AvaliationView(
                              evaluationName:
                                  judgment['item']['name']?.toString() ?? 'N/A',
                              result: result,
                              finalScore: result,
                              itemId: itemId,
                              allEvaluations: judgments!
                                  .map((j) => AvaliationView(
                                        evaluationName:
                                            j['item']['name']?.toString() ??
                                                'N/A',
                                        result: j['score']?.toString() ?? 'N/A',
                                        finalScore:
                                            j['score']?.toString() ?? 'N/A',
                                        itemId: j['item']['id'] ?? 0,
                                        allEvaluations: const [],
                                        evaId: '',
                                        measurement: j['item']
                                            ['measurement_unit'],
                                      ))
                                  .toList(),
                              evaId: '',
                              measurement: judgment['item']['measurement_unit'],
                            ),
                          );
                        }),
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.75, // Largura ajustada
                          height: MediaQuery.of(context).size.height *
                              0.12, // Altura ajustada
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Color(0XFFb0c32e)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: togglePlayerCard,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.badge,
                                  color: Colors.white,
                                  size: MediaQuery.of(context).size.width *
                                      0.12, // Ícone ajustado
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05), // Espaçamento entre ícone e texto
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Alinhamento para o início
                                    children: [
                                      Text(
                                        'CARD',
                                        style: principalFont.medium(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.09, // Tamanho ajustado para o título
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.00), // Espaçamento ajustado
                                      Text(
                                        'VEJA SUA PONTUAÇÃO',
                                        style: principalFont.medium(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03, // Tamanho bem menor para o subtítulo
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DataCard(onPressed: toggleDadosUser),
                        const SizedBox(height: 20),
                        const AvaliatonButton(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: 1,
                  height: 1,
                  child: Visibility(
                    visible: false,
                    child: ListView.builder(
                      itemCount: widget.allEvaluations.length,
                      itemBuilder: (context, index) {
                        final evaluation = widget.allEvaluations[index];
                        return ListTile(
                          title: Text(evaluation.evaluationName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Resultado: ${evaluation.result}'),
                              Text(
                                  'Nota Final: ${calculateFinalScore(evaluation.itemId, double.parse(evaluation.result))}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
