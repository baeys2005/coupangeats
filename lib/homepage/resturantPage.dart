import 'package:flutter/material.dart';
import 'package:coupangeats/theme.dart';

class RestaurantPage extends StatelessWidget {
  final int index;

  const RestaurantPage({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('가게 상세'),
      ),
      body: Center(
        child: Text('Restaurant Details Page - Index: $index'),
      ),
    );
  }
}