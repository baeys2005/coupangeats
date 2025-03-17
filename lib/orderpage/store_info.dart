import 'package:coupangeats/providers/store_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';

class StoreInfos extends StatefulWidget {
  const StoreInfos({super.key});

  @override
  State<StoreInfos> createState() => _StoreInfosState();
}

class _StoreInfosState extends State<StoreInfos> {

  NaverMapController? _controller;
  @override
  void initState() {


    super.initState();
    final storeProv = Provider.of<StoreProvider>(context, listen: false);
    // 2) (선택) 기존 데이터 초기화
    storeProv.resetStoreData();
    // 3) _tempStoreId 로 불러오기
    storeProv.loadStoreData(storeProv.tempStoreId);
  }

  @override
  Widget build(BuildContext context) {
    final storeProv = Provider.of<StoreProvider>(context);
// 좌표가 null이 아닐 경우, GeoPoint를 NLatLng로 변환
    final double storeLat = storeProv.latitude ?? 37.5665;
    final double storeLon = storeProv.longitude ?? 126.9780;
    final NLatLng storeLatLng = NLatLng(storeLat, storeLon);


    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('매장정보'),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 네이버 지도를 표시하는 부분
          Container(
            height: 200,
            // 지도 위젯: 가게 좌표를 초기 카메라 위치로 사용
            child: NaverMap(
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: storeLatLng,
                  zoom: 15,
                ),
                mapType: NMapType.basic,
                locationButtonEnable: false,
              ),
              onMapReady: (controller) {
                _controller = controller;
                // 마커 추가
                final marker = NMarker(
                  id: "storeMarker",
                  position: storeLatLng,
                );
                controller.addOverlay(marker);
              },
            ),
          ),
          titleText(storeProv.storeName),
          bodyText(storeProv.storeAddress),
          SizedBox(
            height: 20,
          ),
          buildTitleText('대표자명', storeProv.storeOwnerName),
          buildTitleText('사업자등록번호', storeProv.storeBizNumber),
          buildTitleText('상호명', storeProv.storeName),
          titleText('영업시간'),
          bodyText(storeProv.storeTime),
          titleText('매장소개'),
          bodyText(storeProv.storeIntro),
          titleText('원산지 정보'),
          bodyText(storeProv.storeOrigin),
          SizedBox(height: 25,),
          Divider(
            color: Colors.blueGrey.withOpacity(0.1), // 선 색상
            thickness: 7, // 선 두께
            height: 20, // 위아래 여백
          )
          ,
          SizedBox(height: 25,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(child: Text('쿠팡이츠 고객 지원 바로가기 '),),
          ),
          SizedBox(height: 25,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(child: Text('쿠팡은 통신판매중개자로서 통신판매의 당사자가 아니며, 판매자가 등록한 상품정보, 상품의 품질 및 거래에 대해서 일체의 책임을 지지 않습니다.',style: TextStyle(fontSize: 10),),),
          ),
          SizedBox(height: 25,),
        ],
      )),
    );
  }
}

Widget titleText(String text) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(25, 25, 25, 5),
    child: Container(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20, // 글자 크기 크게
          fontWeight: FontWeight.bold, // 두껍게
        ),
      ),
    ),
  );
}

Widget bodyText(String text) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
    child: Container(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
    ),
  );
}
Widget buildTitleText(String label, String value) {
  return Container(
    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
    child: Text(
      '$label: $value',
      style: const TextStyle(
        fontSize: 15,       // 두껍게
      ),
    ),
  );
}