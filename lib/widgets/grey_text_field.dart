import 'package:flutter/material.dart';

class GreyTextField extends StatelessWidget {
  final String hint;
  final bool obscured, enabled;
  final TextEditingController controller;

  GreyTextField({
    @required this.controller,
    @required this.hint,
    @required this.obscured,
    @required this.enabled,
  });

  final _border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    borderSide: BorderSide(color: Colors.grey[300]),
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        disabledBorder: _border,
        border: _border,
        focusedBorder: _border,
        enabledBorder: _border,
        filled: true,
        fillColor: Colors.grey[100],
        hintText: hint,
      ),
      obscureText: obscured,
      controller: controller,
      enabled: enabled,
    );
  }
}
