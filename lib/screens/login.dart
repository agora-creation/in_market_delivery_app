import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_market_delivery_app/helpers/functions.dart';
import 'package:in_market_delivery_app/helpers/style.dart';
import 'package:in_market_delivery_app/providers/auth.dart';
import 'package:in_market_delivery_app/screens/home.dart';
import 'package:in_market_delivery_app/screens/regist.dart';
import 'package:in_market_delivery_app/widgets/custom_text_form_field.dart';
import 'package:in_market_delivery_app/widgets/error_dialog.dart';
import 'package:in_market_delivery_app/widgets/link_button.dart';
import 'package:in_market_delivery_app/widgets/login_title.dart';
import 'package:in_market_delivery_app/widgets/round_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: double.infinity,
            decoration: loginDecoration,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 320),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  const LoginTitle(),
                  const SizedBox(height: 60),
                  Column(
                    children: [
                      const Text(
                        '既に登録済みの方はログインしてください',
                        style: loginMessageStyle,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: authProvider.emailController,
                        keyboardType: TextInputType.emailAddress,
                        labelText: 'メールアドレス',
                        iconData: Icons.email,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: authProvider.passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        labelText: 'パスワード',
                        iconData: Icons.lock,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: RoundButton(
                          labelText: 'ログイン',
                          labelColor: Colors.black54,
                          backgroundColor: Colors.white,
                          onPressed: () async {
                            String? errorText = await authProvider.login();
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
                            changeScreen(context, const HomeScreen());
                          },
                        ),
                      ),
                      const SizedBox(height: 60),
                      LinkButton(
                        labelText: '新規登録の場合はココをタップ！',
                        onTap: () => nextScreen(context, const RegistScreen()),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
