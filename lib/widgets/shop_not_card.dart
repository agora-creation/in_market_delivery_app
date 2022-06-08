import 'package:flutter/material.dart';
import 'package:in_market_delivery_app/widgets/round_button.dart';

class ShopNotCard extends StatelessWidget {
  final Function()? onPressed;

  const ShopNotCard({this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 3,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '配達する元の店舗をこのアプリに設定してください。',
                style: TextStyle(fontSize: 18),
              ),
              const Text(
                '設定できる店舗は一つだけです。',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 32),
              RoundButton(
                labelText: '配達元を設定する',
                labelColor: Colors.white,
                backgroundColor: Colors.green.shade400,
                onPressed: onPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
