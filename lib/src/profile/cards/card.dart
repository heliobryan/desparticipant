import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class PlayerCard extends StatefulWidget {
  final String ritValue;
  final String pesoValue;
  final String alturaValue;
  final String finalValue;
  final String embaixaValue;
  final String passValue;
  final String driValue;
  final String userName;
  final String position;
  const PlayerCard({
    super.key,
    required this.ritValue,
    required this.pesoValue,
    required this.alturaValue,
    required this.finalValue,
    required this.embaixaValue,
    required this.passValue,
    required this.driValue,
    required this.userName,
    required this.position,
  });

  @override
  State<PlayerCard> createState() => _PlayerCardstate();
}

class _PlayerCardstate extends State<PlayerCard> {
  String calculateFinalScore(int itemId, int score) {
    switch (itemId) {
      case 16:
        if (score <= 140) {
          return '80';
        } else if (score <= 160) {
          return '90';
        } else if (score <= 180) {
          return '100';
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
          return proportionalScore.toInt().toString();
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
    return score.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    int agiNumeric = int.tryParse(widget.ritValue) ?? 0;
    int fisNumeric = int.tryParse(widget.alturaValue) ?? 0;
    int finNumeric = int.tryParse(widget.finalValue) ?? 0;
    int pasNumeric = int.tryParse(widget.finalValue) ?? 0;
    int driNumeric = int.tryParse(widget.finalValue) ?? 0;

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
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons
                              .account_circle_outlined, // FUTURAMENTE FOTO DO PARTICIPANTE
                          size: 190,
                          color: Colors.white,
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
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'VER RANKING',
                    style: principalFont.medium(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
