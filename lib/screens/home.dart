import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_market_delivery_app/helpers/functions.dart';
import 'package:in_market_delivery_app/models/shop.dart';
import 'package:in_market_delivery_app/models/shop_order.dart';
import 'package:in_market_delivery_app/providers/auth.dart';
import 'package:in_market_delivery_app/providers/order.dart';
import 'package:in_market_delivery_app/screens/detail.dart';
import 'package:in_market_delivery_app/screens/history.dart';
import 'package:in_market_delivery_app/screens/setting.dart';
import 'package:in_market_delivery_app/screens/shop.dart';
import 'package:in_market_delivery_app/widgets/center_text.dart';
import 'package:in_market_delivery_app/widgets/custom_text_button.dart';
import 'package:in_market_delivery_app/widgets/order_card.dart';
import 'package:in_market_delivery_app/widgets/shop_not_card.dart';
import 'package:in_market_delivery_app/widgets/shop_title.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    ShopModel? shop = authProvider.currentShop;
    final orderProvider = Provider.of<OrderProvider>(context);
    List<ShopOrderModel> orders = [];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ShopTitle(
          shop: shop,
          onTap: () {
            if (shop == null) return;
            showDialog(
              context: context,
              builder: (_) => ShopExitDialog(
                authProvider: authProvider,
              ),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () => overlayScreen(context, const HistoryScreen()),
            icon: const Icon(Icons.history_edu),
          ),
          IconButton(
            onPressed: () => overlayScreen(context, const SettingScreen()),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: orderProvider.streamOrders(
                shop: shop,
                statusList: [2, 3],
              ),
              builder: (context, snapshot) {
                orders.clear();
                if (snapshot.hasData) {
                  for (DocumentSnapshot<Map<String, dynamic>> doc
                      in snapshot.data!.docs) {
                    orders.add(ShopOrderModel.fromSnapshot(doc));
                  }
                }
                if (shop == null) {
                  return ShopNotCard(
                    onPressed: () => overlayScreen(context, const ShopScreen()),
                  );
                }
                if (orders.isEmpty) {
                  return const CenterText(label: '配達待ちの注文がありません');
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: orders.length,
                  itemBuilder: (_, index) {
                    ShopOrderModel order = orders[index];
                    return OrderCard(
                      order: order,
                      onTap: () => nextScreen(
                        context,
                        DetailScreen(order: order),
                      ),
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

class ShopExitDialog extends StatefulWidget {
  final AuthProvider authProvider;

  const ShopExitDialog({
    required this.authProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<ShopExitDialog> createState() => _ShopExitDialogState();
}

class _ShopExitDialogState extends State<ShopExitDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            '現在設定している配達元の店舗を解除します。よろしいですか？',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextButton(
                labelText: 'キャンセル',
                backgroundColor: Colors.grey,
                onPressed: () => Navigator.pop(context),
              ),
              CustomTextButton(
                labelText: '解除する',
                backgroundColor: Colors.red,
                onPressed: () async {
                  await widget.authProvider.deleteShop();
                  if (!mounted) return;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
