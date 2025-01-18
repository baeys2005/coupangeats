import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'datastore/storeData.dart';

class Storeownerpage extends StatefulWidget {
  const Storeownerpage({super.key});

  @override
  State<Storeownerpage> createState() => _StoreownerpageState();
}

class _StoreownerpageState extends State<Storeownerpage> {

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);


    return Scaffold(
      body: Container(child: Text('storepage'),),
    );
  }
}
