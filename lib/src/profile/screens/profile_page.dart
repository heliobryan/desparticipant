import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/home/widgets/avaliation_view.dart';
import 'package:des/src/profile/cards/card.dart';
import 'package:des/src/profile/datauser/data_user.dart';
import 'package:des/src/profile/graph/graph.dart';
import 'package:des/src/profile/services/profile_service.dart';
import 'package:des/src/profile/widgets/data_card.dart';
import 'package:des/src/profile/widgets/graphic_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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

  bool _isDatacard = false;
  late final AnimationController _controller;
  final ImagePicker _picker = ImagePicker(); // Instancia o ImagePicker
  XFile? _image; // Variável para armazenar a imagem escolhida ou capturad

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera, // Pode alternar para ImageSource.gallery
    );

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile; // Armazena a imagem escolhida ou capturada
        _saveImageToSharedPreferences(
            _image!.path); // Salva o caminho da imagem
      }
    });
  }

  Future<void> _saveImageToSharedPreferences(String imagePath) async {
    try {
      // Obtém a instância de SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Salva o caminho da imagem no SharedPreferences
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
      // Caso haja um caminho salvo, podemos usar para carregar a imagem
      setState(() {
        _image = XFile(savedImagePath); // Usando o caminho da imagem salva
      });
    } else {
      log("Nenhuma imagem salva encontrada.");
    }
  }

  @override
  void initState() {
    log("Dados recebidos na ProfilePage:");
    log("evaluationName: ${widget.evaluationName}");
    log("result: ${widget.result}");
    log("finalScore: ${widget.finalScore}");
    super.initState();
    log("Inicializando ProfilePage...");
    loadUserData();
    loadImageFromSharedPreferences(); // Carrega a imagem salva do SharedPreferences

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  // Função para carregar os dados do usuário
  Future<void> loadUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Verifica se os dados já estão salvos no SharedPreferences
    userName = sharedPreferences.getString('userName');
    userId = sharedPreferences.getString('userId');
    category = sharedPreferences.getString('category');
    position = sharedPreferences.getString('position');

    // Se os dados estiverem salvos, não faz a requisição novamente
    if (userName != null &&
        userId != null &&
        category != null &&
        position != null) {
      debugPrint("Dados encontrados no SharedPreferences.");
      setState(() {
        // Atualiza o estado com os dados salvos
      });
    } else {
      debugPrint(
          "Dados não encontrados no SharedPreferences, buscando na API...");
      String token = await homeService.loadToken();
      final responseData = await homeService.fetchParticipantDetails(token);

      if (responseData != null) {
        // Dados recebidos da API
        debugPrint("Dados recebidos no loadUserData: $responseData");

        final participant = responseData;
        final user = participant['user'] ?? {};

        setState(() {
          userName = user['name'] ?? 'Sem Nome';
          userId = user['id'] != null ? user['id'].toString() : 'Sem ID';
          category = participant['category'] ?? 'Sem Categoria';
          position = participant['position'] ?? 'Sem Posição';
        });

        // Salva as informações no SharedPreferences para futuras consultas
        await sharedPreferences.setString('userName', userName ?? '');
        await sharedPreferences.setString('userId', userId ?? '');
        await sharedPreferences.setString('category', category ?? '');
        await sharedPreferences.setString('position', position ?? '');
      } else {
        debugPrint("Falha ao obter os dados do participante.");
      }
    }
  }

  void toggleRadarGraph() {
    final item61 = widget.allEvaluations.firstWhere(
      (evaluation) => evaluation.itemId == 61,
      orElse: () => const AvaliationView(
        itemId: 61,
        evaluationName: 'Sprint',
        result: '',
        finalScore: '',
        allEvaluations: [],
        evaId: '',
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
      ),
    );
    final item41 = widget.allEvaluations.firstWhere(
      (evaluation) => evaluation.itemId == 41,
      orElse: () => const AvaliationView(
        itemId: 41,
        evaluationName: 'Embaixadinha',
        result: '',
        finalScore: '',
        allEvaluations: [],
        evaId: '',
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
      ),
    );
    final item59 = widget.allEvaluations.firstWhere(
      (evaluation) => evaluation.itemId == 59,
      orElse: () => const AvaliationView(
        itemId: 59,
        evaluationName: 'Drible',
        result: '',
        finalScore: '',
        allEvaluations: [],
        evaId: '',
      ),
    );

    final driValue = item59.result;
    final passValue = item54.result;
    final finalValue = item55.result;
    final embaixaValue = item41.result;
    final alturaValue = item17.result;
    final ritValue = item61.result;

    String calculatedAgi =
        calculateFinalScore(61, double.tryParse(ritValue) ?? 0);
    String calculatedFis =
        calculateFinalScore(16, double.tryParse(alturaValue) ?? 0);
    String calculatedRit =
        calculateFinalScore(41, double.tryParse(embaixaValue) ?? 0);
    String calculatedFin =
        calculateFinalScore(55, double.tryParse(finalValue) ?? 0);
    String calculatedPas =
        calculateFinalScore(54, double.tryParse(passValue) ?? 0);
    String calculatedDri =
        calculateFinalScore(59, double.tryParse(driValue) ?? 0);

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
    final prefs = await SharedPreferences.getInstance();
    final userImagePath =
        prefs.getString('user_image_path'); // ou getString('user_image_base64')

    final item61 = widget.allEvaluations.firstWhere(
      (evaluation) => evaluation.itemId == 61,
      orElse: () => const AvaliationView(
        itemId: 61,
        evaluationName: 'Sprint',
        result: '',
        finalScore: '',
        allEvaluations: [],
        evaId: '',
      ),
    );
    final item16 = widget.allEvaluations.firstWhere(
      (evaluation) => evaluation.itemId == 16,
      orElse: () => const AvaliationView(
        itemId: 16,
        evaluationName: 'Peso',
        result: '',
        finalScore: '',
        allEvaluations: [],
        evaId: '',
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
      ),
    );
    final item41 = widget.allEvaluations.firstWhere(
      (evaluation) => evaluation.itemId == 41,
      orElse: () => const AvaliationView(
        itemId: 41,
        evaluationName: 'Embaixadinha',
        result: '',
        finalScore: '',
        allEvaluations: [],
        evaId: '',
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
      ),
    );
    final item59 = widget.allEvaluations.firstWhere(
      (evaluation) => evaluation.itemId == 59,
      orElse: () => const AvaliationView(
        itemId: 59,
        evaluationName: 'Drible',
        result: '',
        finalScore: '',
        allEvaluations: [],
        evaId: '',
      ),
    );

    final driValue = item59.result;
    final passValue = item54.result;
    final finalValue = item55.result;
    final embaixaValue = item41.result;
    final pesoValue = item16.result;
    final alturaValue = item17.result;
    final ritValue = item61.result;

    debugPrint("Toggling Player Card...");

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: PlayerCard(
              ritValue: ritValue,
              pesoValue: pesoValue,
              alturaValue: alturaValue,
              embaixaValue: embaixaValue,
              finalValue: finalValue,
              passValue: passValue,
              driValue: driValue,
              userName: userName ?? '',
              position: position ?? '',
              userImagePath: userImagePath ?? '', // Passando a foto
            ),
          ),
        );
      },
    );
  }

  void toggleDadosUser() {
    final item16 = widget.allEvaluations.firstWhere(
      (evaluation) => evaluation.itemId == 16,
      orElse: () => const AvaliationView(
        itemId: 17,
        evaluationName: 'Peso',
        result: '',
        finalScore: '',
        allEvaluations: [],
        evaId: '',
      ),
    );
    final item17 = widget.allEvaluations.firstWhere(
      (evaluation) => evaluation.itemId == 17,
      orElse: () => const AvaliationView(
        itemId: 16,
        evaluationName: 'Altura',
        result: '',
        finalScore: '',
        allEvaluations: [],
        evaId: '',
      ),
    );

    final peso = item16.result;
    final altura = item17.result;

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
                peso: peso,
                altura: altura,
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
      return '0.0';
    }

    switch (itemId) {
      case 16:
        if (score <= 140) {
          return (70 + (score / 140) * 10).toStringAsFixed(1);
        } else if (score <= 160) {
          return (80 + ((score - 140) / 20) * 5).toStringAsFixed(1);
        } else if (score <= 180) {
          return (85 + ((score - 160) / 20) * 15).toStringAsFixed(1);
        }
        break;
      case 17:
        if (score <= 35) {
          return '80';
        } else if (score <= 45) {
          return '85';
        } else if (score <= 60) {
          return '90';
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
        }
        break;
      case 60:
        if (score < 15) {
          return '100';
        } else if (score >= 16 && score <= 17) {
          return '90';
        } else if (score > 17 && score <= 22) {
          final proportionalScore = 90 - ((score - 17) / (22 - 17) * 20);
          return proportionalScore.toStringAsFixed(1);
        } else if (score > 23) {
          return '70';
        }
        break;
      case 61:
        if (score <= 1.8) {
          return '100';
        } else if (score > 1.8 && score <= 2.5) {
          final proportionalScore = 100 - ((score - 1.8) / (2.5 - 1.8) * 20);
          return proportionalScore.toStringAsFixed(1);
        } else if (score > 2.5) {
          final proportionalScore = 60 + ((score - 2.5) / (3.5 - 2.5) * 10);
          return proportionalScore.clamp(60, 70).toStringAsFixed(1);
        }
        break;
      case 62:
        if (score >= 120 && score <= 150) {
          return '85';
        } else if (score > 150 && score <= 170) {
          return '90';
        } else if (score > 170) {
          final proportionalScore = 90 + ((score - 170) / (180 - 170) * 10);
          return proportionalScore.clamp(90, 100).toStringAsFixed(1);
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
        }
        break;
      case 54:
      case 55:
      case 56:
      case 35:
        return (score * 10).toStringAsFixed(1);
      default:
        return score.toStringAsFixed(1);
    }

    return '0.0'; // Garantia de retorno 0.0 caso nenhum case seja satisfeito
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Construindo a interface do usuário...");
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
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
          'PERFIL',
          style: principalFont.medium(color: Colors.white, fontSize: 20),
        ),
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
                          color: Colors.white,
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
                                Icons.account_circle_outlined, // Ícone da conta
                                size:
                                    120, // Ajuste o tamanho conforme necessário
                                color: Colors.grey, // Cor do ícone
                              )
                            : null, // Se tiver imagem, não exibe o ícone
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
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GrapichButton(onPressed: toggleRadarGraph),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: togglePlayerCard,
                      child: Text(
                        'CARD',
                        style: principalFont.medium(
                            color: Colors.white, fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 10),
                    DataCard(onPressed: toggleDadosUser),
                  ],
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: 10,
                  height: 10,
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
