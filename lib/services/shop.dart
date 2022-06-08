import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_market_delivery_app/models/shop.dart';

class ShopService {
  final String _collection = 'shop';
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<ShopModel>> selectList() async {
    List<ShopModel> shops = [];
    await _firebaseFirestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> data in value.docs) {
        shops.add(ShopModel.fromSnapshot(data));
      }
    });
    return shops;
  }

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
}
