import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/rank/services/rankservice.dart';
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
  late Future<List<Participant>> participants;

  @override
  void initState() {
    super.initState();
    participants = _loadParticipants();
  }

  Future<List<Participant>> _loadParticipants() async {
    final homeServices = HomeServices(); // Create an instance of HomeServices
    final token = await homeServices
        .loadToken(); // Call the loadToken method on the instance
  }

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
      body: FutureBuilder<List<Participant>>(
        future: participants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum participante encontrado.'));
          }

          final participantList = snapshot.data!;
          return ListView.builder(
            itemCount: participantList.length,
            itemBuilder: (context, index) {
              final participant = participantList[index];
              return RankCard(participant: participant);
            },
          );
        },
      ),
    );
  }
}
