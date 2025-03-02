import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MyLocationPage extends StatefulWidget {
  const MyLocationPage({Key? key}) : super(key: key);

  @override
  State<MyLocationPage> createState() => _MyLocationPageState();
}

class _MyLocationPageState extends State<MyLocationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 위치 페이지'),
      ),
      body: NaverMap(
        // [1] 지도 기본 옵션
        options: const NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
            target: NLatLng(37.5665, 126.9780), // 서울 시청 근처
            zoom: 15,
          ),
          mapType: NMapType.basic,
          locationButtonEnable: true, // 우측 하단 내 위치 버튼
        ),

        // [2] 스크롤 충돌 방지 여부
        forceGesture: false,

        // [3] 지도 준비 시점에 콜백
        onMapReady: (controller) {
          // 이 버전에서는 setMap() / moveCamera() 등이 없다면
          // 별도 동적 호출 없이 초기 설정만 진행
          debugPrint('네이버 지도 로딩 완료: $controller');
        },

        // [4] 기타 이벤트 콜백
        onMapTapped: (point, latLng) {
          debugPrint('지도 탭: $latLng');
        },
        onCameraChange: (position, reason) {
          debugPrint('카메라 이동: $position, reason: $reason');
        },
        onCameraIdle: () {
          debugPrint('카메라 이동 멈춤');
        },
      ),
    );
  }
}
