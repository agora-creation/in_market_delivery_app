import 'package:flutter/material.dart';

class IconLabel extends StatelessWidget {
  final IconData? iconData;
  final String? labelText;

  const IconLabel({
    this.iconData,
    this.labelText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconData, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Text(
          labelText ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
