import 'package:flutter/material.dart';

class FilterGender extends StatefulWidget {
  const FilterGender({super.key});

  @override
  State<FilterGender> createState() => _FilterGenderState();
}

class _FilterGenderState extends State<FilterGender> {
  bool isHomem = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0XffB0B0B0),
        ),
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.transparent),
        ),
        child: Icon(
          isHomem ? Icons.male : Icons.female,
          size: 40,
          color: const Color(0XffB0B0B0),
        ),
        onPressed: () {
          setState(() {
            isHomem = !isHomem;
          });
        },
      ),
    );
  }
}
