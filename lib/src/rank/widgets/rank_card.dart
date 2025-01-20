import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class RankCard extends StatefulWidget {
  const RankCard({super.key});

  @override
  State<RankCard> createState() => _RankCardState();
}

class _RankCardState extends State<RankCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Color(0xFFFFD700), width: 4),
          top: BorderSide(color: Color(0xFF3C3C3C), width: 2),
          right: BorderSide(color: Color(0xFF3C3C3C), width: 2),
          bottom: BorderSide(color: Color(0xFF3C3C3C), width: 2),
        ),
        color: Color(0xFF2C2C2C),
      ),
      width: 410,
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                '1', // COLOCAÇÃO
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
            Icons.account_circle_outlined, // FOTO DO PARTICIPANTE
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
                      'RICARDO COSTA', // NOME DO ATLETA
                      style: principalFont.bold(
                        color: const Color(0xFFB0B0B0),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'LATERAL DIREITO - SUB 13', // POSIÇÃO E SUB
                      style: principalFont.bold(
                        color: const Color(0xFFB0B0B0),
                        fontSize: 8,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ESCOLA DO FLAMENGO', // INSTITUIÇÃO
                      style: principalFont.bold(
                        color: const Color(0xFFB0B0B0),
                        fontSize: 8,
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
                border: Border.all(color: const Color(0XffB0B0B0), width: 2),
              ),
              child: Center(
                child: Text(
                  '99', // PONTUAÇÃO, OVERALL
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
