import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_market_delivery_app/helpers/style.dart';
import 'package:in_market_delivery_app/widgets/loading.dart';
import 'package:in_market_delivery_app/widgets/login_title.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: double.infinity,
            decoration: loginDecoration,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  LoginTitle(),
                  Loading(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
