import 'package:flutter/material.dart';

class CenterText extends StatelessWidget {
  final String? label;

  const CenterText({this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label ?? '',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'SourceHanSans-Bold',
        ),
      ),
    );
  }
}
