import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_market_delivery_app/helpers/style.dart';
import 'package:in_market_delivery_app/providers/auth.dart';
import 'package:in_market_delivery_app/providers/order.dart';
import 'package:in_market_delivery_app/screens/home.dart';
import 'package:in_market_delivery_app/screens/login.dart';
import 'package:in_market_delivery_app/screens/splash.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider.initialize()),
        ChangeNotifierProvider.value(value: OrderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ja')],
        locale: const Locale('ja'),
        title: 'InMarket - 配達者用',
        theme: theme(),
        home: const SplashController(),
      ),
    );
  }
}

class SplashController extends StatelessWidget {
  const SplashController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.uninitialized:
        return const SplashScreen();
      case Status.unauthenticated:
      case Status.authenticating:
        return const LoginScreen();
      case Status.authenticated:
        return const HomeScreen();
      default:
        return const LoginScreen();
    }
  }
}
