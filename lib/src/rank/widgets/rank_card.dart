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
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: borderColor,
            width: 8,
          ),
          top: BorderSide(
            color: borderColor,
            width: 1,
          ),
          right: BorderSide(
            color: borderColor,
            width: 1,
          ),
          bottom: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
        color: Colors.white,
      ),
      width: 350,
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
                style: principalFont.bold(color: Colors.black, fontSize: 15),
              ),
              const SizedBox(height: 5),
              Icon(
                Icons.workspace_premium,
                size: 20,
                color: borderColor,
              ),
            ],
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(
              1,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0XFFb0c32e),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.account_circle_outlined,
              size: 60,
              color: Color(0xFFB0B0B0),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      name,
                      style: secondFont.bold(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '$position - $category',
                      style: principalFont.bold(
                        color: Colors.black,
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
                        color: Colors.black,
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
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: borderColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$score',
                  style: principalFont.bold(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
