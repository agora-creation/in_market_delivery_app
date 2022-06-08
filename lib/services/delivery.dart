import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_market_delivery_app/models/delivery.dart';

class DeliveryService {
  final String _collection = 'delivery';
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void create(Map<String, dynamic> values) {
    _firebaseFirestore.collection(_collection).doc(values['id']).set(values);
  }

  void update(Map<String, dynamic> values) {
    _firebaseFirestore.collection(_collection).doc(values['id']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    _firebaseFirestore.collection(_collection).doc(values['id']).delete();
  }

  Future<DeliveryModel?> select({String? id}) async {
    DeliveryModel? delivery;
    await _firebaseFirestore
        .collection(_collection)
        .doc(id)
        .get()
        .then((value) {
      delivery = DeliveryModel.fromSnapshot(value);
    });
    return delivery;
  }
}
