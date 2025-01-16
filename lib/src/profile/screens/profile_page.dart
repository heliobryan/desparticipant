import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/profile/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final homeService = ProfileService();
  String? userName;

  Map<String, dynamic> userDados = {};

  String? token;

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
      backgroundColor: const Color(0xFF4A4A4A),
      appBar: AppBar(
        centerTitle: true,
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
          'PERFIL',
          style: principalFont.medium(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
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
                      .account_circle_outlined, //FUTURAMENTE FOTO DO PARTICIPANTE
                  size: 150,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '$userName'.toUpperCase(),
              style: principalFont.medium(color: Colors.white, fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
