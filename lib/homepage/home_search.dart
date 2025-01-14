import 'package:flutter/material.dart';
import 'package:coupangeats/theme.dart';
class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
      child: ElevatedButton(

          onPressed: (){}, child: Row(children: [
        Icon(Icons.search),
        SizedBox(width: 30),
        Text('오늘 치킨 ㄱㄱ')
      ],),
      style: searchButtonTheme,
    ));
  }
}
