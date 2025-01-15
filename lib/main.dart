import 'package:flutter/material.dart';

void main() {
  runApp(const DesApp());
}

class DesApp extends StatefulWidget {
  const DesApp({super.key});

  @override
  State<DesApp> createState() => _DesAppState();
}

class _DesAppState extends State<DesApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp();
  }
}
