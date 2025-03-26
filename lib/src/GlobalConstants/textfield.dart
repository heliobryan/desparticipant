// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

InputDecoration emailAuthDecoration(String label) {
  return InputDecoration(
    hintText: label,
    fillColor: Color(0xFF282E36).withOpacity(0.5),
    filled: true,
    contentPadding: const EdgeInsets.all(12),
    prefixIcon: const Icon(
      Icons.account_circle_outlined,
      color: Color(0XFFb0c32e),
    ),
    hintStyle: const TextStyle(
      color: Color(0xFF666F7B),
      fontFamily: 'OUTFIT',
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0XFFb0c32e),
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xFFAD0000),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xFFAD0000),
      ),
    ),
  );
}
