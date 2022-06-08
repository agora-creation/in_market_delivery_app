import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final String? labelText;
  final IconData? iconData;

  const CustomTextFormField({
    this.controller,
    this.obscureText,
    this.keyboardType,
    this.labelText,
    this.iconData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      maxLines: 1,
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 18,
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: labelText,
        fillColor: Colors.white,
        prefixIcon: iconData != null
            ? Icon(
                iconData,
                size: 24,
                color: Colors.black54,
              )
            : null,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(color: Colors.black54),
        focusColor: Colors.black54,
      ),
    );
  }
}
