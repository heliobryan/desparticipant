import 'dart:developer';

import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/profile/services/profile_service.dart';
import 'package:des/src/profile/widgets/card_button.dart';
import 'package:des/src/profile/widgets/data_card.dart';
import 'package:des/src/profile/widgets/graphic_button.dart';
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
  String? userId;
  String? category;
  String? position;

  @override
  void initState() {
    super.initState();
    log('Initializing ProfilePage...');
    loadUserData();
  }

  Future<void> loadUserData() async {
    log('Loading user data...');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    userName = sharedPreferences.getString('userName');
    userId = sharedPreferences.getString('userId');
    category = sharedPreferences.getString('category');
    position = sharedPreferences.getString('position');

    log('Retrieved from SharedPreferences: '
        'userName=$userName, userId=$userId, category=$category, position=$position');

    if (userName == null ||
        userId == null ||
        userName!.isEmpty ||
        userId!.isEmpty) {
      log('User name or ID is missing. Fetching from service...');
      String token = await homeService.loadToken();
      final userInfo = await homeService.userInfo(token);

      if (userInfo != null &&
          userInfo.containsKey('name') &&
          userInfo.containsKey('id')) {
        userName = userInfo['name'];
        userId = userInfo['id'].toString();
        log('Fetched user info: userName=$userName, userId=$userId');

        await sharedPreferences.setString('userName', userName!);
        await sharedPreferences.setString('userId', userId!);
        log('User info saved to SharedPreferences');
      }
    }

    if (category == null || position == null) {
      log('Category or position is missing. Fetching participant details...');
      String token = await homeService.loadToken();
      final participantDetails =
          await homeService.fetchParticipantDetails(token);

      if (participantDetails != null) {
        setState(() {
          category = participantDetails['category'];
          position = participantDetails['position'];
        });
        log('Fetched participant details: category=$category, position=$position');

        await sharedPreferences.setString('category', category!);
        await sharedPreferences.setString('position', position!);
        log('Participant details saved to SharedPreferences');
      }
    }

    log('User data load complete. Updating UI...');
    setState(() {});
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
                  width: 130,
                  height: 130,
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
                  size: 130,
                  color: Colors.white,
                ),
              ],
            ),
            Text(
              'ID: ${(userId ?? 'Carregando...')}',
              style: principalFont.regular(
                  color: Colors.transparent, fontSize: 18),
            ),
            Text(
              (userName ?? '').toUpperCase(),
              style: principalFont.medium(color: Colors.white, fontSize: 30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category ?? '',
                  style:
                      principalFont.regular(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(width: 5),
                Text(
                  '-',
                  style:
                      principalFont.regular(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(width: 5),
                Text(
                  position ?? '',
                  style:
                      principalFont.regular(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GrapichButton(),
                SizedBox(width: 10),
                CardButton(),
                SizedBox(width: 10),
                DataCard(),
              ],
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
