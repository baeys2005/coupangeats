import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:coupangeats/datastore/storeData.dart';
import 'package:coupangeats/login/main_LoginPage.dart';

class Storeownerpage extends StatefulWidget {
  const Storeownerpage({super.key});

  @override
  State<Storeownerpage> createState() => _StoreownerpageState();
}

class _StoreownerpageState extends State<Storeownerpage> {

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<UserProvider>(context);


    return Scaffold(
      body: Column(children: [
        Text("${ 'Logged in as: ${authProvider.user!.email}'}")
      ],),
    );
  }
}

