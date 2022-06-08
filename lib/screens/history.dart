import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_market_delivery_app/helpers/functions.dart';
import 'package:in_market_delivery_app/models/shop.dart';
import 'package:in_market_delivery_app/models/shop_order.dart';
import 'package:in_market_delivery_app/providers/auth.dart';
import 'package:in_market_delivery_app/providers/order.dart';
import 'package:in_market_delivery_app/widgets/center_text.dart';
import 'package:in_market_delivery_app/widgets/order_card.dart';
import 'package:in_market_delivery_app/widgets/search_button.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    ShopModel? shop = authProvider.currentShop;
    final orderProvider = Provider.of<OrderProvider>(context);
    List<ShopOrderModel> orders = [];

    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('配達履歴'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                SearchButton(
                  iconData: Icons.calendar_month,
                  labelText: dateText('yyyy年MM月', orderProvider.month),
                  onPressed: () async {
                    DateTime? selected = await customMonthPicker(
                      context: context,
                      initialDate: orderProvider.month,
                    );
                    if (selected == null) return;
                    orderProvider.changeMonth(selected);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: orderProvider.streamOrders(
                shop: shop,
                statusList: [0],
              ),
              builder: (context, snapshot) {
                orders.clear();
                if (snapshot.hasData) {
                  for (DocumentSnapshot<Map<String, dynamic>> doc
                      in snapshot.data!.docs) {
                    orders.add(ShopOrderModel.fromSnapshot(doc));
                  }
                }
                if (orders.isEmpty) {
                  return const CenterText(label: '配達完了の注文がありません');
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: orders.length,
                  itemBuilder: (_, index) {
                    ShopOrderModel order = orders[index];
                    return OrderCard(
                      order: order,
                      onTap: () {},
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
