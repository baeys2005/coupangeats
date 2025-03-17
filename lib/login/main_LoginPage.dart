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

  bool _isValidEmail = false;
  bool _isValidPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 90),
              Center(
                child: Image.asset('assets/coupanglogo.png', height: 40),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                  key: _key,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          emailInput(), //아래 커스텀 위젯 만들기
                          if (_isValidEmail)
                            const Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                              ),
                            )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          passwordInput(), //have to make custom widget below
                          if (_isValidPassword)
                            const Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                              ),
                            )
                        ],
                      ),
                      const SizedBox(height: 28),
                      loginButton(),
                      const SizedBox(height: 15),
                      Container(
                        height: 0.5,
                        width: 271,
                        color: Color(0xffD9D9D9),
                      ),
                      const SizedBox(height: 15),
                      signupButton(), //누르면 회원가입 페이지로 이동하도록
                    ],
                  ))
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
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)),
        hintText: '이메일을 입력하세요',
        prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)),
        hintText: '비밀번호를 입력하세요',
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (val) {
        if (val!.isEmpty) {
          return '비밀번호를 입력해주세요';
        }
        return null;
      },
    );
  }

  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_key.currentState!.validate()) {
            try {
              final userCredential = await _auth.signInWithEmailAndPassword(
                  email: _emailController.text.trim(),
                  password: _pwdController.text);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('로그인 성공!')),
                );
                Navigator.pushReplacementNamed(context, '/');
              }
            } on FirebaseAuthException catch (e) {
              String message;

              // FirebaseAuth 제공 Error Code에 따른 분기 처리
              switch (e.code) {
                case 'wrong-password':
                  message = '비밀번호가 잘못되었습니다.';
                  break;
                case 'user-not-found':
                  message = '계정정보가 없습니다.';
                  break;
                case 'invalid-email':
                  message = '아이디가 잘못되었습니다.'; // 이메일 형식 자체가 잘못된 경우
                  break;
                default:
                  message = '로그인에 실패했습니다.';
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff0062ff),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: const Text(
          '로그인',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget signupButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/signup');
        },
        child: const Text(
          '회원가입하기',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff0062ff),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
    );
  }
}
