import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AvaliatonButton extends StatelessWidget {
  const AvaliatonButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 100,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AlternateHome()),
          );
        },
        child: Row(
          children: [
            const Icon(
              Icons.assignment,
              color: Colors.white,
              size: 50,
            ),
            const SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  'AVALIAÇÕES',
                  style:
                      principalFont.medium(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 5),
                Container(
                  width: 155,
                  height: 30,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Text(
                    'VEJA SEUS RESULTADOS',
                    style:
                        principalFont.medium(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
