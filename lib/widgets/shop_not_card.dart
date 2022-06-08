import 'package:flutter/material.dart';
import 'package:in_market_delivery_app/providers/auth.dart';
import 'package:in_market_delivery_app/widgets/custom_text_button.dart';
import 'package:in_market_delivery_app/widgets/custom_text_form_field2.dart';
import 'package:in_market_delivery_app/widgets/round_button.dart';

class ShopNotCard extends StatelessWidget {
  final AuthProvider authProvider;

  const ShopNotCard({
    required this.authProvider,
    Key? key,
  }) : super(key: key);

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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => ShopSelectDialog(
                      authProvider: authProvider,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShopSelectDialog extends StatefulWidget {
  final AuthProvider authProvider;

  const ShopSelectDialog({
    required this.authProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<ShopSelectDialog> createState() => _ShopSelectDialogState();
}

class _ShopSelectDialogState extends State<ShopSelectDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            '配達元の店舗の認証用コードを入力してください',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          CustomTextFormField2(
            controller: TextEditingController(),
            labelText: '認証用コード',
            iconData: Icons.code,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextButton(
                labelText: '入力に戻る',
                backgroundColor: Colors.blue,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
