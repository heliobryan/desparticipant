// ignore_for_file: deprecated_member_use

import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  Future<void> _launchURL() async {
    final url = Uri.parse('https://loja.flamengo.com.br/'); // URL para abrir
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url,
            mode: LaunchMode.externalApplication); // Abre a URL no navegador
      } else {
        throw 'Não foi possível abrir a URL';
      }
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao tentar abrir a URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: const Color(0XFFA6B92E),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app_rounded,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => const ExitButton(),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Colors.black,
                Color(0xFF42472B).withOpacity(0.5),
              ],
            ),
          ),
        ),
        title: Image.asset(
          Assets.homelogo,
          width: 250,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: IconButton(
                onPressed: _launchURL,
                icon: const Icon(
                  Icons.store_outlined,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
