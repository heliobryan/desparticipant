import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class DataCard extends StatelessWidget {
  final VoidCallback onPressed;
  const DataCard({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            width: MediaQuery.of(context).size.width * 0.75, // Largura ajustada
            height:
                MediaQuery.of(context).size.height * 0.12, // Altura ajustada
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0XFFb0c32e)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onPressed,
              child: Row(
                children: [
                  Icon(
                    Icons.analytics,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.width *
                        0.12, // Ícone ajustado
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.05), // Espaçamento entre ícone e texto
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Alinhamento à esquerda
                      children: [
                        Text(
                          'DADOS',
                          style: principalFont.medium(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width *
                                0.07, // Tamanho ajustado para o título
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height *
                                0.005), // Espaçamento ajustado
                        Text(
                          'ALTURA, PESO E IMC',
                          style: principalFont.medium(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width *
                                0.03, // Tamanho menor para o subtítulo
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
