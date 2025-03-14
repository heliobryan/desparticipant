import 'dart:developer';
import 'dart:io';
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/profile/graph/graph.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerCard extends StatefulWidget {
  final String agiValue;
  final String pesoValue;
  final String alturaValue;
  final String finalValue;
  final String final2Value;

  final String embaixaValue;
  final String passValue;
  final String driValue;
  final String userName;
  final String position;
  final String userImagePath;
  final String passValue2;

  const PlayerCard({
    super.key,
    required this.agiValue,
    required this.pesoValue,
    required this.alturaValue,
    required this.finalValue,
    required this.embaixaValue,
    required this.passValue,
    required this.driValue,
    required this.userName,
    required this.position,
    required this.userImagePath,
    required this.passValue2,
    required this.final2Value,
  });

  @override
  State<PlayerCard> createState() => _PlayerCardstate();
}

class _PlayerCardstate extends State<PlayerCard> {
  // ignore: unused_field
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadImageFromPreferences();
    loadImageFromSharedPreferences();
  }

  Future<String> loadImageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final base64Image = prefs.getString('user_image_base64') ?? '';
    return base64Image;
  }

  XFile? _image;

  void _loadImageFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('user_image_path');
    if (imagePath != null) {
      setState(() {
        _imageFile = File(imagePath);
      });
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

  String calculateFinalScore(int itemId, double? score) {
    if (score == null || score == 0) return '0';

    switch (itemId) {
      case 16:
        if (score <= 140) {
          return (70 + (score / 140) * 10).toInt().toString();
        } else if (score <= 160) {
          return (80 + ((score - 140) / 20) * 5).toInt().toString();
        } else if (score <= 180) {
          return (85 + ((score - 160) / 20) * 15).toInt().toString();
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
        final double adjustedScore = score - 2.0;
        if (adjustedScore <= 17) {
          return '100';
        } else if (adjustedScore > 17 && adjustedScore <= 19) {
          final int proportionalScore =
              (90 + ((adjustedScore - 17) / (19 - 17) * 9)).toInt();
          return proportionalScore.toString();
        } else if (adjustedScore >= 20 && adjustedScore <= 22) {
          final int proportionalScore =
              (80 + ((adjustedScore - 20) / (22 - 20) * 9)).toInt();
          return proportionalScore.toString();
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
          return proportionalScore.toInt().toString();
        } else if (score > 23) {
          return '70';
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
        }
        break;

      case 62:
        if (score >= 120 && score <= 150) {
          return '85';
        } else if (score > 150 && score <= 170) {
          return '90';
        } else if (score > 170) {
          final proportionalScore = 90 + ((score - 170) / (180 - 170) * 10);
          return proportionalScore.toInt().toString();
        }
        break;

      case 41:
        if (score <= 60) {
          return '60';
        } else if (score > 60 && score <= 70) {
          return '80';
        } else if (score > 70 && score <= 99) {
          return '90';
        } else if (score > 100) {
          final proportionalScore = 100 - ((score - 100) / (120 - 100) * 20);
          return proportionalScore.toInt().toString();
        }
        break;

      case 107:
        int finalScore = (score * 5 / 2).toInt();
        return finalScore > 100 ? '100' : finalScore.toString();
      case 108:
        int finalScore = (score * 5 / 2).toInt();
        return finalScore > 100 ? '100' : finalScore.toString();

      case 35:
      case 54:
        return (score * 5).toInt().toString();

      case 56:
        return (score * 10).toInt().toString();

      default:
        return score.toInt().toString();
    }

    return '0';
  }

  @override
  Widget build(BuildContext context) {
    double agiNumeric = double.tryParse(widget.agiValue) ?? 0;
    double fisNumeric = double.tryParse(widget.alturaValue) ?? 0;
    double fisNumeric2 = double.tryParse(widget.pesoValue) ?? 0;
    double finNumeric = double.tryParse(widget.finalValue) ?? 0;
    double pasNumeric = double.tryParse(widget.passValue) ?? 0;
    double pas2Numeric = double.tryParse(widget.passValue2) ?? 0;
    double fin2Numeric = double.tryParse(widget.final2Value) ?? 0;
    double driNumeric = double.tryParse(widget.driValue) ?? 0;
    double ritNumeric = double.tryParse(widget.embaixaValue) ?? 0;

    log('pas Numeric: $pasNumeric');
    log('pas2 Numeric: $pas2Numeric');
    log('dri numeric: $driNumeric');
    log('fin numeric: $finNumeric');
    log('fin numeric: $fin2Numeric');
    log('fis numeric: $fisNumeric');
    log('agi numeric: $agiNumeric');

    String calculatedAgi = calculateFinalScore(61, agiNumeric);
    String calculatedFis = calculateFinalScore(16, fisNumeric);
    String calculatedFis2 = calculateFinalScore(17, fisNumeric);
    String calculatedRit = calculateFinalScore(41, ritNumeric);
    String calculatedFin = calculateFinalScore(107, finNumeric);
    String calculatedFin2 = calculateFinalScore(108, fin2Numeric);
    String calculatedPas = calculateFinalScore(54, pasNumeric);
    String calculatedPas2 = calculateFinalScore(35, pas2Numeric);
    String calculatedDri = calculateFinalScore(59, driNumeric);

    int agi = int.tryParse(calculatedAgi) ?? 0;
    int fis = int.tryParse(calculatedFis) ?? 0;
    int fis2 = int.tryParse(calculatedFis2) ?? 0;
    int rit = int.tryParse(calculatedRit) ?? 0;
    int fin = int.tryParse(calculatedFin) ?? 0;
    int fin2 = int.tryParse(calculatedFin2) ?? 0;
    int pas = int.tryParse(calculatedPas) ?? 0;
    int pas2 = int.tryParse(calculatedPas2) ?? 0;
    int dri = int.tryParse(calculatedDri) ?? 0;
    int passe = ((pas + pas2)).toInt();
    int fiu = ((fin + fin2) / 2).toInt();

    double calculateAverageScore(
      int itemId1,
      double score1,
      int itemId2,
      double score2,
    ) {
      return ((double.tryParse(calculateFinalScore(itemId1, score1)) ?? 0.0) +
              (double.tryParse(calculateFinalScore(itemId2, score2)) ?? 0.0)) /
          2.0;
    }

    String fiscore = calculateAverageScore(17, fisNumeric2, 16, fisNumeric)
        .toStringAsFixed(0);
    int average = ((agi + fis2 + fis + rit + fiu + passe + dri) / 6).toInt();
    Color getAverageColor(int average) {
      if (average <= 70) {
        return const Color(0xFFC52613); // Vermelho
      } else if (average <= 79) {
        return const Color(0xFFCD7F32); // Bronze
      } else if (average <= 85) {
        return const Color(0xFFC0C0C0); // Prata
      } else if (average <= 94) {
        return const Color(0xFFFFD700); // Ouro
      } else {
        return const Color(0xFFB9F2FF); // Azul claro
      }
    }

    Color cardColor = getAverageColor(average);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cardColor, //ESSA COR
            Color(0xFF1E1E1E),
            Color(0xFF1E1E1E),
          ],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        boxShadow: [],
      ),
      width: 400,
      height: 700,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: cardColor,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(46)),
          ),
          width: 400,
          height: 700,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                          ),
                          child: GestureDetector(
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: _image == null
                                  ? null
                                  : FileImage(File(_image!.path)),
                              backgroundColor: Colors.transparent,
                              child: _image == null
                                  ? const Center(
                                      child: Icon(
                                        Icons.account_circle_outlined,
                                        size: 160,
                                        color: Colors.grey,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '$average', //OVERALL
                          style: principalFont.medium(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.position.toUpperCase(), //POSIÇÃO
                          style: principalFont.medium(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.userName.toUpperCase(), //NOME DO PARTICIPANTE

                        style: principalFont.bold(
                            color: Colors.white, fontSize: 25)),
                    const SizedBox(height: 15),
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ('$calculatedRit RIT'),
                          style: principalFont.medium(
                              color: Colors.white, fontSize: 25),
                        ),
                        Text(
                          '$fiu FIN', //FINALIZAÇÃO
                          style: principalFont.medium(
                              color: Colors.white, fontSize: 25),
                        ),
                        Text(
                          '$passe PAS', //PASSE
                          style: principalFont.medium(
                              color: Colors.white, fontSize: 25),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$calculatedDri DRI', //DRIBLE
                          style: principalFont.medium(
                              color: Colors.white, fontSize: 25),
                        ),
                        Text(
                          '$calculatedAgi AGI', //AGILIDADE
                          style: principalFont.medium(
                              color: Colors.white, fontSize: 25),
                        ),
                        Text(
                          '$fiscore FIS', //FISICO
                          style: principalFont.medium(
                              color: Colors.white, fontSize: 25),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                RadarGraph(
                  data: [
                    [
                      agi.toDouble(),
                      fis.toDouble(),
                      rit.toDouble(),
                      fin.toDouble(),
                      passe.toDouble(),
                      dri.toDouble()
                    ]
                  ],
                  features: [
                    'Agilidade',
                    'Físico',
                    'Ritmo',
                    'Finalização',
                    'Passe',
                    'Drible'
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
