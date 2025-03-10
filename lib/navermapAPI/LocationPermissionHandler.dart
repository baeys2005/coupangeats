import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io' show Platform;

class LocationPermissionHandler {
  final BuildContext context;

  LocationPermissionHandler(this.context);

  /// 위치 권한 처리를 위한 메인 메소드
  Future<bool> handleLocationPermission() async {
    // 먼저 위치 서비스가 활성화되어 있는지 확인
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDisabledDialog();
      return false;
    }

    // 앱 권한 확인 전 먼저 package_info를 사용하여 앱 정보를 출력
    // 디버깅 목적으로 앱 정보 표시 (실제 코드에선 로그만 출력)
    debugPrint('앱 권한 확인 시작...');

    // 프로그램적으로 권한 상태 요청
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationWhenInUse,
      Platform.isAndroid ? Permission.locationAlways : Permission.location,
    ].request();

    debugPrint('권한 상태: $statuses');

    // 위치 권한 상태 확인
    PermissionStatus permissionStatus = await Permission.location.status;
    debugPrint('위치 권한 상태: $permissionStatus');

    if (permissionStatus.isPermanentlyDenied) {
      _showPermissionResetDialog();
      return false;
    }

    if (permissionStatus.isDenied) {
      // 일반적인 거부 상태 처리
      return _handleDeniedPermission();
    }

    // 권한이 허용되었거나 제한된 경우
    return permissionStatus.isGranted || permissionStatus.isLimited;
  }

  /// 거부된 권한 처리
  Future<bool> _handleDeniedPermission() async {
    bool shouldProceed = await _showPermissionRequestDialog();
    if (shouldProceed) {
      PermissionStatus newStatus = await Permission.location.request();
      return newStatus.isGranted || newStatus.isLimited;
    }
    return false;
  }

  /// 위치 서비스 활성화 요청 다이얼로그
  void _showLocationServiceDisabledDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('위치 서비스 비활성화'),
        content: const Text('위치 서비스가 비활성화되어 있습니다. 음식점을 찾고 배달 위치를 설정하기 위해 위치 서비스를 활성화해주세요.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Geolocator.openLocationSettings();
            },
            child: const Text('위치 설정 열기'),
          ),
        ],
      ),
    );
  }

  /// 권한이 영구적으로 거부된 경우에 앱 데이터 초기화 안내 다이얼로그
  void _showPermissionResetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('위치 권한 문제 해결'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('위치 권한이 영구적으로 거부되었습니다. 다음 방법으로 문제를 해결해 보세요:'),
              const SizedBox(height: 16),
              if (Platform.isAndroid) ... [
                const Text('방법 1: 앱 정보에서 직접 권한 변경'),
                const Text('1. 설정 앱 > 앱 > 쿠팡이츠'),
                const Text('2. 권한 > 위치 > 허용'),
                const SizedBox(height: 10),
                const Text('방법 2: 앱 데이터 초기화 (권장)'),
                const Text('1. 설정 앱 > 앱 > 쿠팡이츠'),
                const Text('2. 저장공간 > 데이터 지우기'),
                const Text('3. 앱 다시 시작하기'),
                const SizedBox(height: 10),
                const Text('방법 3: 앱 재설치'),
                const Text('1. 앱 완전히 제거하기'),
                const Text('2. 앱 다시 설치하기'),
              ] else ... [
                const Text('iOS 기기:'),
                const Text('1. 설정 앱 > 쿠팡이츠'),
                const Text('2. 위치 > 앱 사용 중에 허용'),
                const SizedBox(height: 10),
                const Text('그래도 해결되지 않으면:'),
                const Text('1. 앱 삭제 후 재설치'),
              ],
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('나중에 하기'),
          ),
          if (Platform.isAndroid)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _openAppDataSettings();
              },
              child: const Text('앱 저장공간 설정'),
            ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: const Text('앱 설정 열기'),
          ),
        ],
      ),
    );
  }

  /// 권한 요청 다이얼로그
  Future<bool> _showPermissionRequestDialog() async {
    bool result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('위치 권한 필요'),
        content: const Text('음식점을 찾고 배달 위치를 설정하기 위해 위치 권한이 필요합니다. 권한을 허용해주시겠습니까?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('권한 요청'),
          ),
        ],
      ),
    ) ?? false;

    return result;
  }

  /// 앱 데이터/저장공간 설정 페이지 열기 (안드로이드 전용)
  void _openAppDataSettings() {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('앱 저장공간 설정'),
          content: const Text('다음 단계를 따라주세요:\n\n'
              '1. 설정 앱 > 앱 > 쿠팡이츠\n'
              '2. 저장공간 메뉴 선택\n'
              '3. "데이터 지우기" 버튼 탭\n'
              '4. 앱 다시 실행'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await openAppSettings();
              },
              child: const Text('설정 열기'),
            ),
          ],
        ),
      );
    }
  }
}