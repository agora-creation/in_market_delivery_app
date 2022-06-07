
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryModel {
  String _id = '';
  String _email = '';
  String _password = '';
  String _name = '';
  String _imageUrl = '';
  String _shopId = '';
  String _token = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get email => _email;
  String get password => _password;
  String get name => _name;
  String get imageUrl => _imageUrl;
  String get shopId => _shopId;
  String get token => _token;
  DateTime get createdAt => _createdAt;

  DeliveryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    _id = snapshot.data()!['id'] ?? '';
    _email = snapshot.data()!['email'] ?? '';
    _password = snapshot.data()!['password'] ?? '';
    _name = snapshot.data()!['name'] ?? '';
    _imageUrl = snapshot.data()!['imageUrl'] ?? '';
    _shopId = snapshot.data()!['shopId'] ?? '';
    _token = snapshot.data()!['token'] ?? '';
    _createdAt = snapshot.data()!['createdAt'].toDate() ?? DateTime.now();
  }
}