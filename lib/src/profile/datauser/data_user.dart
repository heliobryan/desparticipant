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

    String nivelIMC() {
      if (imc < 18.5) {
        return "Abaixo do peso";
      } else if (imc >= 18.5 && imc < 24.9) {
        return "Peso normal";
      } else if (imc >= 25 && imc < 29.9) {
        return "Sobrepeso";
      } else if (imc >= 30 && imc < 34.9) {
        return "Obesidade Grau I";
      } else if (imc >= 35 && imc < 39.9) {
        return "Obesidade Grau II";
      } else {
        return "Obesidade Grau III";
      }
    }

    double fontSize = MediaQuery.of(context).size.width * 0.05;
    double cardWidth = MediaQuery.of(context).size.width * 0.8;
    double cardHeight =
        MediaQuery.of(context).size.height * 0.5; // Aumentei um pouco a altura

    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 48, 47, 47),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.fromBorderSide(BorderSide(
          color: Color(0XFFb0c32e),
        )),
      ),
      child: SingleChildScrollView(
        // Evita overflow
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: onClose,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'DADOS BIOLÓGICOS',
              style:
                  principalFont.medium(color: Colors.white, fontSize: fontSize),
            ),
            const SizedBox(height: 30),
            Text(
              'PESO: $altura KG',
              style:
                  principalFont.medium(color: Colors.white, fontSize: fontSize),
            ),
            const SizedBox(height: 20),
            Text(
              'ALTURA: $peso CM',
              style:
                  principalFont.medium(color: Colors.white, fontSize: fontSize),
            ),
            const SizedBox(height: 20),
            Text(
              'IMC: ${imc.toStringAsFixed(2)}',
              style:
                  principalFont.medium(color: Colors.white, fontSize: fontSize),
            ),
            const SizedBox(height: 20),
            Text(
              'Classificação:',
              style:
                  principalFont.medium(color: Colors.white, fontSize: fontSize),
            ),
            const SizedBox(height: 5),
            Text(
              nivelIMC(),
              style:
                  principalFont.medium(color: Colors.white, fontSize: fontSize),
            ),
          ],
        ),
      ),
    );
  }
}
