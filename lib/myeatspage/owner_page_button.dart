import 'package:flutter/material.dart';
import 'package:coupangeats/ownerpage/storeownerPage.dart';

class OwnerPageButton extends StatelessWidget {
  const OwnerPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.store_mall_directory),
      title: Text('사장님 페이지'),
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Storeownerpage()),
        );
      },
    );
  }
}
