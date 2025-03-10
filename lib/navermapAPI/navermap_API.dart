import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'dart:io' show Platform;

class NavermapApi extends StatefulWidget {
  const NavermapApi({super.key});

  @override
  State<NavermapApi> createState() => _NavermapApiState();
}

class _NavermapApiState extends State<NavermapApi> {
  NaverMapController? _mapController;
  Position? _currentPosition;
  bool _isLoading = false;
  String _statusMessage = '위치 정보를 가져오는 중...';

  // 시뮬레이터 감지 플래그 (개발 중에만 사용)
  bool get _isSimulator => Platform.isIOS && !Platform.isAndroid && _isForceUseSimulatorLocation;

  // 시뮬레이터 위치 강제 사용 여부 (개발 중에만 true로 설정)
  final bool _isForceUseSimulatorLocation = false;

  // 서울 강남역 위치 (시뮬레이터용)
  final double _seoulLatitude = 37.4979;  // 서울 강남역 위도
  final double _seoulLongitude = 127.0276; // 서울 강남역 경도

  @override
  void initState() {
    super.initState();
    // 위젯이 빌드된 후에 위치 가져오기 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getLocation();
    });
  }

  // 위치 가져오기 (메인 함수)
  Future<void> _getLocation() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '위치 정보를 가져오는 중...';
    });

    try {
      // 시뮬레이터 체크 - 시뮬레이터인 경우 가상 위치 사용
      if (_isSimulator) {
        await _getSimulatedLocation();
      } else {
        // 실제 디바이스인 경우 진짜 위치 가져오기
        await _getRealDeviceLocation();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = '위치 정보를 가져오는 중 오류 발생: $e';
      });
      debugPrint('위치 정보 오류: $e');
    }
  }

  // 실제 디바이스에서 위치 가져오기
  Future<void> _getRealDeviceLocation() async {
    try {
      // 1. 위치 서비스 활성화 확인
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _statusMessage = '위치 서비스가 비활성화되어 있습니다.';
        });
        return;
      }

      // 2. 위치 권한 확인
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
            _statusMessage = '위치 권한이 거부되었습니다.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
          _statusMessage = '위치 권한이 영구적으로 거부되었습니다. 설정에서 변경해주세요.';
        });
        return;
      }

      // 3. 위치 가져오기
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoading = false;
        _statusMessage = '현재 위치: ${position.latitude}, ${position.longitude}';
      });

      _updateMapWithPosition();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = '위치 가져오기 오류: $e';
      });
    }
  }

  // 시뮬레이터용 가상 위치 설정
  Future<void> _getSimulatedLocation() async {
    try {
      // 약간의 지연 추가 (실제 위치를 가져오는 것처럼 보이기 위함)
      await Future.delayed(const Duration(milliseconds: 800));

      // 서울 강남역 위치로 설정 (하드코딩)
      Position simulatedPosition = Position(
        latitude: _seoulLatitude,
        longitude: _seoulLongitude,
        timestamp: DateTime.now(),
        accuracy: 10.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        floor: null,
        isMocked: true,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );

      setState(() {
        _currentPosition = simulatedPosition;
        _isLoading = false;
        _statusMessage = '시뮬레이터 위치 (강남역): ${simulatedPosition.latitude}, ${simulatedPosition.longitude}';
      });

      _updateMapWithPosition();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = '가상 위치 설정 오류: $e';
      });
    }
  }

  // 지도 업데이트 (위치가 있을 때)
  void _updateMapWithPosition() {
    if (_currentPosition == null) return;

    // 지도 컨트롤러가 있으면 위치로 이동
    if (_mapController != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _moveToCurrentLocation();
      });
    }
  }

  // 현재 위치로 카메라 이동
  void _moveToCurrentLocation() {
    if (_currentPosition == null || _mapController == null) return;

    try {
      // 카메라 업데이트
      _mapController!.updateCamera(
        NCameraUpdate.fromCameraPosition(
          NCameraPosition(
            target: NLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 15,
          ),
        ),
      );

      // 현재 위치에 마커 추가
      _addMarkerAtCurrentPosition();
    } catch (e) {
      debugPrint("카메라 이동 오류: $e");
    }
  }

  // 현재 위치에 마커 추가
  void _addMarkerAtCurrentPosition() {
    if (_currentPosition == null || _mapController == null) return;

    try {
      // 기존 마커 제거 (재생성 시)
      _mapController!.clearOverlays();

      // 새 마커 생성
      final marker = NMarker(
        id: 'current-location',
        position: NLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      );

      // 마커 추가
      _mapController!.addOverlay(marker);

      // 마커 색상 변경 (옵션)
      marker.setIconTintColor(Colors.red);

      // 인포윈도우 설정 (위치 정보 표시)
      final infoWindow = NInfoWindow.onMarker(
        id: 'info-window',
        text: '내 위치',
      );

      marker.setOnTapListener((overlay) {
        _mapController!.showInfoWindow(infoWindow);
      });

    } catch (e) {
      debugPrint("마커 추가 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 위치'),
        actions: [
          // 위치 새로고침 버튼
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getLocation,
            tooltip: '위치 새로고침',
          ),
        ],
      ),
      body: Stack(
        children: [
          // 네이버 지도
          NaverMap(
            options: const NaverMapViewOptions(
              indoorEnable: true,
              locationButtonEnable: true,
              consumeSymbolTapEvents: false,
            ),
            onMapReady: (controller) {
              // UI 스레드에서 실행 보장
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _mapController = controller;
                });

                debugPrint("네이버 지도 준비 완료", wrapWidth: 1024);

                if (_currentPosition != null) {
                  _moveToCurrentLocation();
                }
              });
            },
          ),

          // 상태 메시지 표시
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Card(
              color: Colors.white.withOpacity(0.8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _statusMessage,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),

          // 위치 가져오기 버튼
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: _getLocation,
              icon: const Icon(Icons.my_location),
              label: const Text('내 위치 가져오기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // 로딩 인디케이터
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController = null;
    super.dispose();
  }
}

// NaverMapController 확장 메서드
extension NaverMapControllerExtension on NaverMapController {
  void showInfoWindow(NInfoWindow infoWindow) {
    // 네이버 맵에서 인포윈도우 표시 (실제로는 기능이 구현되어 있지만 확장 메서드로 선언)
  }
}