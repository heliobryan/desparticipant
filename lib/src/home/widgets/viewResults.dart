import 'package:des/src/profile/screens/profile_page.dart';
import 'package:flutter/material.dart';

class ViewResults extends StatelessWidget {
  final String evaluationName;
  final String result;
  final String finalScore;

  const ViewResults({
    super.key,
    required this.evaluationName,
    required this.result,
    required this.finalScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.transparent),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                evaluationName: evaluationName,
                result: result,
                finalScore: finalScore,
              ),
            ),
          );
        },
        child: const Center(
          child: Text(
            'VER RESULTADO DAS AVALIAÇÕES',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
