// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';

import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatauserPage extends StatefulWidget {
  final String peso;
  final String altura;
  final String userImagePath;
  final String? username;

  const DatauserPage({
    super.key,
    required this.peso,
    required this.altura,
    required this.userImagePath,
    required this.username,
  });

  @override
  State<DatauserPage> createState() => _DatauserPageState();
}

class _DatauserPageState extends State<DatauserPage> {
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
    double pesoDouble = double.tryParse(widget.peso) ?? 0;
    double alturaDouble = double.tryParse(widget.altura) ?? 0;

    double imc = (alturaDouble > 0)
        ? alturaDouble / ((pesoDouble / 100) * (pesoDouble / 100))
        : 0;

    String nivelIMC() {
      if (imc < 18.5) {
        return "Abaixo do peso";
      } else if (imc >= 18.5 && imc < 24.9) {
        return "Peso normal";
      } else if (imc >= 25 && imc < 29.9) {
        return "Sobrepeso";
      } else if (imc >= 30 && imc < 34.9) {
        return "Obesidade Grau I";
      } else if (imc >= 35 && imc < 39.9) {
        return "Obesidade Grau II";
      } else {
        return "Obesidade Grau III";
      }
    }

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
                CustomPaint(
                  size: Size(350, 50),
                  painter: TitleVetor('DADOS BIOLÓGICOS'),
                ),
                SizedBox(height: 40),
                Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: const Color(0XFFb0c32e)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Cabeçalho com cor diferente
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0XFFb0c32e), // Cor do cabeçalho
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        child: Center(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                              ),
                              child: GestureDetector(
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundImage: _image == null
                                      ? null
                                      : FileImage(File(_image!.path)),
                                  backgroundColor: Colors.transparent,
                                  child: _image == null
                                      ? const Center(
                                          child: Icon(
                                            Icons.account_circle_outlined,
                                            size: 160,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Text(
                              (widget.username ?? 'Carregando...')
                                  .toUpperCase(),
                              style: secondFont.medium(
                                  color: Colors.white, fontSize: 30),
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 2,
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                            ),
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Peso',
                                      style: principalFont.bold(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    Text(
                                      '${widget.altura} KG',
                                      style: secondFont.bold(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 50),
                                Column(
                                  children: [
                                    Text(
                                      'Altura',
                                      style: principalFont.bold(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    Text(
                                      '${widget.peso} CM',
                                      style: secondFont.bold(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 50),
                                Column(
                                  children: [
                                    Text(
                                      'IMC',
                                      style: principalFont.bold(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    Text(
                                      imc.toStringAsFixed(2),
                                      style: secondFont.bold(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Container(
                              height: 2,
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                            ),
                            SizedBox(height: 40),
                            Text(
                              'Classificação',
                              style: principalFont.bold(
                                  color: Colors.white, fontSize: 25),
                            ),
                            SizedBox(height: 10),
                            Text(
                              nivelIMC(),
                              style: secondFont.bold(
                                  color: Colors.white, fontSize: 20),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
