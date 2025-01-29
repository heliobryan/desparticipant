import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class DadosUser extends StatelessWidget {
  const DadosUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'DADOS BIOLÓGICOS',
            style: principalFont.medium(color: Colors.white, fontSize: 22),
          ),
          const SizedBox(height: 30),
          Text(
            'PESO: 50 KG', // PESO
            style: principalFont.medium(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 20),
          Text(
            'ALTURA: 150 CM', // ALTURA
            style: principalFont.medium(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 20),
          Text(
            'IDADE: 13', // IDADE
            style: principalFont.medium(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 20),
          Text(
            'IMC: 20', // IMC
            style: principalFont.medium(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
