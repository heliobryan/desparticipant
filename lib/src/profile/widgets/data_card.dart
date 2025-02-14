import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class DataCard extends StatelessWidget {
  final VoidCallback onPressed;
  const DataCard({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: 300,
            height: 100,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onPressed,
              child: Row(
                children: [
                  const Icon(
                    Icons.analytics,
                    color: Colors.white,
                    size: 50,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'DADOS',
                        style: principalFont.medium(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ),
                      Container(
                        width: 145,
                        height: 30,
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Text(
                          'ALTURA, PESO E IMC',
                          style: principalFont.medium(
                              color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
