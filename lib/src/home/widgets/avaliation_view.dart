import 'dart:developer';

import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class AvaliationView extends StatelessWidget {
  final String evaluationName;
  final String result;
  final String finalScore;
  final int? itemId; // Permitir que itemId seja null

  const AvaliationView({
    super.key,
    required this.evaluationName,
    required this.result,
    required this.finalScore,
    this.itemId,
  });

  /// Lógica para calcular a nota final
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
      final adjustedScore = score - 2; // Reduzir 2 pontos no score
      if (adjustedScore < 15) {
        return '100'; // Score ajustado < 15
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
    final score =
        double.tryParse(result) ?? 0.0; // Converter o resultado para número

    return Container(
      width: 320,
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              evaluationName,
              style: principalFont.medium(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'RESULTADO:',
              style: principalFont.medium(color: Colors.white),
            ),
            Text(
              '$result',
              style: principalFont.medium(color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'NOTA FINAL:',
              style: principalFont.medium(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  calculateFinalScore(
                      itemId, score), // Chama a lógica de cálculo
                  style:
                      principalFont.medium(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
