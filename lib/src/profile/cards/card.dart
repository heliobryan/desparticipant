import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class PlayerCard extends StatefulWidget {
  const PlayerCard({super.key});

  @override
  State<PlayerCard> createState() => _PlayerCardstate();
}

class _PlayerCardstate extends State<PlayerCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFCBA135),
            Color(0xFF1E1E1E),
            Color(0xFF1E1E1E),
          ],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.amber.withOpacity(0.5),
            spreadRadius: -8,
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.amber.withOpacity(0.3),
            spreadRadius: 12,
            blurRadius: 25,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      width: 350,
      height: 500,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFCBA135),
              width: 1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(46)),
          ),
          width: 342,
          height: 492,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons
                              .account_circle_outlined, // FUTURAMENTE FOTO DO PARTICIPANTE
                          size: 190,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '70', //OVERALL
                          style: principalFont.medium(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'ATA', //POSIÇÃO
                          style: principalFont.medium(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Icon(
                          //ESCUDO TIME
                          Icons.shield,
                          color: Colors.white,
                          size: 50,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('RICARDO', //NOME DO PARTICIPANTE
                        style: principalFont.bold(
                            color: Colors.white, fontSize: 25)),
                    const SizedBox(height: 15),
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '80 RIT', //RITMO
                          style: principalFont.medium(
                              color: Colors.white, fontSize: 25),
                        ),
                        Text(
                          '80 FIN', //FINALIZAÇÃO
                          style: principalFont.medium(
                              color: Colors.white, fontSize: 25),
                        ),
                        Text(
                          '80 RIT', //PASSE
                          style: principalFont.medium(
                              color: Colors.white, fontSize: 25),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '80 DRI', //DRIBLE
                          style: principalFont.medium(
                              color: Colors.white, fontSize: 25),
                        ),
                        Text(
                          '80 AGI', //AGILIDADE
                          style: principalFont.medium(
                              color: Colors.white, fontSize: 25),
                        ),
                        Text(
                          '80 FÍS', //FISICO
                          style: principalFont.medium(
                              color: Colors.white, fontSize: 25),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
