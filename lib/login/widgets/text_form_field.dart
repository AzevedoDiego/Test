import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(String) onChanged;
  const CustomTextFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0XFFF8F8FA),
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0XFF494A57),
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
    );
  }
}
