import 'package:des/src/home/screens/home_screen.dart';
import 'package:des/src/manage/screens/manage_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _screens = [
      const AlternateHome(),
      const ManagePage(),
      const MarketPage(),
      const ProfilePage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[currentPageIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
      backgroundColor: const Color(0xFF1E1E1E),
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
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.sports_soccer),
              label: 'Gestão',
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
}
