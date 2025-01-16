import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/splash/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExitButton extends StatefulWidget {
  const ExitButton({super.key});

  @override
  State<ExitButton> createState() => _ExitButtonState();
}

class _ExitButtonState extends State<ExitButton> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Tem certeza que deseja sair?',
        style: principalFont.bold(color: Colors.white, fontSize: 20),
      ),
      actions: <Widget>[
        Row(
          children: [
            SizedBox(
              width: 127,
              height: 31,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: const Color(0xFF0F76CE),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Não',
                  style: principalFont.bold(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 127,
              height: 31,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: const Color(0xFF981DB9),
                ),
                onPressed: () async {
                  bool exit = await exitVerify();
                  if (exit) {
                    Navigator.pushReplacement(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SplashScreen(),
                      ),
                    );
                  }
                },
                child: Text(
                  'Sim',
                  style: principalFont.bold(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

Future<bool> exitVerify() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.clear();
  return true;
}
