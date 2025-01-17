// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unused_local_variable, avoid_print
import 'package:des/src/home/screens/home_controller.dart';
import 'package:des/src/login/services/login_service.dart';
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalConstants/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showPass = true;
  bool isLoading = false;

  late AnimationController _controller;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _logoSlide;
  late Animation<double> _formOpacity;
  late Animation<Offset> _formSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5)),
    );
    _logoSlide =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5)),
    );

    _formOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
    );
    _formSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Fecha o teclado
    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });

    // Simulação do processo de login
    bool success = await userLogin(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login bem-sucedido!')),
      );

      // Animação de saída
      await _controller.reverse();

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0); // Começa fora da tela
            const end = Offset.zero; // Fim da transição
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var fadeTween = Tween<double>(begin: 0.0, end: 1.0);

            var offsetAnimation = animation.drive(tween);
            var fadeAnimation = animation.drive(fadeTween);

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 700),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login falhou. Tente novamente!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 80),
                SlideTransition(
                  position: _logoSlide,
                  child: FadeTransition(
                    opacity: _logoOpacity,
                    child: SvgPicture.asset(Assets.logoDes),
                  ),
                ),
                const SizedBox(height: 80),
                FadeTransition(
                  opacity: _formOpacity,
                  child: SlideTransition(
                    position: _formSlide,
                    child: Text(
                      'FAÇA SEU LOGIN',
                      style: principalFont.bold(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      children: [
                        FadeTransition(
                          opacity: _formOpacity,
                          child: SlideTransition(
                            position: _formSlide,
                            child: TextFormField(
                              controller: _emailController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'OUTFIT',
                                fontWeight: FontWeight.bold,
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email Inválido';
                                }
                                if (value.length < 5) {
                                  return 'Email muito curto';
                                }
                                if (!value.contains('@')) {
                                  return 'Email Inválido';
                                }
                                if (!value.contains('.com')) {
                                  return 'Email Inválido';
                                }
                                return null;
                              },
                              decoration: emailAuthDecoration('USUÁRIO'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeTransition(
                          opacity: _formOpacity,
                          child: SlideTransition(
                            position: _formSlide,
                            child: TextFormField(
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'OUTFIT',
                                fontWeight: FontWeight.bold,
                              ),
                              controller: _passwordController,
                              obscureText: showPass,
                              validator: (String? pass) {
                                if (pass == null || pass.isEmpty) {
                                  return 'Senha Inválida';
                                }
                                if (pass.length < 5) {
                                  return 'Senha muito curta';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'SENHA',
                                fillColor: const Color(0xFF282E36),
                                filled: true,
                                contentPadding: const EdgeInsets.all(12),
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Color(0xFF484D54),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    showPass
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: const Color(0xFF484D54),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showPass = !showPass;
                                    });
                                  },
                                ),
                                hintStyle: const TextStyle(
                                  color: Color(0xFF666F7B),
                                  fontFamily: 'OUTFIT',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF464C54),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeTransition(
                          opacity: _formOpacity,
                          child: SlideTransition(
                            position: _formSlide,
                            child: SizedBox(
                              width: 300,
                              height: 50,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Color(0xFF464C54)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  backgroundColor: const Color(0xFF282E36),
                                ),
                                onPressed: _handleLogin,
                                child: isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        'ENTRAR',
                                        style: principalFont.medium(
                                            color: Colors.white, fontSize: 20),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
