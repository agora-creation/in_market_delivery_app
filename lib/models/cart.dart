class CartModel {
  String _id = '';
  String _number = '';
  String _name = '';
  int _price = 0;
  String _unit = '';
  String _imageUrl = '';
  int quantityDesired = 0;
  int quantity = 0;

  String get id => _id;
  String get number => _number;
  String get name => _name;
  int get price => _price;
  String get unit => _unit;
  String get imageUrl => _imageUrl;

  CartModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    _number = data['number'] ?? '';
    _name = data['name'] ?? '';
    _price = data['price'] ?? 0;
    _unit = data['unit'] ?? '';
    _imageUrl = data['imageUrl'] ?? '';
    quantityDesired = data['quantityDesired'] ?? 0;
    quantity = data['quantity'] ?? 0;
  }

  Map toMap() => {
        'id': _id,
        'number': _number,
        'name': _name,
        'price': _price,
        'unit': _unit,
        'imageUrl': _imageUrl,
        'quantityDesired': quantityDesired,
        'quantity': quantity,
      };
}
