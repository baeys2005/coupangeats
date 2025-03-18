import 'package:flutter/material.dart';


//기본 앱 제목, 부제목 글자설정.
var title1=TextStyle(fontSize: 15,fontWeight: FontWeight.bold);
//기본 버튼, 설명 글자 설정
var body1=TextStyle(fontSize: 15,fontWeight: FontWeight.bold);
var body2=TextStyle(fontSize: 12, );

//페이지속 큰글씨 제목
var pagetitle1=TextStyle(fontSize: 25,fontWeight: FontWeight.bold);
//페이지속 본문 큰글씨
var pagebody1=TextStyle(fontSize: 15);
//테두리 있는 상자
var modaltitle1=TextStyle(
fontSize: 25,
fontWeight: FontWeight.bold,
);


var BorderBox =
BoxDecoration(border: Border.all(color: Colors.black12, width: 1));

//구분선
var dividerLine = Divider(
  color: Colors.black12, // 선 색상
  thickness: 1, // 선 두께
  height: 20, // 위아래 여백
);

double iconsize1=30;

//기본 패딩 단위(옆쪽)
const double padding1=8.0;

var theme =
ThemeData(
  scaffoldBackgroundColor: Colors.white,

  appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black54, // 투명한 검정 (0.54 불투명도)
    ),
  ),

//기본 글자 색 설정
  textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black,fontSize: 15),
      bodySmall: TextStyle(color: Colors.black)
  ),

//바텀바 색 설정
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      // 배경색
      selectedItemColor: Colors.black,
      // 선택된 아이템의 색상
      unselectedItemColor: Colors.black45,
      // 선택되지 않은 아이템의 색상
      selectedIconTheme: IconThemeData(size: 24),
      // 선택된 아이템 아이콘 크기
      unselectedIconTheme: IconThemeData(size: 24),
      // 선택되지 않은 아이템 아이콘 크기
//바텀바 라벨 설정
      selectedLabelStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Colors.blue, // 선택된 라벨 색상
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        color: Colors.grey, // 선택되지 않은 라벨 색상
      )),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white, // 버튼 배경색 흰색
      foregroundColor: Colors.black, // 버튼 글자색 검정
      textStyle: TextStyle()
    )),

  //떠있는 버튼 테마 설정 .
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue, // FAB 배경색
    foregroundColor: Colors.white, // FAB 내부 아이콘/텍스트 색상
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // FAB 모양 변경
    ),
    sizeConstraints: BoxConstraints.tightFor(
      width: 100, // FAB 가로 크기
      height: 100, // FAB 세로 크기
    ),
  ),


  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,


);

var searchButtonTheme=ElevatedButton.styleFrom(
  backgroundColor: Colors.white, // 버튼 배경색
  foregroundColor: Colors.black, // 버튼 텍스트 색상
  //padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // 내부 여백
  //textStyle: const TextStyle(
  //  fontSize: 16,
  //  fontWeight: FontWeight.bold,
  //), // 텍스트 스타일
  minimumSize: Size(200,50),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20), // 버튼 모서리 곡선
  ),
  elevation: 1, // 버튼 그림자 높이
);

var mapPin=  IgnorePointer(
  // 지도 위에서 터치 이벤트를 막지 않으려면 IgnorePointer 사용
  child: Column(
    mainAxisSize: MainAxisSize.min, // 내용물만큼만 크기 차지
    children: [
      // 1) 검정색 원 + 가운데 흰색 아웃라인 사람 아이콘
      Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        child: const Center(
          child: Icon(
            Icons.person_outline,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),

      // 2) 작은 삼각형 (핀 꼬리 부분)
      //  - CustomPaint로 직접 그려주거나, Transform을 이용할 수도 있음
      Transform.translate(
        offset: const Offset(0, -4), // 여기서 높이 조절 (예: -4)
        child: CustomPaint(
          size: const Size(14, 12),
          painter: _TrianglePainter(Colors.black),
        ),
      ),
    ],
  ),
);
/// 삼각형을 그리는 CustomPainter
class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
    // 삼각형의 왼쪽 상단에서 시작
      ..moveTo(0, 0)
    // 오른쪽 상단으로 선
      ..lineTo(size.width, 0)
    // 아래쪽 중앙으로 선
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) => false;
}