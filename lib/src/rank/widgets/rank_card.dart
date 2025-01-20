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
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF3C3C3C), width: 2),
        color: const Color(0xFF2C2C2C),
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
                '1', //COLOCAÇÂO DELE
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
            Icons.account_circle_outlined, //FOTO DO PARTICIPANTE
            size: 60,
            color: Color(0xFFB0B0B0),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'RICARDO COSTA', //NOME DO ATLETA
                style: principalFont.bold(
                    color: const Color(0xFFB0B0B0), fontSize: 14),
              ),
              Text(
                'LATERAL DIREITO' + ' - ' + 'SUB 13', //POSIÇÃO E SUB DO ATLETA
                style: principalFont.bold(
                    color: const Color(0xFFB0B0B0), fontSize: 8),
              ),
              Text(
                'ESCOLA DO FLAMENGO', //INSTITUIÇÃO
                style: principalFont.bold(
                    color: const Color(0xFFB0B0B0), fontSize: 8),
              ),
            ],
          ),
          const SizedBox(width: 120),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0XffB0B0B0), width: 2),
                ),
                child: Center(
                  child: Text(
                    '99',
                    style: principalFont.bold(color: const Color(0XffB0B0B0)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
