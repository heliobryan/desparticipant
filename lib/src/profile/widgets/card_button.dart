import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton({super.key});

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
          'CARD',
          style: principalFont.medium(color: Colors.white, fontSize: 15),
        ));
  }
}
