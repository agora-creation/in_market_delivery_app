import 'package:flutter/material.dart';

class LoginTitle extends StatelessWidget {
  const LoginTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'InMarket',
          style: TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceHanSans-Bold',
            letterSpacing: 1,
          ),
        ),
        Text(
          '- 配達者用 -',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
