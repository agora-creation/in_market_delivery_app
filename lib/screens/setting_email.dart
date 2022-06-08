import 'package:flutter/material.dart';
import 'package:in_market_delivery_app/providers/auth.dart';
import 'package:in_market_delivery_app/widgets/custom_text_form_field2.dart';
import 'package:in_market_delivery_app/widgets/error_dialog.dart';
import 'package:in_market_delivery_app/widgets/round_button.dart';
import 'package:provider/provider.dart';

class SettingEmailScreen extends StatefulWidget {
  const SettingEmailScreen({Key? key}) : super(key: key);

  @override
  State<SettingEmailScreen> createState() => _SettingEmailScreenState();
}

class _SettingEmailScreenState extends State<SettingEmailScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('メールアドレスの変更'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          CustomTextFormField2(
            controller: authProvider.emailController,
            keyboardType: TextInputType.emailAddress,
            labelText: 'メールアドレス',
            iconData: Icons.email,
          ),
          const SizedBox(height: 24),
          RoundButton(
            labelText: '変更内容を保存',
            labelColor: Colors.white,
            backgroundColor: Colors.green.shade400,
            onPressed: () async {
              String? errorText = await authProvider.updateEmail();
              if (errorText != null) {
                showDialog(
                  context: context,
                  builder: (_) => ErrorDialog(
                    message: errorText,
                  ),
                );
                return;
              }
              await authProvider.reloadDelivery();
              authProvider.clearController();
              if (!mounted) return;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
