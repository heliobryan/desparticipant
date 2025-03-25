import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AvaliatonButton extends StatelessWidget {
  const AvaliatonButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.2),
      width: MediaQuery.of(context).size.width * 0.85, // Largura ajustada
      height: MediaQuery.of(context).size.height * 0.085,

      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color(0XFFA6B92E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AlternateHome()),
          );
        },
        child: Row(
          children: [
            Icon(
              Icons.assignment,
              color: Color(0XFFA6B92E),
              size: MediaQuery.of(context).size.width * 0.12, // Ícone ajustado
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
                    'Avaliações',
                    style: principalFont.medium(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width *
                          0.05, // Tamanho ajustado para o título
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.005), // Espaçamento ajustado
                  Text(
                    'Veja suas avaliações',
                    style: secondFont.medium(
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
    );
  }
}
