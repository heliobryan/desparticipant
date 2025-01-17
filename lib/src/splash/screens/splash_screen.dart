import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/login/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _opacity = 1.0;
    });

    await Future.delayed(const Duration(seconds: 3));
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (_, animation, secondaryAnimation) => const LoginScreen(),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          Center(
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Assets.logoDes,
                    width: 200,
                  ),
                  const SizedBox(height: 50),
                  SvgPicture.asset(
                    Assets.nameDes,
                    width: 270,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
