// ignore_for_file: prefer_final_fields
import 'package:des/src/profile/screens/datauser_page.dart';
import 'package:des/src/profile/screens/profile_page.dart';
import 'package:des/src/rank/screens/rank_page.dart';
import 'package:des/src/marketplace/screens/market_page.dart';
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
      const ProfilePage(
          evaluationName: '', result: '', finalScore: '', allEvaluations: []),
      const RankPage(),
      const MarketPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      backgroundColor: Color(0XFFA6B92E),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 75,
      decoration: const BoxDecoration(),
      child: Row(
        children: [
          _buildExpandedSquareButton(
            icon: Icons.account_circle_outlined,
            label: 'Perfil',
            isSelected: currentPageIndex == 0,
            onTap: () => _navigateToPage(0),
          ),
          _buildVerticalDivider(),
          _buildExpandedSquareButton(
            icon: Icons.emoji_events,
            label: 'Ranking',
            isSelected: currentPageIndex == 1,
            onTap: () => _navigateToPage(1),
          ),
          _buildVerticalDivider(),
          _buildExpandedSquareButton(
            icon: Icons.store,
            label: 'Loja',
            isSelected: currentPageIndex == 2,
            onTap: () => _navigateToPage(2),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedSquareButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints
              .expand(), // Expande para ocupar todo o espaço
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : const Color(0XFFA6B92E),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.black,
                size: 45,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OUTFIT',
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 2, // Largura da linha
      color: Colors.black,
      margin: const EdgeInsets.symmetric(vertical: 0),
    );
  }

  void _navigateToPage(int index) {
    setState(() {
      currentPageIndex = index;
    });
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
