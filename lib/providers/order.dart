import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_market_delivery_app/helpers/functions.dart';
import 'package:in_market_delivery_app/models/shop.dart';
import 'package:in_market_delivery_app/models/shop_order.dart';
import 'package:in_market_delivery_app/services/shop_order.dart';

class OrderProvider with ChangeNotifier {
  ShopOrderService orderService = ShopOrderService();

  Future<String?> update({
    ShopOrderModel? order,
    required int status,
  }) async {
    String? errorText;
    if (order == null) errorText = '注文情報の更新に失敗しました。';
    try {
      orderService.update({
        'id': order?.id,
        'shopId': order?.shopId,
        'status': status,
      });
    } catch (e) {
      errorText = '注文情報の更新に失敗しました。';
    }
    notifyListeners();
    return errorText;
  }

  DateTime month = DateTime.now();

  void changeMonth(DateTime selected) {
    month = selected;
    notifyListeners();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamOrders({
    ShopModel? shop,
    required List<int> statusList,
  }) {
    Stream<QuerySnapshot<Map<String, dynamic>>>? ret;
    if (statusList.contains(0)) {
      DateTime monthS = DateTime(month.year, month.month, 1);
      DateTime monthE = DateTime(month.year, month.month + 1, 1).add(
        const Duration(days: -1),
      );
      Timestamp timestampS = convertTimestamp(monthS, false);
      Timestamp timestampE = convertTimestamp(monthE, true);
      ret = FirebaseFirestore.instance
          .collection('shop')
          .doc(shop?.id ?? 'error')
          .collection('order')
          .where('status', whereIn: statusList)
          .orderBy('createdAt', descending: true)
          .startAt([timestampE]).endAt([timestampS]).snapshots();
    } else {
      ret = FirebaseFirestore.instance
          .collection('shop')
          .doc(shop?.id ?? 'error')
          .collection('order')
          .where('status', whereIn: statusList)
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
    return ret;
  }
}
