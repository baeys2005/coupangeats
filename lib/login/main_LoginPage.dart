import 'package:flutter/material.dart';


//로그인 했다 가정 _추후 삭제.ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
import'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;

//회원가입코드
memberRegistration() async {
  try {
    var result = await auth.createUserWithEmailAndPassword(
      email: "kim@test.com",
      password: "12345dddd",
    );
    print(result.user);
  } catch(e){
    print(e); //이 코드를 통해 왜 가입이 거절됐는지와 같은 메세지 발생
  }
}

//로그인 코드
memberLogin() async {
  try{
    await auth.signInWithEmailAndPassword(
      email: 'kim@test.com',
      password: '12345dddd',
    );
  } catch(e) {
    print(e);
  }
}

class MainLoginpage extends StatefulWidget {
  const MainLoginpage({super.key});

  @override
  State<MainLoginpage> createState() => _MainLoginpageState();
}

class _MainLoginpageState extends State<MainLoginpage> {
  @override
  Widget build(BuildContext context) {
    return Text('dd');
  }
}

