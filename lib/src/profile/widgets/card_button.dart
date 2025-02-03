import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/profile/cards/card.dart';
import 'package:flutter/material.dart';

class CardButton extends StatefulWidget {
  const CardButton({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CardButtonState createState() => _CardButtonState();
}

class _CardButtonState extends State<CardButton> {
  bool _isCardVisible = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              setState(() {
                _isCardVisible = true;
              });
            },
            child: Text(
              'CARD',
              style: principalFont.medium(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
        if (_isCardVisible)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isCardVisible = false;
                });
              },
              child: Material(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isCardVisible
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              const PlayerCard(
                                key: Key('playerCard'),
                                agiValue: '',
                                pesoValue: '',
                                alturaValue: '',
                                finalValue: '',
                                embaixaValue: '',
                                passValue: '',
                                driValue: '',
                                userName: '',
                                position: '',
                                userImagePath: '',
                              ),
                              Positioned(
                                top: 20,
                                right: 20,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isCardVisible = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
