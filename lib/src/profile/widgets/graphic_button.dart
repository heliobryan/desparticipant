import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class GrapichButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GrapichButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        'GRÁFICO',
        style: principalFont.medium(color: Colors.white, fontSize: 15),
      ),
    );
  }
}
