import 'package:flutter/material.dart';
import 'package:in_market_delivery_app/models/shop.dart';

class ShopTitle extends StatelessWidget {
  final ShopModel? shop;
  final Function()? onTap;

  const ShopTitle({
    this.shop,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(shop?.name ?? '配達元未設定'),
          const SizedBox(width: 8),
          shop != null ? const Icon(Icons.arrow_drop_down) : Container(),
        ],
      ),
    );
  }
}
