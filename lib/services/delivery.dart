import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryService {
  final String _collection = 'delivery';
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void update(Map<String, dynamic> values) {
    _firebaseFirestore.collection(_collection).doc(values['id']).update(values);
  }
}
