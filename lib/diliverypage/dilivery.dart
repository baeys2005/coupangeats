import 'package:coupangeats/diliverypage/dilivery_after_order.dart';
import 'package:coupangeats/diliverypage/dilivery_before_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../mymappage/myaddress_page.dart';
import '../providers/user_info_provider.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

import '../providers/store_info_provider.dart';

class Dilivery extends StatefulWidget {
  final String storeId;
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

  bool _isCameraUpdated = false;
  // 팝업이 중복으로 뜨는 것을 방지하기 위한 플래그
  bool _dialogShown = false; // [추가] 팝업 표시 여부 추적
  @override
  void initState() {
    super.initState();

    final storeProv = Provider.of<StoreProvider>(context, listen: false);
    storeProv.loadStoreData(widget.storeId);
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        _showAfterOrder = true; // 10초 후에 상태 변경
      });
    });
  }

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
  double _deg2rad(double deg) {
    return deg * (math.pi / 180);
  }
  int estimateDeliveryTime(double distanceKm) {
    // 평균속도: 20km/h -> 분 단위: (distance / 20) * 60
    int minutes = ((distanceKm / 20) * 60).round();
    if (minutes < 30) minutes = 30;
    if (minutes > 60) minutes = 60;
    return minutes;
  }
  void _updateCameraToShowMarkers(double userLat, double userLon, double storeLat, double storeLon) {
    final swLat = math.min(userLat, storeLat);
    final swLon = math.min(userLon, storeLon);
    final neLat = math.max(userLat, storeLat);
    final neLon = math.max(userLon, storeLon);
    final bounds = NLatLngBounds.from([
      NLatLng(swLat, swLon),
      NLatLng(neLat, neLon),
    ]);
    final cameraUpdate = NCameraUpdate.fitBounds(bounds, padding: const EdgeInsets.all(50));
    _controller?.updateCamera(cameraUpdate);
    debugPrint('[DEBUG] Camera updated to fit markers: SW=($swLat, $swLon), NE=($neLat, $neLon)');

    const double offsetLat = -0.003;
    Future.delayed(const Duration(milliseconds: 500), () async {
      if (_controller != null) {
        NCameraPosition currentPosition = await _controller!.getCameraPosition();
        double newTargetLat = currentPosition.target.latitude + offsetLat;
        NCameraPosition newPosition = NCameraPosition(
          target: NLatLng(newTargetLat, currentPosition.target.longitude),
          zoom: currentPosition.zoom,
          bearing: currentPosition.bearing,
          tilt: currentPosition.tilt,
        );
        _controller!.updateCamera(NCameraUpdate.fromCameraPosition(newPosition));
        debugPrint('[DEBUG] Camera target shifted upward to: ($newTargetLat, ${currentPosition.target.longitude})');
      }
    });
  }
  void _updateMarkers(double userLat, double userLon, double storeLat, double storeLon) {
    if (_controller != null) {
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
// 좌표가 null이면 기본값 대신 null을 반환
    final userInfo = Provider.of<UserInfoProvider>(context);
    final double? userLat = userInfo.latitude;  // 기본값 제거
    final double? userLon = userInfo.longitude; // 기본값 제거
    debugPrint('[DEBUG] User 좌표: latitude=$userLat, longitude=$userLon');

    final storeProv = Provider.of<StoreProvider>(context);
    double? storeLat = storeProv.latitude;
    double? storeLon = storeProv.longitude;
    String storeAddress = storeProv.storeAddress;
    debugPrint('[DEBUG] Dilivery - storeLocation: latitude=$storeLat, longitude=$storeLon');;

    // 3) 주소 유효성 검사
    if (!_dialogShown) {
      if (userLat == null || userLon == null) {
        // 내 주소가 설정되어 있지 않음 → 팝업 띄움
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _dialogShown = true;
          showDialog(
            context: context,
            barrierDismissible: false, // 다이얼로그 밖 터치로 닫기 방지
            builder: (ctx) {
              return AlertDialog(
                title: const Text('주소 오류'),
                content: const Text('내 주소가 설정되어있지 않습니다.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // 장바구니로 돌아가기
                      Navigator.pop(ctx);    // 다이얼로그 닫기
                      Navigator.pop(context); // Dilivery 페이지 pop
                    },
                    child: const Text('장바구니로 돌아가기'),
                  ),
                  TextButton(
                    onPressed: () {
                      // 내 주소 설정 페이지로 이동
                      Navigator.pop(ctx); // 다이얼로그 닫기
                      Navigator.pop(context); // Dilivery 페이지 pop
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyaddressPage(),
                        ),
                      );
                    },
                    child: const Text('내 주소 설정하기'),
                  ),
                ],
              );
            },
          );
        });
      } else if (storeLat == null || storeLon == null) {
        // 가게 주소가 설정되어 있지 않음 → 팝업 띄움
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _dialogShown = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('주소 오류'),
                content: const Text('가게주소가 설정되어있지 않아 장바구니로 돌아갑니다'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);    // 다이얼로그 닫기
                      Navigator.pop(context); // Dilivery 페이지 pop
                    },
                    child: const Text('확인'),
                  ),
                ],
              );
            },
          );
        });
      }
    }

    // 만약 주소가 유효하지 않아서 팝업을 띄웠다면,
    // 아래 지도가 그려지기 전에 build()가 끝나면서 pop될 것.
    // 안전하게 실제 내용 빌드 전, 주소가 null이 아니어야 진행
    if (userLat == null || userLon == null || storeLat == null || storeLon == null) {
      return const Scaffold(); // 임시
    }
    // ↓ 여기부터는 주소가 모두 유효할 때의 로직 ↓
    int estimatedMinutes = 0;
    String distanceStr = "0.00";
    if (userLat != null && userLon != null && storeLat != null && storeLon != null) {
      double distance = computeDistance(userLat, userLon, storeLat, storeLon);
      estimatedMinutes = estimateDeliveryTime(distance);
      distanceStr = distance.toStringAsFixed(2);
      debugPrint('[DEBUG] 계산된 거리: $distance km, 예상 배달 시간: $estimatedMinutes분');
      if (!_isCameraUpdated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateMarkers(userLat, userLon, storeLat, storeLon);
          _updateCameraToShowMarkers(userLat, userLon, storeLat, storeLon);
        });
        _isCameraUpdated = true; // 업데이트 완료 후 플래그 설정
      }
    }
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: NaverMap(
            options: const NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(37.5665, 126.9780), // 서울 시청 근처
                zoom: 15,
              ),
              mapType: NMapType.basic,
              locationButtonEnable: true, // 우측 하단 내 위치 버튼
            ),

            forceGesture: true,

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
