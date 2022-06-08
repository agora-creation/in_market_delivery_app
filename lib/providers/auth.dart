import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_market_delivery_app/models/delivery.dart';
import 'package:in_market_delivery_app/models/shop.dart';
import 'package:in_market_delivery_app/services/delivery.dart';
import 'package:in_market_delivery_app/services/shop.dart';

enum Status { authenticated, uninitialized, authenticating, unauthenticated }

class AuthProvider with ChangeNotifier {
  Status _status = Status.uninitialized;
  Status get status => _status;
  FirebaseAuth? auth;
  User? _fUser;
  DeliveryService deliveryService = DeliveryService();
  ShopService shopService = ShopService();
  DeliveryModel? _delivery;
  DeliveryModel? get delivery => _delivery;
  ShopModel? _currentShop;
  ShopModel? get currentShop => _currentShop;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  void clearController() {
    emailController.text = '';
    passwordController.text = '';
    rePasswordController.text = '';
    nameController.text = '';
  }

  AuthProvider.initialize() : auth = FirebaseAuth.instance {
    auth?.authStateChanges().listen(_onStateChanged);
  }

  Future<String?> login() async {
    String? errorText;
    if (emailController.text.isEmpty) errorText = 'メールアドレスを入力してください。';
    if (passwordController.text.isEmpty) errorText = 'パスワードを入力してください。';
    try {
      _status = Status.authenticating;
      notifyListeners();
      await auth
          ?.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((value) async {
        _delivery = await deliveryService.select(id: value.user?.uid);
        if (_delivery == null) {
          await auth?.signOut();
          return false;
        }
      });
    } catch (e) {
      _status = Status.unauthenticated;
      notifyListeners();
      errorText = 'ログインに失敗しました。';
    }
    return errorText;
  }

  Future<String?> regist() async {
    String? errorText;
    if (emailController.text.isEmpty) errorText = 'メールアドレスを入力してください。';
    if (passwordController.text.isEmpty) errorText = 'パスワードを入力してください。';
    if (passwordController.text != rePasswordController.text) {
      errorText = 'パスワードをご確認ください。';
    }
    if (nameController.text.isEmpty) errorText = 'お名前を入力してください。';
    try {
      _status = Status.authenticating;
      notifyListeners();
      await auth
          ?.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((value) {
        deliveryService.create({
          'id': value.user?.uid,
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'name': nameController.text.trim(),
          'shopId': '',
          'token': '',
          'createdAt': DateTime.now(),
        });
      });
    } catch (e) {
      _status = Status.unauthenticated;
      notifyListeners();
      errorText = '登録に失敗しました。';
    }
    return errorText;
  }

  Future<String?> updateName() async {
    String? errorText;
    if (nameController.text.isEmpty) errorText = 'お名前を入力してください。';
    try {
      deliveryService.update({
        'id': _delivery?.id,
        'name': nameController.text.trim(),
      });
    } catch (e) {
      errorText = 'お名前の更新に失敗しました。';
    }
    return errorText;
  }

  Future<String?> updateEmail() async {
    String? errorText;
    if (emailController.text.isEmpty) errorText = 'メールアドレスを入力してください。';
    try {
      await auth?.currentUser
          ?.updateEmail(emailController.text.trim())
          .then((value) {
        deliveryService.update({
          'id': _delivery?.id,
          'email': emailController.text.trim(),
        });
      });
    } catch (e) {
      errorText = 'メールアドレスの更新に失敗しました。';
    }
    return errorText;
  }

  Future<String?> updatePassword() async {
    String? errorText;
    if (passwordController.text.isEmpty) errorText = 'パスワードを入力してください。';
    if (passwordController.text != rePasswordController.text) {
      errorText = 'パスワードをご確認ください。';
    }
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: _delivery?.email ?? '',
        password: _delivery?.password ?? '',
      );
      await auth?.signInWithCredential(credential);
      await auth?.currentUser
          ?.updatePassword(passwordController.text.trim())
          .then((value) {
        deliveryService.update({
          'id': _delivery?.id,
          'password': passwordController.text.trim(),
        });
      });
    } catch (e) {
      errorText = 'パスワードの更新に失敗しました。';
    }
    return errorText;
  }

  Future logout() async {
    await auth?.signOut();
    _status = Status.unauthenticated;
    _delivery = null;
    _currentShop = null;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future reloadDelivery() async {
    _delivery = await deliveryService.select(id: _fUser?.uid);
    if (_delivery?.shopId != '') {
      _currentShop = await shopService.select(id: _delivery?.shopId);
    }
    notifyListeners();
  }

  Future _onStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.unauthenticated;
    } else {
      _fUser = firebaseUser;
      _status = Status.authenticated;
      _delivery = await deliveryService.select(id: _fUser?.uid);
      if (_delivery?.shopId != '') {
        _currentShop = await shopService.select(id: _delivery?.shopId);
      }
    }
    notifyListeners();
  }

  Future<List<ShopModel>> selectShops() async {
    return await shopService.selectList();
  }

  Future<String?> updateShop({ShopModel? shop}) async {
    String? errorText;
    if (shop == null) errorText = '店舗の選択に失敗しました。';
    try {
      deliveryService.update({
        'id': _delivery?.id,
        'shopId': shop?.id,
      });
      _currentShop = shop;
    } catch (e) {
      errorText = '店舗の選択に失敗しました。';
    }
    notifyListeners();
    return errorText;
  }

  Future<String?> deleteShop() async {
    String? errorText;
    try {
      deliveryService.update({
        'id': _delivery?.id,
        'shopId': '',
      });
      _currentShop = null;
    } catch (e) {
      errorText = '店舗の選択に失敗しました。';
    }
    notifyListeners();
    return errorText;
  }
}
