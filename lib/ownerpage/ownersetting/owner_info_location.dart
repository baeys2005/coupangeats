import 'package:coupangeats/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../providers/store_info_provider.dart';
import 'package:coupangeats/providers/store_info_provider.dart';
//TODO: 지도 중앙 마커 stack 으로 구현.
class OwnerInfoLocationPage extends StatefulWidget {
  const OwnerInfoLocationPage({Key? key}) : super(key: key);

  @override
  State<OwnerInfoLocationPage> createState() => _OwnerInfoLocationPageState();
}

class _OwnerInfoLocationPageState extends State<OwnerInfoLocationPage> {
  // 지도 중앙 좌표를 추적할 변수
  NLatLng? _centerLatLng;
  NaverMapController? _controller;

  NCameraPosition _mapPosition = const NCameraPosition(
    target: NLatLng(37.5665, 126.9780),
    zoom: 15,
  );
  NCameraPosition get mapPosition => _mapPosition;

  @override
  void initState() {
    _requestPermission();
    super.initState();
    // Delay unfocus to ensure the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  // [수정] 위치 권한 요청 함수
  void _requestPermission() async {
    var requestStatus = await Permission.location.request();
    var status = await Permission.location.status;
    if (requestStatus.isPermanentlyDenied || status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  /// [가게위치 저장] 버튼 클릭 시, 현재 저장된 _centerLatLng 값을
  /// StoreProvider의 updateStoreLocation() 메서드를 통해 해당 가게 문서의
  /// storeLocation 필드에 업데이트하고, 결과를 스낵바로 보여줍니다.
  void _onPressedSave() async {
    if (_centerLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('지도를 움직여 위치를 확인 후 저장하세요.')),
      );
      return;
    }
    debugPrint('가게위치 저장 버튼 클릭, 저장되는 위치: $_centerLatLng');

    // [수정] StoreProvider를 통해 가게 위치 업데이트 호출
    final storeInfoProvider =
    Provider.of<StoreProvider>(context, listen: false);
    await storeInfoProvider.updateStoreLocation(
      _centerLatLng!.latitude,
      _centerLatLng!.longitude,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('가게위치가 저장되었습니다.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 7,
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
                // 기본 마커 추가 (필요에 따라 커스터마이즈 가능)
                final marker =
                NMarker(id: "storeMarker", position: NLatLng(37.5665, 126.9780));
                controller.addOverlay(marker);
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
                debugPrint("카메라 위치: " + cameraPosition.toString());
                setState(() {
                  _mapPosition = cameraPosition;
                  _centerLatLng = cameraPosition.target;
                });
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("가게 위치를 선택하세요", style: modaltitle1),
                  Center(
                    child: ElevatedButton(
                      onPressed: _onPressedSave,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        "가게위치 저장", // [수정] 버튼 텍스트 변경
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
