// ignore_for_file: deprecated_member_use, unused_field
import 'dart:developer';
import 'dart:io';
import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/home/screens/home_screen.dart';
import 'package:des/src/profile/cards/card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsPage extends StatefulWidget {
  final String agiValue;
  final String pesoValue;
  final String alturaValue;
  final String finalValue;
  final String final2Value;
  final String embaixaValue;
  final String passValue;
  final String driValue;
  final String userName;
  final String position;
  final String userImagePath;
  final String passValue2;

  const StatsPage(
      {super.key,
      required this.agiValue,
      required this.pesoValue,
      required this.alturaValue,
      required this.finalValue,
      required this.final2Value,
      required this.embaixaValue,
      required this.passValue,
      required this.driValue,
      required this.userName,
      required this.position,
      required this.userImagePath,
      required this.passValue2});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadImageFromPreferences();
    loadImageFromSharedPreferences();
  }

  Future<String> loadImageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final base64Image = prefs.getString('user_image_base64') ?? '';
    return base64Image;
  }

  XFile? _image;

  void _loadImageFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('user_image_path');
    if (imagePath != null) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  Future<void> loadImageFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedImagePath = prefs.getString('userImagePath');

    if (savedImagePath != null) {
      setState(() {
        _image = XFile(savedImagePath);
      });
    } else {
      log("Nenhuma imagem salva encontrada.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: const Color(0XFFA6B92E),
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: IconButton(
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
                Colors.black,
                const Color(0xFF42472B).withOpacity(0.5),
              ],
            ),
          ),
        ),
        title: Image.asset(
          Assets.homelogo,
          width: 250,
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.background),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 150),
                    CustomPaint(
                      size: Size(250, 50),
                      painter: TitleVetor('CARD'),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                PlayerCard(
                    agiValue: widget.agiValue,
                    pesoValue: widget.pesoValue,
                    alturaValue: widget.alturaValue,
                    finalValue: widget.finalValue,
                    embaixaValue: widget.embaixaValue,
                    passValue: widget.passValue,
                    driValue: widget.driValue,
                    userName: widget.userName,
                    position: widget.position,
                    userImagePath: widget.userImagePath,
                    passValue2: widget.passValue2,
                    final2Value: widget.final2Value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
