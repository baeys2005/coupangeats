import 'package:flutter/material.dart';

import 'package:coupangeats/theme.dart';
class adImage extends StatelessWidget {
  const adImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding1),
      child: Image.asset('assets/wowad.jpg',height: 100),
    );
  }
}
