import 'dart:developer';

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
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String evaluationName;
  final String result;
  final String finalScore;

  final List<AvaliationView>
      allEvaluations; // Adicionando a lista de avaliações

  const ProfilePage({
    super.key,
    required this.evaluationName,
    required this.result,
    required this.finalScore,
    required this.allEvaluations, // Certificando que a lista é passada no construtor
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

  bool _isPlayerCardVisible = false;
  bool _isRadarGraphVisible = false;
  bool _isDatacard = false;
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    log("Dados recebidos na ProfilePage:");
    log("evaluationName: ${widget.evaluationName}");
    log("result: ${widget.result}");
    log("finalScore: ${widget.finalScore}");
    super.initState();
    log("Inicializando ProfilePage...");
    loadUserData();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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

  void togglePlayerCard() {
    debugPrint("Toggling Player Card...");
    if (_isPlayerCardVisible) {
      debugPrint("Escondendo Player Card");
      _controller.reverse().then((_) {
        setState(() {
          _isPlayerCardVisible = false;
        });
      });
    } else {
      debugPrint("Exibindo Player Card");
      setState(() {
        _isPlayerCardVisible = true;
      });
      _controller.forward();
    }
  }

  void toggleRadarGraph() {
    debugPrint("Toggling Radar Graph...");
    if (_isRadarGraphVisible) {
      debugPrint("Escondendo Radar Graph");
      _controller.reverse().then((_) {
        setState(() {
          _isRadarGraphVisible = false;
        });
      });
    } else {
      debugPrint("Exibindo Radar Graph");
      setState(() {
        _isRadarGraphVisible = true;
      });
      _controller.forward();
    }
  }

  void toggleDadosUser() {
    debugPrint("Toggling Dados User...");
    if (_isDatacard) {
      debugPrint("Escondendo Dados User");
      _controller.reverse().then((_) {
        setState(() {
          _isDatacard = false;
        });
      });
    } else {
      debugPrint("Exibindo Dados User");
      setState(() {
        _isDatacard = true;
      });
      _controller.forward();
    }
  }

  @override
  void dispose() {
    debugPrint("Disposing ProfilePage...");
    _controller.dispose();
    super.dispose();
  }

  // Função para calcular a nota final
  String calculateFinalScore(int? itemId, double score) {
    if (itemId == 16) {
      if (score <= 140) {
        return (70 + (score / 140) * 10).toStringAsFixed(1); // De 70 a 80
      } else if (score <= 160) {
        return (80 + ((score - 140) / 20) * 5).toStringAsFixed(1); // De 80 a 85
      } else if (score <= 180) {
        return (85 + ((score - 160) / 20) * 15)
            .toStringAsFixed(1); // De 85 a 100
      }
    } else if (itemId == 17) {
      if (score <= 35) {
        return '80'; // Para score <= 35
      } else if (score <= 45) {
        return '85'; // Para score entre 35 e 45
      } else if (score <= 60) {
        return '90'; // Para score entre 40 e 60
      }
    } else if (itemId == 59) {
      final adjustedScore = score - 2;
      if (adjustedScore < 15) {
        return '100';
      } else if (adjustedScore >= 16 && adjustedScore <= 17) {
        return '90'; // Score ajustado entre 16 e 17
      } else if (adjustedScore > 17 && adjustedScore <= 22) {
        final proportionalScore =
            90 - ((adjustedScore - 17) / (22 - 17) * 20); // De 90 a 70
        return proportionalScore.toStringAsFixed(1);
      } else if (adjustedScore > 23) {
        return '70'; // Score ajustado > 23
      }
    } else if (itemId == 60) {
      if (score < 15) {
        return '100'; // Score < 15
      } else if (score >= 16 && score <= 17) {
        return '90'; // Score entre 16 e 17
      } else if (score > 17 && score <= 22) {
        final proportionalScore =
            90 - ((score - 17) / (22 - 17) * 20); // De 90 a 70
        return proportionalScore.toStringAsFixed(1);
      } else if (score > 23) {
        return '70'; // Score > 23
      }
    } else if (itemId == 61) {
      if (score <= 1.8) {
        return '100'; // Score <= 1.8
      } else if (score > 1.8 && score <= 2.5) {
        final proportionalScore =
            100 - ((score - 1.8) / (2.5 - 1.8) * 20); // De 100 a 80
        return proportionalScore.toStringAsFixed(1);
      } else if (score > 2.5) {
        final proportionalScore =
            60 + ((score - 2.5) / (3.5 - 2.5) * 10); // De 60 a 70
        return proportionalScore.clamp(60, 70).toStringAsFixed(1);
      }
    } else if (itemId == 62) {
      if (score >= 120 && score <= 150) {
        return '85'; // Score entre 120 e 150
      } else if (score > 150 && score <= 170) {
        return '90'; // Score entre 150 e 170
      } else if (score > 170) {
        // Proporcional de 90 a 100
        final proportionalScore =
            90 + ((score - 170) / (180 - 170) * 10); // De 90 a 100
        return proportionalScore.clamp(90, 100).toStringAsFixed(1);
      }
    } else if (itemId == 41) {
      if (score <= 60) {
        return '60'; // Score <= 60
      } else if (score > 60 && score <= 70) {
        return '80'; // Score entre 60 e 70
      } else if (score > 70 && score <= 80) {
        return '90'; // Score entre 70 e 80
      } else if (score > 100) {
        // Proporcional acima de 100 até 100
        final proportionalScore =
            100 - ((score - 100) / (120 - 100) * 20); // De 100 a 100 (clamp)
        return proportionalScore.clamp(100, 100).toStringAsFixed(1);
      }
    } else if (itemId == 54 || itemId == 55 || itemId == 56 || itemId == 35) {
      // Lógica simples: cada 1 no score equivale a 10
      return (score * 10).toStringAsFixed(1);
    }
    return score.toStringAsFixed(1); // Retorna o score padrão para outros itens
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Construindo a interface do usuário...");
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        centerTitle: true,
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
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.account_circle_outlined,
                      size: 130,
                      color: Colors.white,
                    ),
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
                  width: 50, // Largura fixa
                  height: 50, // Altura fixa
                  child: Visibility(
                    visible:
                        false, // A lista ficará invisível, mas com espaço ocupado
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
                                  'Nota Final: ${calculateFinalScore(evaluation.id, double.parse(evaluation.result))}'),
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
          if (_isRadarGraphVisible)
            SlideTransition(
              position: _slideAnimation,
              child: const RadarGraph(),
            ),
          if (_isPlayerCardVisible)
            SlideTransition(
              position: _slideAnimation,
              child: const PlayerCard(),
            ),
          if (_isDatacard)
            SlideTransition(
              position: _slideAnimation,
              child: DataCard(
                onPressed: () {},
              ),
            ),
        ],
      ),
    );
  }
}
