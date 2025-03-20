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
  const Dilivery({super.key, required this.storeId});

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
  bool _showAfterOrder = false;

  bool _isCameraUpdated = false;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();

    // Provider 초기화를 Future.microtask로 래핑하여 빌드 과정에서 호출되지 않도록 함
    Future.microtask(() {
      final storeProv = Provider.of<StoreProvider>(context, listen: false);
      storeProv.loadStoreData(widget.storeId);

      // 사용자 정보 로드
      final userInfo = Provider.of<UserInfoProvider>(context, listen: false);
      userInfo.loadUserInfo();
    });

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _showAfterOrder = true;
        });
      }
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
      // 사용자 마커 생성
      final userMarker = NMarker(
        id: "userMarker",
        position: NLatLng(userLat, userLon),
      );

      // 가게 마커 생성
      final storeMarker = NMarker(
        id: "storeMarker",
        position: NLatLng(storeLat, storeLon),
      );

      // 마커 이벤트 추가
      userMarker.setOnTapListener((overlay) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('내 위치'),
            content: Text('배달받을 주소입니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('확인'),
              ),
            ],
          ),
        );
      });

      storeMarker.setOnTapListener((overlay) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('가게 위치'),
            content: Text('음식을 준비중인 가게 위치입니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('확인'),
              ),
            ],
          ),
        );
      });

      _controller!.addOverlay(userMarker);
      _controller!.addOverlay(storeMarker);

      // 경로선 추가 - 실제 API가 지원하는 경우 활성화
      // 현재는 기본 경로만 추가
      final pathOverlay = NPolylineOverlay(
        id: 'deliveryPath',
        coords: [
          NLatLng(userLat, userLon),
          NLatLng(storeLat, storeLon),
        ],
        width: 5,
        color: Colors.blue.withOpacity(0.7),
      );

      _controller!.addOverlay(pathOverlay);

      debugPrint('[DEBUG] Markers and path updated');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context);
    final double? userLat = userInfo.latitude;
    final double? userLon = userInfo.longitude;
    // 사용자 주소 정보 가져오기
    final String userAddress = userInfo.addressName;
    final String userDetailAddress = userInfo.detailAddress.isNotEmpty
        ? userInfo.detailAddress
        : '';

    debugPrint('[DEBUG] User 좌표: latitude=$userLat, longitude=$userLon');

    final storeProv = Provider.of<StoreProvider>(context);
    double? storeLat = storeProv.latitude;
    double? storeLon = storeProv.longitude;
    String storeAddress = storeProv.storeAddress;
    debugPrint('[DEBUG] Dilivery - storeLocation: latitude=$storeLat, longitude=$storeLon');

    // 배달 주소 구성
    String deliveryAddress = userAddress;
    if (userDetailAddress.isNotEmpty) {
      deliveryAddress += ", $userDetailAddress";
    }

    // 주소 오류 다이얼로그 표시 로직
    if (!_dialogShown) {
      if (userLat == null || userLon == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _dialogShown = true;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) {
                return AlertDialog(
                  title: Text('주소 오류'),
                  content: Text('내 주소가 설정되어있지 않습니다.'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                      child: Text('장바구니로 돌아가기', style: TextStyle(color: Colors.blue)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyaddressPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('내 주소 설정하기'),
                    ),
                  ],
                );
              },
            );
          }
        });
      } else if (storeLat == null || storeLon == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _dialogShown = true;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) {
                return AlertDialog(
                  title: Text('주소 오류'),
                  content: Text('가게주소가 설정되어있지 않아 장바구니로 돌아갑니다'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('확인'),
                    ),
                  ],
                );
              },
            );
          }
        });
      }
    }

    // 주소가 유효하지 않은 경우 로딩 표시
    if (userLat == null || userLon == null || storeLat == null || storeLon == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      );
    }

    // 거리 및 배달 시간 계산
    int estimatedMinutes = 0;
    String distanceStr = "0.00";
    if (userLat != null && userLon != null && storeLat != null && storeLon != null) {
      double distance = computeDistance(userLat, userLon, storeLat, storeLon);
      estimatedMinutes = estimateDeliveryTime(distance);
      distanceStr = distance.toStringAsFixed(2);
      debugPrint('[DEBUG] 계산된 거리: $distance km, 예상 배달 시간: $estimatedMinutes분');

      // 카메라 위치 업데이트
      if (!_isCameraUpdated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _updateMarkers(userLat, userLon, storeLat, storeLon);
            _updateCameraToShowMarkers(userLat, userLon, storeLat, storeLon);
            _isCameraUpdated = true;
          }
        });
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: NaverMap(
                options: const NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(37.5665, 126.9780),
                    zoom: 15,
                  ),
                  mapType: NMapType.basic,
                  locationButtonEnable: true,
                ),
                forceGesture: true,
                onMapReady: (controller) async {
                  _controller = controller;

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
                  NCameraPosition cameraPosition = await _controller!.getCameraPosition();
                  debugPrint("카메라위치 " + cameraPosition.toString());
                  setState(() {
                    _mapPosition = cameraPosition;
                    _centerLatLng = cameraPosition.target;
                  });
                },
              )),

          // 상태 표시바
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.local_shipping, color: Colors.blue),
                  SizedBox(width: 10),
                  Text(
                    _showAfterOrder
                        ? '배달이 시작되었습니다'
                        : '매장에서 주문을 확인하고 있습니다',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 드래그 핸들
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: _showAfterOrder
                            ? DiliveryAfterOrder(
                          estimatedMinutes: estimatedMinutes,
                          distanceString: distanceStr,
                          deliveryAddress: deliveryAddress,
                        )
                            : DiliveryBeforeOrder(deliveryAddress: deliveryAddress),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}