import 'package:flutter/material.dart';
import 'package:coupangeats/theme.dart';

class adImage extends StatelessWidget {
  const adImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AspectRatio(
          aspectRatio: 16 / 5,
          child: Image.asset(
            'assets/wowad.jpg'
          ),
        ),
      ),
    );
  }
}
