import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class DadosUser extends StatelessWidget {
  final String peso;
  final String altura;
  final VoidCallback onClose;

  const DadosUser({
    super.key,
    required this.peso,
    required this.altura,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    double pesoDouble = double.tryParse(peso) ?? 0;
    double alturaDouble = double.tryParse(altura) ?? 0;

    double imc = (alturaDouble > 0)
        ? alturaDouble / ((pesoDouble / 100) * (pesoDouble / 100))
        : 0;

    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: onClose,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'DADOS BIOLÓGICOS',
            style: principalFont.medium(color: Colors.white, fontSize: 22),
          ),
          const SizedBox(height: 30),
          Text(
            'PESO: $peso KG',
            style: principalFont.medium(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 20),
          Text(
            'ALTURA: $altura CM',
            style: principalFont.medium(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 20),
          Text(
            'IMC: ${imc.toStringAsFixed(2)}', // IMC com 2 casas decimais
            style: principalFont.medium(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
