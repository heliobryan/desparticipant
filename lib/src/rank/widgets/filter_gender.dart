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
      width: 150,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border.all(
          color: const Color(0XFFb0c32e),
        ),
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.transparent),
        ),
        child: Icon(
          isHomem ? Icons.male : Icons.female,
          size: 40,
          color: const Color(0XFFb0c32e),
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
