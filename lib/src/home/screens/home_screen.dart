import 'dart:convert';
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/GlobalWidgets/gradient.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AlternateHome extends StatefulWidget {
  const AlternateHome({
    super.key,
  });

  @override
  State<AlternateHome> createState() => _AlternateHomeState();
}

class _AlternateHomeState extends State<AlternateHome> {
  Map<String, dynamic> userDados = {};
  String? token;

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => const ExitButton(),
            ),
          ),
        ],
        title: Text(
          'BEM VINDO ${(userDados['name'] ?? '').toUpperCase() + '!'}',
          style: principalFont.bold(color: Colors.white, fontSize: 25),
        ),
      ),
      backgroundColor: const Color(0xFF1E1E1E),
      body: const Stack(
        children: [
          GradientBack(),
        ],
      ),
    );
  }

  Future<void> loadToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferences.getString('token');
    });
    userInfo();
  }

  Future<void> userInfo() async {
    if (token == null) return;

    try {
      var url = Uri.parse('https://api.des.versatecnologia.com.br/api/user');
      var restAnswer = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (restAnswer.statusCode == 200) {
        final decode = jsonDecode(restAnswer.body);
        setState(() {
          userDados = decode;
        });
      }
    } catch (e) {
      print("Erro ao recuperar informações do usuário: $e");
    }
  }
}
