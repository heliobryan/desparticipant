import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

class RadarGraph extends StatelessWidget {
  const RadarGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 350,
        width: 500,
        child: RadarChart(
          ticks: [20, 40, 60, 80, 100],
          features: [
            'Físico', //FÍS
            'Ritmo', //RIT
            'Finalização', //FIN
            'Passe', //PAS
            'Agilidade', //AGI
            'Drible', //DRI
          ],
          data: [
            [50, 70, 60, 80, 90, 60],
          ],
          graphColors: [Color(0xFFC0C0C0)],
          outlineColor: Colors.white,
          axisColor: Colors.white,
          featuresTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontFamily: 'STRETCH',
            fontWeight: FontWeight.bold,
            height: 1,
          ),
          sides: 6,
        ),
      ),
    );
  }
}
