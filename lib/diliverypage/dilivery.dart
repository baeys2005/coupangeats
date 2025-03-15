import 'package:coupangeats/diliverypage/dilivery_after_order.dart';
import 'package:coupangeats/diliverypage/dilivery_before_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../providers/user_info_provider.dart';  // [추가] UserInfoProvider 임포트
import 'dart:math' as math;

import 'package:provider/provider.dart';

import '../providers/store_info_provider.dart'; // [추가] 수학 함수 사용을 위해

class Dilivery extends StatefulWidget {
  final String storeId; // [수정] 가게 ID를 전달받음
  const Dilivery({super.key,required this.storeId});

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
    // [수정] 전달받은 storeId를 이용해 가게 정보 불러오기
    final storeProv = Provider.of<StoreProvider>(context, listen: false);
    storeProv.loadStoreData(widget.storeId);
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        _showAfterOrder = true; // 10초 후에 상태 변경
      });
    });
  }
// [추가] Haversine 공식을 이용해 두 좌표 사이의 거리를 km 단위로 계산하는 함수
  double computeDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371; // km
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(lat1)) *
            math.cos(_deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }
  // [추가] 도(degree)를 라디안(radian)으로 변환하는 함수
  double _deg2rad(double deg) {
    return deg * (math.pi / 180);
  }
  // [추가] 배달 시간 추정 함수: 평균속도 20km/h 가정, 최소 30분, 최대 60분으로 클램핑
  int estimateDeliveryTime(double distanceKm) {
    // 평균속도: 20km/h -> 분 단위: (distance / 20) * 60
    int minutes = ((distanceKm / 20) * 60).round();
    if (minutes < 30) minutes = 30;
    if (minutes > 60) minutes = 60;
    return minutes;
  }
  // [추가] 사용자와 가게 마커가 모두 보이도록 카메라를 업데이트하는 함수
  void _updateCameraToShowMarkers(
      double userLat, double userLon, double storeLat, double storeLon) {
    final swLat = math.min(userLat, storeLat);
    final swLon = math.min(userLon, storeLon);
    final neLat = math.max(userLat, storeLat);
    final neLon = math.max(userLon, storeLon);
    final bounds = NLatLngBounds.from([
      NLatLng(swLat, swLon),
      NLatLng(neLat, neLon),
    ]);
    // [추가] 적절한 padding을 설정 (예: 50)
    final cameraUpdate = NCameraUpdate.fitBounds(bounds, padding: const EdgeInsets.all(50));
    _controller?.updateCamera(cameraUpdate);
    debugPrint('[DEBUG] Camera updated to fit markers: SW=($swLat, $swLon), NE=($neLat, $neLon)');
  }
  // [추가] 사용자 및 가게 좌표를 기반으로 마커를 지도에 표시하는 함수
  void _updateMarkers(double userLat, double userLon, double storeLat, double storeLon) {
    if (_controller != null) {
      // (기존 마커 제거 코드가 필요한 경우 아래 주석 해제)
      // _controller!.removeOverlayById("userMarker");
      // _controller!.removeOverlayById("storeMarker");
      final userMarker = NMarker(
        id: "userMarker",
        position: NLatLng(userLat, userLon),
      );
      final storeMarker = NMarker(
        id: "storeMarker",
        position: NLatLng(storeLat, storeLon),
      );
      _controller!.addOverlay(userMarker);
      _controller!.addOverlay(storeMarker);
      debugPrint('[DEBUG] Markers updated: userMarker at ($userLat, $userLon), storeMarker at ($storeLat, $storeLon)');
    }
  }
  @override
  Widget build(BuildContext context) {
    // [수정/추가] UserInfoProvider에서 사용자 좌표를 불러옴.
// 좌표가 null이면 기본값 대신 null을 반환
    final userInfo = Provider.of<UserInfoProvider>(context);
    final double? userLat = userInfo.latitude;  // 기본값 제거
    final double? userLon = userInfo.longitude; // 기본값 제거
    debugPrint('[DEBUG] User 좌표: latitude=$userLat, longitude=$userLon');

    // [수정] StoreProvider에서 가게 위치를 가져옴
    final storeProv = Provider.of<StoreProvider>(context);
    // [수정] 기존 storeLocation 대신 latitude와 longitude 필드 사용
    double? storeLat = storeProv.latitude;
    double? storeLon = storeProv.longitude;
    String storeAddress = storeProv.storeAddress; // [추가] 가게 배달주소
    debugPrint('[DEBUG] Dilivery - storeLocation: latitude=$storeLat, longitude=$storeLon');;

    int estimatedMinutes = 0;
    String distanceStr = "0.00";
    if (userLat != null && userLon != null && storeLat != null && storeLon != null) {
      double distance = computeDistance(userLat, userLon, storeLat, storeLon);
      estimatedMinutes = estimateDeliveryTime(distance);
      distanceStr = distance.toStringAsFixed(2);
      debugPrint('[DEBUG] 계산된 거리: $distance km, 예상 배달 시간: $estimatedMinutes분');
      // 마커 업데이트 호출 (빌드 완료 후)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateMarkers(userLat, userLon, storeLat, storeLon);
        _updateCameraToShowMarkers(userLat, userLon, storeLat, storeLon);
      });
    }
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
              if (storeLat != null && storeLon != null) {
                final storeMarker = NMarker(
                  id: "storeMarker",
                  position: NLatLng(storeLat, storeLon),
                );
                controller.addOverlay(storeMarker);
              }
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
                        ? DiliveryAfterOrder(estimatedMinutes: estimatedMinutes,
                      distanceString: distanceStr,deliveryAddress: storeAddress) // 10초 후 변경
                        :  DiliveryBeforeOrder(deliveryAddress: storeAddress),
                  )
              );
            },
          ),
        ],
      ),
    );
  }
}
