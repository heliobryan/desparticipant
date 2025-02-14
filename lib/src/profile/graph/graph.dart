import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

class RadarGraph extends StatelessWidget {
  final List<List<double>> data;
  final List<String> features;

  const RadarGraph({super.key, required this.data, required this.features});

  @override
  Widget build(BuildContext context) {
    assert(features.length == data[0].length,
        'A quantidade de features deve ser igual à quantidade de valores em data.');

    for (int i = 0; i < features.length; i++) {
      debugPrint('${features[i]}: ${data[0][i]}');
    }

    return Center(
      child: SizedBox(
        height: 250,
        width: 250,
        child: RadarChart(
          ticks: const [60, 70, 80, 90, 100, 110],
          features: features,
          data: data,
          graphColors: const [Color(0xFFC0C0C0)],
          outlineColor: Colors.white,
          axisColor: Colors.white,
          featuresTextStyle: const TextStyle(
            color: Color.fromARGB(255, 252, 251, 251),
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
