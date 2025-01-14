import 'package:flutter/material.dart';

class adImage extends StatelessWidget {
  const adImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(10),child: Image.asset('assets/wowad.jpg'),);
  }
}
