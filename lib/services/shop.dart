import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_market_delivery_app/models/shop.dart';

class ShopService {
  final String _collection = 'shop';
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<ShopModel?> select({String? id}) async {
    ShopModel? shop;
    await _firebaseFirestore
        .collection(_collection)
        .doc(id)
        .get()
        .then((value) {
      shop = ShopModel.fromSnapshot(value);
    });
    return shop;
  }

  Future<ShopModel?> selectCode({String? code}) async {
    ShopModel? shop;
    await _firebaseFirestore
        .collection(_collection)
        .where('code', isEqualTo: code ?? 'error')
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> data in value.docs) {
        shop = ShopModel.fromSnapshot(data);
      }
    });
    return shop;
  }
}
