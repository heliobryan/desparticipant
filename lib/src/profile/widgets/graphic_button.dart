import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class GrapichButton extends StatelessWidget {
  const GrapichButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {},
        child: Text(
          'GRÁFICO',
          style: principalFont.medium(color: Colors.white, fontSize: 15),
        ));
  }
}
