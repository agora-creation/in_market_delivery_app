import 'package:flutter/material.dart';
import 'package:in_market_delivery_app/helpers/style.dart';

class TapListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Function()? onTap;

  const TapListTile({
    required this.title,
    this.subtitle,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBottomBorder,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceHanSans-Bold',
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle ?? '',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              )
            : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
