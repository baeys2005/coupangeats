import 'package:flutter/material.dart';

class HomeHeaderImage extends StatelessWidget {
  const HomeHeaderImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/homepage_wow_1.png',
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}