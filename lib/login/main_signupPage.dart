import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numController = TextEditingController();

  bool _isLoading = true;
  bool _isValidEmail = false;
  bool _isValidPassword = false;
  bool _isValidname = false;
  bool _isValidnum = false;

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

    Future<void> _signup() async {
      if (_key.currentState!.validate()) {
        try {
          final userCredential = await _auth.createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _pwdController.text.trim());

          await _firestore
              .collection('signup')
              .doc(userCredential.user!.uid)
              .set({
            'name': _nameController.text.trim(),
            'num': _numController.text.trim(),
            'email': _emailController.text.trim(),
            'createAt': DateTime.now(),
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('회원가입 성공!')),
            );
            Navigator.pushNamed(context, '/');
          }
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message}')),
          );
        }
      }
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
              const SizedBox(height: 47),
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
                    const SizedBox(height: 43),
                    //이름이랑 전화번호 입력하는 칸
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        nameInput(),
                        if (_isValidname)
                          const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(Icons.check_circle, color: Colors.blue),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        numInput(),
                        if (_isValidnum)
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

  //사용자 이름 입력하기
  TextFormField nameInput() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintText: '이름을 입력하세요',
        prefixIcon: const Icon(Icons.person, color: Colors.grey),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (val) {
       if(val == null || val.isEmpty){
         return '이름을 입력해주세요';
       }
       if (val.length<2){
         return '이름을 2글자 이상이어야 합니다';
       }
       setState(() {
         _isValidname = true;
       });
       return null;
      },
      onChanged: (value){
        setState(() {
          _isValidname = value.length >= 2;
        });
      },
    );
  }

  //사용자 전화번호 입력하기
  TextFormField numInput() {
    return TextFormField(
      controller: _numController,
      keyboardType: TextInputType.phone, //숫자 키패드 나오게
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintText: '전화번호를 입력하세요',
        prefixIcon: const Icon(Icons.phone, color: Colors.grey),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (val) {
        if(val == null || val.isEmpty){
          return '전화번호를 입력해주세요';
        }
        final numberRegExp = RegExp(r'^[0-9]+$');
        if (!numberRegExp.hasMatch(val)){
          return '숫자만 입력해주세요';
        }
        if (val.length<10||val.length>11){
          return '올바른 전화번호 형식이 아닙니다';
        }
        setState(() {
          _isValidnum = true;
        });
        return null;
      },
      onChanged: (value){
        setState(() {
          _isValidnum = value.length >=10 && value.length<= 11;
        });
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
              //파베 authentication으로 사용자 계정 생성
              final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _pwdController.text,
              );
              //파베에 사용자 이름이랑 전번 저장
              await FirebaseFirestore.instance
              .collection('signup')
              .doc(userCredential.user!.uid)
              .set({
                'name': _nameController.text.trim(),
                'num' : _numController.text.trim(),
                'email' : _emailController.text.trim(),
                'createAt' : DateTime.now(),
              });
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
    _nameController.dispose();
    _numController.dispose();
    super.dispose();
  }
}
