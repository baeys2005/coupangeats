import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool _isLoading = true;
  bool _isValidEmail = false;
  bool _isValidPassword = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();

    // 이메일과 비밀번호 입력 감지
    _emailController.addListener(_validateEmail);
    _pwdController.addListener(_validatePassword);
  }

  void _validateEmail() {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      _isValidEmail = emailRegExp.hasMatch(_emailController.text);
    });
  }

  void _validatePassword() {
    setState(() {
      _isValidPassword = _pwdController.text.length >= 6;
    });
  }

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Firebase initialization error in SignupPage: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Center(
                child: Image.asset(
                  'assets/coupanglogo.png',
                  height: 40,
                ),
              ),
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.only(left: 3),
                child: const Text(
                  '회원정보를 입력해주세요',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Form(
                key: _key,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        emailInput(),
                        if (_isValidEmail)
                          const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(Icons.check_circle, color: Colors.blue),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        passwordInput(),
                        if (_isValidPassword)
                          const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(Icons.check_circle, color: Colors.blue),
                          ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    submitButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField emailInput() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintText: '이메일을 입력하세요',
        prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (val) {
        if (val!.isEmpty) {
          return '이메일을 입력해주세요';
        }
        return null;
      },
    );
  }

  TextFormField passwordInput() {
    return TextFormField(
      controller: _pwdController,
      obscureText: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintText: '비밀번호를 입력하세요',
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (val) {
        if (val!.isEmpty) {
          return '비밀번호를 입력해주세요';
        }
        return null;
      },
    );
  }

  Widget submitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_key.currentState!.validate()) {
            try {
              final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _pwdController.text,
              );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('회원가입 성공!')),
                );
                Navigator.pushNamed(context, "/");
              }
            } on FirebaseAuthException catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${e.message}')),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff0062FF),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          '가입하기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwdController.dispose();
    super.dispose();
  }
}