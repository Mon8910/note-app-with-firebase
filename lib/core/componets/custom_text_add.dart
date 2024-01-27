import 'package:flutter/material.dart';

class CustomTextAdd extends StatelessWidget {
  const CustomTextAdd({super.key, required this.title, required this.controller, required this.validator});
  final String title;
  final TextEditingController controller;
 final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator:validator ,
      controller: controller,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          hintText: title,
          hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
          filled: true,
          fillColor: Colors.grey[200],
          border: outlineBorder(),
          enabledBorder: outlineBorder()),
    );
  }
}

OutlineInputBorder outlineBorder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.grey));
}
