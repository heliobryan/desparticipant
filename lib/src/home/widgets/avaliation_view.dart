import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class AvaliationView extends StatelessWidget {
  final String evaluationName;
  final String result;
  final String finalScore;
  final int? itemId;
  final List<AvaliationView> allEvaluations;
  final String evaId;

  const AvaliationView({
    super.key,
    required this.evaluationName,
    required this.result,
    required this.finalScore,
    this.itemId,
    required this.allEvaluations, // Lista de todas as avaliações
    required this.evaId,
  });

  String calculateFinalScore(int? itemId, double score) {
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
    return score.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final score = double.tryParse(result) ?? 0.0;

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
              result,
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
                  calculateFinalScore(itemId, score),
                  style: principalFont.medium(color: Colors.white),
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
