import 'dart:developer';

import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/home/services/home_services.dart';
import 'package:flutter/material.dart';

class AvaliationView extends StatelessWidget {
  final String evaluationName;
  final String result;
  final String finalScore;

  const AvaliationView({
    super.key,
    required this.evaluationName,
    required this.result,
    required this.finalScore,
  });

  @override
  Widget build(BuildContext context) {
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
                  finalScore,
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
