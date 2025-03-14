import 'package:flutter/material.dart';
//editor 윤선: 주문페이지(카트에 담는)
class orderPage extends StatefulWidget {
  const orderPage({super.key});

  @override
  State<orderPage> createState() => _orderPageState();
}

class _orderPageState extends State<orderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.arrow_back)),
      ),
    );
  }
}
