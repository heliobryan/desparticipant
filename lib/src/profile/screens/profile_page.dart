import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/profile/cards/card.dart';
import 'package:des/src/profile/graph/graph.dart';
import 'package:des/src/profile/services/profile_service.dart';
import 'package:des/src/profile/widgets/data_card.dart';
import 'package:des/src/profile/widgets/graphic_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final homeService = ProfileService();
  String? userName;
  String? userId;
  String? category;
  String? position;
  String? name;

  bool _isPlayerCardVisible = false;
  bool _isRadarGraphVisible = false;
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint("Inicializando ProfilePage...");
    loadUserData();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  // Função para carregar os dados do usuário
  Future<void> loadUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Verifica se os dados já estão salvos no SharedPreferences
    userName = sharedPreferences.getString('userName');
    userId = sharedPreferences.getString('userId');
    category = sharedPreferences.getString('category');
    position = sharedPreferences.getString('position');

    // Se os dados estiverem salvos, não faz a requisição novamente
    if (userName != null &&
        userId != null &&
        category != null &&
        position != null) {
      debugPrint("Dados encontrados no SharedPreferences.");
      setState(() {
        // Atualiza o estado com os dados salvos
      });
    } else {
      debugPrint(
          "Dados não encontrados no SharedPreferences, buscando na API...");
      String token = await homeService.loadToken();
      final responseData = await homeService.fetchParticipantDetails(token);

      if (responseData != null) {
        // Dados recebidos da API
        debugPrint("Dados recebidos no loadUserData: $responseData");

        final participant = responseData;
        final user = participant['user'] ?? {};

        setState(() {
          userName = user['name'] ?? 'Sem Nome';
          userId = user['id'] != null ? user['id'].toString() : 'Sem ID';
          category = participant['category'] ?? 'Sem Categoria';
          position = participant['position'] ?? 'Sem Posição';
        });

        // Salva as informações no SharedPreferences para futuras consultas
        await sharedPreferences.setString('userName', userName ?? '');
        await sharedPreferences.setString('userId', userId ?? '');
        await sharedPreferences.setString('category', category ?? '');
        await sharedPreferences.setString('position', position ?? '');
      } else {
        debugPrint("Falha ao obter os dados do participante.");
      }
    }
  }

  void togglePlayerCard() {
    debugPrint("Toggling Player Card...");
    if (_isPlayerCardVisible) {
      debugPrint("Escondendo Player Card");
      _controller.reverse().then((_) {
        setState(() {
          _isPlayerCardVisible = false;
        });
      });
    } else {
      debugPrint("Exibindo Player Card");
      setState(() {
        _isPlayerCardVisible = true;
      });
      _controller.forward();
    }
  }

  void toggleRadarGraph() {
    debugPrint("Toggling Radar Graph...");
    if (_isRadarGraphVisible) {
      debugPrint("Escondendo Radar Graph");
      _controller.reverse().then((_) {
        setState(() {
          _isRadarGraphVisible = false;
        });
      });
    } else {
      debugPrint("Exibindo Radar Graph");
      setState(() {
        _isRadarGraphVisible = true;
      });
      _controller.forward();
    }
  }

  @override
  void dispose() {
    debugPrint("Disposing ProfilePage...");
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Construindo a interface do usuário...");
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
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
      body: Stack(
        children: [
          Center(
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
                      Icons.account_circle_outlined,
                      size: 130,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  (userName ?? 'Carregando...').toUpperCase(),
                  style:
                      principalFont.medium(color: Colors.white, fontSize: 30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category ?? '',
                      style: principalFont.regular(
                          color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '-',
                      style: principalFont.regular(
                          color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      position ?? '',
                      style: principalFont.regular(
                          color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GrapichButton(onPressed: toggleRadarGraph),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: togglePlayerCard,
                      child: Text(
                        'CARD',
                        style: principalFont.medium(
                            color: Colors.white, fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const DataCard(),
                  ],
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
          if (_isPlayerCardVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: togglePlayerCard,
                child: Container(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: const PlayerCard(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (_isRadarGraphVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: toggleRadarGraph,
                child: Container(
                  color: const Color(0xFF121212),
                  child: Center(
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              color: const Color(0xFF121212),
                              child: const RadarGraph(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
