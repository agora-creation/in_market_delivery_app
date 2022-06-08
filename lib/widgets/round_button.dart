import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String? labelText;
  final Color? labelColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Function()? onPressed;

  const RoundButton({
    this.labelText,
    this.labelColor,
    this.backgroundColor,
    this.borderColor,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        side: borderColor != null
            ? BorderSide(color: borderColor ?? const Color(0xFF000000))
            : null,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
      child: Text(
        labelText ?? '',
        style: TextStyle(
          color: labelColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'SourceHanSans-Bold',
        ),
      ),
    );
  }
}
