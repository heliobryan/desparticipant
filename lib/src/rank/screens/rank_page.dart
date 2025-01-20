import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/rank/widgets/filter_gender.dart';
import 'package:des/src/rank/widgets/filter_rank.dart';
import 'package:des/src/rank/widgets/rank_card.dart';

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
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Text(
              'FILTROS',
              style: principalFont.medium(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilterRank(),
                SizedBox(width: 10),
                FilterGender(),
              ],
            ),
            const SizedBox(height: 25),
            const RankCard(),
            const SizedBox(height: 5),
            const RankCard(),
            const SizedBox(height: 5),
            const RankCard(),
            const SizedBox(height: 5),
            const RankCard(),
            const SizedBox(height: 5),
            const RankCard(),
            const SizedBox(height: 5),
            const RankCard(),
            const SizedBox(height: 5),
            const RankCard(),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
