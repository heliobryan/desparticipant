import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/home/services/home_services.dart';
import 'package:des/src/rank/services/rankservice.dart';
import 'package:flutter/material.dart';
import 'package:des/src/home/services/home_services.dart';
import '../../home/services/home_services.dart';

class RankCard extends StatelessWidget {
  final home.Participant participant; // Ajustando para o tipo correto

  const RankCard({super.key, required this.participant});

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
                      participant.user.name, // Usando o nome do participante
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
                      '${participant.position} - ${participant.category}', // Exibindo posição e categoria
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
                      participant.team.name, // Exibindo time
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
                  participant.overall?.toString() ??
                      '0', // Exibindo a pontuação
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
