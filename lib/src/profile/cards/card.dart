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
  final String embaixaValue;
  final String passValue;
  final String driValue;
  final String userName;
  final String position;
  final String userImagePath;

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
        } else if (score > 70 && score <= 80) {
          return '90';
        } else if (score > 100) {
          final proportionalScore = 100 - ((score - 100) / (120 - 100) * 20);
          return proportionalScore.toInt().toString();
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
    double agiNumeric = double.tryParse(widget.agiValue) ?? 0;
    double fisNumeric = double.tryParse(widget.alturaValue) ?? 0;
    double finNumeric = double.tryParse(widget.finalValue) ?? 0;
    double pasNumeric = double.tryParse(widget.passValue) ?? 0;
    double driNumeric = double.tryParse(widget.driValue) ?? 0;

    log('pas Numeric: $pasNumeric');
    log('dri numeric: $driNumeric');
    log('fin numeric: $finNumeric');
    log('fis numeric: $fisNumeric');
    log('agi numeric: $agiNumeric');

    String calculatedAgi = calculateFinalScore(61, agiNumeric);
    String calculatedFis = calculateFinalScore(16, fisNumeric);
    String calculatedRit = calculateFinalScore(41, fisNumeric);
    String calculatedFin = calculateFinalScore(55, finNumeric);
    String calculatedPas = calculateFinalScore(54, pasNumeric);
    String calculatedDri = calculateFinalScore(59, driNumeric);

    int agi = int.tryParse(calculatedAgi) ?? 0;
    int fis = int.tryParse(calculatedFis) ?? 0;
    int rit = int.tryParse(calculatedRit) ?? 0;
    int fin = int.tryParse(calculatedFin) ?? 0;
    int pas = int.tryParse(calculatedPas) ?? 0;
    int dri = int.tryParse(calculatedDri) ?? 0;

    int average = ((agi + fis + rit + fin + pas + dri) / 6).toInt();

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFCBA135),
            Color(0xFF1E1E1E),
            Color(0xFF1E1E1E),
          ],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.amber.withOpacity(0.5),
            spreadRadius: -8,
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.amber.withOpacity(0.3),
            spreadRadius: 12,
            blurRadius: 25,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      width: 400,
      height: 700,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFCBA135),
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
                        Image.asset(
                          'assets/images/flamengo.png',
                          scale: 20,
                        )
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
                          '$calculatedFin FIN', //FINALIZAÇÃO
                          style: principalFont.medium(
                              color: Colors.white, fontSize: 25),
                        ),
                        Text(
                          '$calculatedPas PAS', //PASSE
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
                          '$calculatedFis FIS', //FISICO
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
                      pas.toDouble(),
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
