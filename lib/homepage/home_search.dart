import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: ElevatedButton(

          onPressed: (){}, child: Row(children: [
        Icon(Icons.search),
        Text('오늘 치킨 ㄱㄱ')
      ],),

    ));
  }
}
