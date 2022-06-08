import 'package:flutter/material.dart';

class LinkButton extends StatelessWidget {
  final String? labelText;
  final Function()? onTap;

  const LinkButton({
    this.labelText,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        labelText ?? '',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
