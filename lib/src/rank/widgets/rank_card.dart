import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class RankCard extends StatelessWidget {
  final String name;
  final String position;
  final String team;
  final int ranking;
  final int score;
  final String category;
  final Color borderColor;

  const RankCard({
    super.key,
    required this.name,
    required this.position,
    required this.team,
    required this.ranking,
    required this.score,
    required this.category,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: borderColor,
            width: 4,
          ),
          top: const BorderSide(color: Color(0xFF3C3C3C), width: 2),
          right: const BorderSide(color: Color(0XFFb0c32e), width: 1),
          bottom: const BorderSide(color: Color(0xFF3C3C3C), width: 2),
        ),
        color: const Color(0xFF2C2C2C),
      ),
      width: 410,
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                '$ranking',
                style: principalFont.bold(color: const Color(0xFFB0B0B0)),
              ),
              const SizedBox(height: 5),
              const Icon(
                Icons.workspace_premium,
                size: 20,
                color: Color(0xFFB0B0B0),
              ),
            ],
          ),
          const SizedBox(width: 5),
          const Icon(
            Icons.account_circle_outlined,
            size: 60,
            color: Color(0xFFB0B0B0),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      name,
                      style: principalFont.bold(
                        color: const Color(0xFFB0B0B0),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '$position - $category',
                      style: principalFont.bold(
                        color: const Color(0xFFB0B0B0),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      team,
                      style: principalFont.bold(
                        color: const Color(0xFFB0B0B0),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0XFFb0c32e), width: 2),
              ),
              child: Center(
                child: Text(
                  '$score',
                  style: principalFont.bold(color: const Color(0XffB0B0B0)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
