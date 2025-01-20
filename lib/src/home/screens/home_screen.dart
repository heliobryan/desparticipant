import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/home/services/home_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlternateHome extends StatefulWidget {
  const AlternateHome({
    super.key,
  });

  @override
  State<AlternateHome> createState() => _AlternateHomeState();
}

class _AlternateHomeState extends State<AlternateHome> {
  final homeService = HomeServices();

  Map<String, dynamic> userDados = {};
  String? token;
  String? userName;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    final loadtoken = await homeService.loadToken();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userName = sharedPreferences.getString('userName');

    setState(() {
      token = loadtoken;

      if (userName == null) {
        homeService.userInfo(loadtoken).then((userInfo) {
          setState(() {
            userDados = userInfo!;
            userName = userDados['name'];
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
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
          'BEM VINDO ${userName?.toUpperCase() ?? ''}!',
          style: principalFont.bold(color: Colors.white, fontSize: 25),
        ),
      ),
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'AVALIAÇÕES',
              style: principalFont.medium(color: Colors.white, fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}
