import 'package:flutter/material.dart';
import 'package:in_market_delivery_app/helpers/functions.dart';
import 'package:in_market_delivery_app/models/delivery.dart';
import 'package:in_market_delivery_app/providers/auth.dart';
import 'package:in_market_delivery_app/screens/login.dart';
import 'package:in_market_delivery_app/screens/setting_email.dart';
import 'package:in_market_delivery_app/screens/setting_name.dart';
import 'package:in_market_delivery_app/screens/setting_password.dart';
import 'package:in_market_delivery_app/widgets/round_button.dart';
import 'package:in_market_delivery_app/widgets/tap_list_tile.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    DeliveryModel? delivery = authProvider.delivery;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('各種設定'),
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
          TapListTile(
            title: '名前の変更',
            subtitle: delivery?.name,
            onTap: () {
              authProvider.nameController.text = delivery?.name ?? '';
              nextScreen(context, const SettingNameScreen());
            },
          ),
          TapListTile(
            title: 'メールアドレスの変更',
            subtitle: delivery?.email,
            onTap: () {
              authProvider.emailController.text = delivery?.email ?? '';
              nextScreen(context, const SettingEmailScreen());
            },
          ),
          TapListTile(
            title: 'パスワードの変更',
            onTap: () {
              nextScreen(context, const SettingPasswordScreen());
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: RoundButton(
              labelText: 'ログアウト',
              labelColor: Colors.green.shade400,
              borderColor: Colors.green.shade400,
              onPressed: () async {
                await authProvider.logout();
                authProvider.clearController();
                if (!mounted) return;
                changeScreen(context, const LoginScreen());
              },
            ),
          ),
        ],
      ),
    );
  }
}
