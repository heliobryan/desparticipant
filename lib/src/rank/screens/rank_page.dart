import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/profile/datauser/data_user.dart';
import 'package:des/src/rank/widgets/ranking_card.dart';
import 'package:flutter/material.dart';

class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'RANKING',
          style: principalFont.medium(color: Colors.white, fontSize: 20),
        ),
      ),
      backgroundColor: const Color(0xFF4A4A4A),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RankingCard(),
          ],
        ),
      ),
    );
  }
}
