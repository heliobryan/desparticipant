// ignore_for_file: prefer_final_fields

import 'package:des/src/home/screens/home_screen.dart';
import 'package:des/src/rank/screens/rank_page.dart';
import 'package:des/src/marketplace/screens/market_page.dart';
import 'package:des/src/profile/screens/profile_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  late final List<Widget> _screens;

  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _screens = [
      const AlternateHome(),
      const RankPage(),
      const MarketPage(),
      const ProfilePage(
        evaluationName: '',
        result: '',
        finalScore: '',
        allEvaluations: [],
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics:
            const NeverScrollableScrollPhysics(), // Impede a navegação por swipe
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      backgroundColor: const Color(0xFF2A0C55),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 56,
      decoration: const BoxDecoration(),
      child: NavigationBarTheme(
        data: const NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontFamily: 'OUTFIT',
              color: Colors.white,
            ),
          ),
          iconTheme: WidgetStatePropertyAll(
            IconThemeData(
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        child: NavigationBar(
          backgroundColor: const Color(0xFF1E1E1E),
          onDestinationSelected: (int index) {
            _navigateToPage(index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.emoji_events),
              label: 'Ranking',
            ),
            NavigationDestination(
              icon: Icon(Icons.store),
              label: 'Loja',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }

  // Função para realizar a transição suave entre as telas
  void _navigateToPage(int index) {
    setState(() {
      currentPageIndex = index;
    });
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
