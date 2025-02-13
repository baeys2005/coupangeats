import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainLoginpage extends StatefulWidget {
  const MainLoginpage({super.key});

  @override
  State<MainLoginpage> createState() => _MainLoginpageState();
}

class _MainLoginpageState extends State<MainLoginpage> {
  final _key = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),

        ),
      ),

    );
  }
}

