import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class GrapichButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GrapichButton({super.key, required this.onPressed});

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
        onPressed: onPressed,
        child: Text(
          'GRÁFICO',
          style: principalFont.medium(color: Colors.white, fontSize: 45),
        ),
      ),
    );
  }
}
