import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:des/src/GlobalConstants/font.dart';
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
  final String userImagePath; // Adicionando a foto

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
    loadImageFromSharedPreferences(); // Carrega a imagem salva do SharedPreferences
  }

  Future<String> loadImageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final base64Image = prefs.getString('user_image_base64') ?? '';
    return base64Image;
  }

  final ImagePicker _picker = ImagePicker(); // Instancia o ImagePicker
  XFile? _image; // Variável para armazenar a imagem escolhida ou capturad

  // Função para carregar a imagem do SharedPreferences
  void _loadImageFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath =
        prefs.getString('user_image_path'); // Aqui você pega o caminho
    if (imagePath != null) {
      setState(() {
        _imageFile = File(imagePath); // Atualiza a imagem
      });
    }
  }

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

  String calculateFinalScore(int itemId, double score) {
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

        if (adjustedScore <= 17.0) {
          return '100';
        } else if (adjustedScore > 17.0 && adjustedScore <= 19.0) {
          final double proportionalScore =
              90 + ((adjustedScore - 17.0) / (19.0 - 17.0) * 9);
          return proportionalScore.toStringAsFixed(1);
        } else if (adjustedScore >= 20.0 && adjustedScore <= 22.0) {
          final double proportionalScore =
              80 + ((adjustedScore - 20.0) / (22.0 - 20.0) * 9);
          return proportionalScore.toStringAsFixed(1);
        } else if (adjustedScore > 23.0) {
          return '70';
        }

        return '0';
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
    return '0'; // Garantia de retorno 0 caso nenhuma condição seja satisfeita
  }

  @override
  Widget build(BuildContext context) {
    double agiNumeric = double.tryParse(widget.agiValue) ?? 0;
    double fisNumeric = double.tryParse(widget.alturaValue) ?? 0;
    double finNumeric = double.tryParse(widget.finalValue) ?? 0;
    double pasNumeric = double.tryParse(widget.passValue) ?? 0;
    double driNumeric = double.tryParse(widget.driValue) ?? 0;

    print('pas Numeric: $pasNumeric'); // Verifica o valor de pasNumeric

// Passando os valores para a função de cálculo
    String calculatedAgi = calculateFinalScore(61, agiNumeric);
    String calculatedFis = calculateFinalScore(16, fisNumeric);
    String calculatedRit = calculateFinalScore(41, fisNumeric);
    String calculatedFin = calculateFinalScore(55, finNumeric);
    String calculatedPas = calculateFinalScore(54, pasNumeric);
    String calculatedDri = calculateFinalScore(59, driNumeric);

// Convertendo os resultados calculados para inteiros (sem ponto)
    int agi = int.tryParse(calculatedAgi) ?? 0;
    int fis = int.tryParse(calculatedFis) ?? 0;
    int rit = int.tryParse(calculatedRit) ?? 0;
    int fin = int.tryParse(calculatedFin) ?? 0;
    int pas = int.tryParse(calculatedPas) ?? 0;
    int dri = int.tryParse(calculatedDri) ?? 0;

    int average = ((agi + fis + rit + fin + pas + dri) / 6).toInt();

    List<Color> gradientColors;
    if (average > 90) {
      gradientColors = [Color(0xFFFFD700), Color(0xFF1E1E1E)]; // Dourado
    } else if (average >= 80 && average <= 89) {
      gradientColors = [Color(0xFFC0C0C0), Color(0xFF1E1E1E)]; // Prata
    } else if (average >= 70 && average <= 79) {
      gradientColors = [Color(0xFF800080), Color(0xFF1E1E1E)]; // Roxo
    } else {
      gradientColors = [
        Color(0xFF1E1E1E),
        Color(0xFF1E1E1E)
      ]; // Preto (default)
    }

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
      width: 350,
      height: 500,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFCBA135),
              width: 1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(46)),
          ),
          width: 342,
          height: 492,
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
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: _image == null
                                  ? null
                                  : FileImage(File(_image!.path)),
                              backgroundColor: Colors.transparent,
                              child: _image == null
                                  ? const Center(
                                      // Adicionado Center aqui para centralizar o ícone
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
                        const Icon(
                          //ESCUDO TIME
                          Icons.shield,
                          color: Colors.white,
                          size: 50,
                        ),
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
                const SizedBox(height: 40),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share,
                      size: 30,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
