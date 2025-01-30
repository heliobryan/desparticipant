import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

class RadarGraph extends StatelessWidget {
  final List<List<double>> data; // Valores dos atributos
  final List<String> features; // Nomes dos atributos

  const RadarGraph({super.key, required this.data, required this.features});

  @override
  Widget build(BuildContext context) {
    // Verificar se o tamanho de features e o de valores em data estão compatíveis
    assert(features.length == data[0].length,
        'A quantidade de features deve ser igual à quantidade de valores em data.');

    // Debug opcional: Imprimir os pares atributo-valor no console
    for (int i = 0; i < features.length; i++) {
      debugPrint('${features[i]}: ${data[0][i]}');
    }

    return Center(
      child: SizedBox(
        height: 350,
        width: 500,
        child: RadarChart(
          ticks: const [60, 70, 80, 90, 100, 110],
          features: features,
          data: data,
          graphColors: const [Color(0xFFC0C0C0)], // Cor do gráfico
          outlineColor: Colors.white,
          axisColor: Colors.white,
          featuresTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontFamily: 'STRETCH',
            fontWeight: FontWeight.bold,
            height: 1,
          ),
          sides: features.length,
        ),
      ),
    );
  }
}
