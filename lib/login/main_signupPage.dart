import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Form(
            key: _key,
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              emailInput(),
              const SizedBox(height: 15),
              passwordInput(),
              const SizedBox(
                height: 15,
              ),
              submitButton(),
              const SizedBox(
                height: 15,
              ),
            ],
          )),
        ),
      ),
    );
  }

  TextFormField emailInput() {
    return TextFormField(
      controller: _emailController,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return 'The input is empty';
        } else {
          return null;
        }
      },
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'input your email address',
          labelText: 'Email Address',
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  TextFormField passwordInput() {
    return TextFormField(
      controller: _pwdController,
      obscureText: true,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return 'The input id empty';
        } else {
          return null;
        }
      },
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Input your password',
          labelText: 'Password',
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  ElevatedButton submitButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_key.currentState!.validate()) {
          try {
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailController.text,
              password: _pwdController.text,
            );
            print('회원가입 성공'); // 성공 로그
            Navigator.pushNamed(context, "/");
          } on FirebaseAuthException catch (e) {
            print('FirebaseAuthException: ${e.code} - ${e.message}'); // 상세 에러 로그
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${e.code}: ${e.message}')),
            );
          } catch (e) {
            print('Other error: $e'); // 기타 에러 로그
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(  // 에러 메시지 표시 추가
              SnackBar(content: Text(e.message ?? 'An error occurred')),
            );
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        child: const Text('회원가입', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
