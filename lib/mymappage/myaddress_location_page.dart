import 'package:coupangeats/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:permission_handler/permission_handler.dart';

import 'myaddress_save.dart';
//TODO: 지도 중앙 마커 stack 으로 구현.
class MyLocationPage extends StatefulWidget {
  const MyLocationPage({Key? key}) : super(key: key);

  @override
  State<MyLocationPage> createState() => _MyLocationPageState();
}

class _MyLocationPageState extends State<MyLocationPage> {
  // 지도 중앙 좌표를 추적할 변수
  NLatLng? _centerLatLng;
  NaverMapController? _controller;

  NCameraPosition _mapPosition = const NCameraPosition(target: NLatLng(37.5665, 126.9780), zoom: 15);
  NCameraPosition get mapPosition => _mapPosition;

  @override
  void initState() {

    _permission();
    super.initState();
  }

  void _permission() async {
    var requestStatus = await Permission.location.request();
    var status = await Permission.location.status;
    if (requestStatus.isPermanentlyDenied || status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
  /// [설정하기] 버튼 클릭 시 현재 저장된 _centerLatLng 값으로 저장 및 디버깅 출력
  void _onPressedSave() {

    if (_centerLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('지도를 움직여 위치를 확인 후 저장하세요.')),
      );
      return;
    }
    debugPrint('설정하기 버튼 클릭, 저장되는 위치: $_centerLatLng');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('위치가 저장되었습니다.')),
    );

    // MyAddressSave 페이지로 현재 좌표를 전달 (예: 좌표는 NLatLng를 Map으로 변환)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyAddressSave(
          latitude: _centerLatLng!.latitude,
          longitude: _centerLatLng!.longitude,
        ),
      ),
    );
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
            child: Stack(
              children: [NaverMap(
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
                forceGesture: true,
                // [3] 지도 준비 시점에 콜백
                onMapReady: (controller) async {
                  _controller = controller; // 이 줄 추가!
                  // 이 버전에서는 setMap() / moveCamera() 등이 없다면
                  // 별도 동적 호출 없이 초기 설정만 진행
                  final marker = NMarker(id: "test", position: NLatLng(37.5665, 126.9780));
                  controller.addOverlay(marker);
              
                  debugPrint('네이버 지도 로딩 완료: $controller');
                },
                // [4] 기타 이벤트 콜백
                onMapTapped: (point, latLng) {
                  debugPrint('지도 탭: $latLng');
                },
                onCameraChange: (position, reason) {
              
                  debugPrint('카메라 이동: $position, reason: $reason');
                },
                onCameraIdle: () async {
                  NCameraPosition cameraPosition = await _controller!.getCameraPosition();
                  debugPrint("카메라위치 " + cameraPosition.toString());
                  setState(() {
                    _mapPosition = cameraPosition; // 수정: 현재 카메라 위치를 _mapPosition에 저장
                    _centerLatLng = cameraPosition.target; // 화면 중앙 좌표도 _centerLatLng에 저장
                  });
              
                },
              ), // 중앙 표시 아이콘 (사람 아이콘 등 원하는 것으로 수정 가능)
                // IgnorePointer로 이벤트 방해 없이 지도 제스처 가능
                Center(child: mapPin)
              ]
            ),
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
                          _onPressedSave();

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