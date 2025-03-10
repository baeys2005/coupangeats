import 'package:coupangeats/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MyLocationPage extends StatefulWidget {
  const MyLocationPage({Key? key}) : super(key: key);

  @override
  State<MyLocationPage> createState() => _MyLocationPageState();
}

class _MyLocationPageState extends State<MyLocationPage> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 위치 페이지'),
      ),
      body: Column(

        children: [

          Expanded(
            flex: 7,
            child: Container(child: Text('네이버맵'),),
          ),
          Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(20),

                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("경기도용인시 어쩌고 ",style: modaltitle1,),
                    Text("경기도용인시 어쩌고 ",),
                    Center(
                      child: ElevatedButton(

                        onPressed: () {


                          // 버튼 클릭 시 실행할 코드
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7), // 모서리 둥글게 (숫자 조절 가능)
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), // 버튼 크기 조절
                          backgroundColor: Colors.blue, // 버튼 배경색
                        ),
                        child: const Text(
                          "설정하기",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}