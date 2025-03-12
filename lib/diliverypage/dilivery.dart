import 'package:coupangeats/diliverypage/dilivery_after_order.dart';
import 'package:coupangeats/diliverypage/dilivery_before_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class Dilivery extends StatefulWidget {
  const Dilivery({super.key});

  @override
  State<Dilivery> createState() => _DiliveryState();
}

class _DiliveryState extends State<Dilivery> {
  // 지도 중앙 좌표를 추적할 변수
  NLatLng? _centerLatLng;
  NaverMapController? _controller;

  NCameraPosition _mapPosition =
      const NCameraPosition(target: NLatLng(37.5665, 126.9780), zoom: 15);

  NCameraPosition get mapPosition => _mapPosition;
  bool _showAfterOrder = false; // 상태 변수 추가
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        _showAfterOrder = true; // 10초 후에 상태 변경
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: NaverMap(
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
              final marker =
                  NMarker(id: "test", position: NLatLng(37.5665, 126.9780));
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
              NCameraPosition cameraPosition =
                  await _controller!.getCameraPosition();
              debugPrint("카메라위치 " + cameraPosition.toString());
              setState(() {
                _mapPosition =
                    cameraPosition; // 수정: 현재 카메라 위치를 _mapPosition에 저장
                _centerLatLng =
                    cameraPosition.target; // 화면 중앙 좌표도 _centerLatLng에 저장
              });
            },
          )),
          DraggableScrollableSheet(
            initialChildSize: 0.3, // 처음 표시되는 크기 (30%)
            minChildSize: 0.2, // 최소 크기 (20%)
            maxChildSize: 0.8, // 최대 크기 (80%)
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: SingleChildScrollView(
                      controller: scrollController, // 스크롤 컨트롤러 적용
                    child: _showAfterOrder
                        ? const DiliveryAfterOrder() // 10초 후 변경
                        : const DiliveryBeforeOrder(),
                  )
              );
            },
          ),
        ],
      ),
    );
  }
}
