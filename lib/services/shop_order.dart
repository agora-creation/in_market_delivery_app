import 'package:cloud_firestore/cloud_firestore.dart';

class ShopOrderService {
  final String _collection = 'shop';
  final String _subCollection = 'order';
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void update(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .update(values);
  }
}
