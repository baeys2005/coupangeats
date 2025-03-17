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

  // 1) 비밀번호 암호화(가리기) 상태를 위한 변수 추가
  //    true면 obscureText 적용, false면 평문 표시
  bool _isHidden = true;  // <-- 수정된 부분

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
      obscureText: _isHidden,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)),
        hintText: '비밀번호를 입력하세요',
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
        // 3) suffixIcon에 IconButton 추가해 _isHidden을 토글
        suffixIcon: IconButton(
          icon: Icon(
            _isHidden ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isHidden = !_isHidden; // <-- 비밀번호 보임/가림 상태 토글
            });
          },
        ),
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
              print('Error code: ${e.code}');
              String message;

              switch (e.code) {
                case 'invalid-email':
                // 이메일 주소 형태가 잘못된 경우 (형식 오류)
                  message = '아이디(이메일) 형식이 잘못되었습니다.';
                  break;
                case 'user-not-found':
                // 가입된 계정이 없는 경우
                  message = '계정정보가 없습니다. 회원가입을 진행해주세요.';
                  break;
                case 'invalid-credential':
                // 이메일은 올바른데 비밀번호가 틀린 경우
                  message = '비밀번호가 잘못되었습니다.';
                  break;
                case 'user-disabled':
                // 비활성화된 계정
                  message = '사용이 중지된 계정입니다. 관리자에게 문의해주세요.';
                  break;
                case 'too-many-requests':
                // 인증 시도 횟수 제한 등
                  message = '잠시 후 다시 시도해주세요.';
                  break;
                default:
                // 그 외 처리되지 않은 에러
                  message = '로그인에 실패했습니다.';
                  break;
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
