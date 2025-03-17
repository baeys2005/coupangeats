import 'package:coupangeats/orderpage/store_appBar.dart';
import 'package:flutter/material.dart';
// 올바른 import 경로 확인 필요
import 'package:coupangeats/orderpage/store_info.dart';
import '../homepage/home_wowad.dart';

class StoreInfoDelivery extends StatefulWidget {
  const StoreInfoDelivery({super.key});

  @override
  State<StoreInfoDelivery> createState() => _StoreInfoDeliveryState();
}

class _StoreInfoDeliveryState extends State<StoreInfoDelivery> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 배달 시간 및 매장 정보 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time_outlined),
                  SizedBox(width: 8),
                  Text(
                    "27분",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black
                    ),
                  ),
                ],
              ),
              TextButton(
                  onPressed: () {
                    // StoreInfos 대신 StoreInfo 사용 또는 아래처럼 주석 처리
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => StoreInfo(),
                    //   ),
                    // );

                    // 일시적으로 기능 주석 처리
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('매장 정보 기능 준비 중입니다.')),
                    );
                  },
                  child: Text("매장,원산지정보 >",
                    style: TextStyle(color: Colors.black),)
              )
            ],
          ),

          // 2. 최소주문
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("최소주문"),
              Text(
                "20,000원",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10),

          // 3. 배달비
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("배달비"),
              Text(
                "0~3,000원 자세히",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 20),

          // 4. 와우회원 무료배달 버튼
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Color(0xff0C2F65),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 15),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(0xff407CD2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "WOW",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: "와우회원은 ",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: "매 주문 무료배달",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right: 15),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xff00A7F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "가입하기",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}