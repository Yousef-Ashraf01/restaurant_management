import 'package:flutter/material.dart';

class buildTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final String? hintText;
  final bool readOnly;

  const buildTextFormField({
    super.key,
    required this.controller,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      readOnly: readOnly,
      keyboardType: keyboardType,
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
