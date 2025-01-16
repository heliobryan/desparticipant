import 'package:flutter/material.dart';

InputDecoration emailAuthDecoration(String label) {
  return InputDecoration(
    hintText: label,
    fillColor: const Color(0xFF282E36),
    filled: true,
    contentPadding: const EdgeInsets.all(12),
    prefixIcon: const Icon(
      Icons.account_circle_outlined,
      color: Color(0xFF484D54),
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
        color: Color(0xFF464C54),
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
