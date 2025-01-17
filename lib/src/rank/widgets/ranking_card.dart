import 'package:flutter/material.dart';

class RankingCard extends StatefulWidget {
  const RankingCard({super.key});

  @override
  State<RankingCard> createState() => _RankingCardState();
}

class _RankingCardState extends State<RankingCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFCBA135),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF1E1E1E),
        ),
      ),
    );
  }
}
