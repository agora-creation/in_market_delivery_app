import 'package:flutter/material.dart';
import 'package:in_market_delivery_app/providers/auth.dart';
import 'package:in_market_delivery_app/widgets/custom_text_form_field2.dart';
import 'package:in_market_delivery_app/widgets/error_dialog.dart';
import 'package:in_market_delivery_app/widgets/round_button.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            '配達元の店舗の認証用コードを入力してください',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          CustomTextFormField2(
            controller: authProvider.codeController,
            labelText: '認証用コード',
            iconData: Icons.key,
          ),
          const SizedBox(height: 24),
          RoundButton(
            labelText: '認証する',
            labelColor: Colors.white,
            backgroundColor: Colors.green.shade400,
            onPressed: () async {
              String? errorText = await authProvider.updateShop();
              if (errorText != null) {
                showDialog(
                  context: context,
                  builder: (_) => ErrorDialog(
                    message: errorText,
                  ),
                );
                return;
              }
              authProvider.clearController();
              if (!mounted) return;
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }
}
