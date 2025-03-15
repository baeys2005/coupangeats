import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// StoreProvider: 특정 가게(stores/{storeId})의 상세정보를 불러와 전역 관리
class StoreProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ▷ 불러올 필드들
  String storeId = '';
  String storeAddress = '';
  String storeBizNumber = '';
  List<String> storeImages = [];
  String storeIntro = '';
  String storeName = '';
  String storeNotice = '';
  String storeOrigin = '';
  String storeOwnerName = '';
  String storeTime = '';
  String storeTip = '';
  // [수정] 기존 GeoPoint storeLocation 대신 별도의 latitude, longitude 필드로 저장
  double? latitude;
  double? longitude;
  /// [resetStoreData] : 이전 store 데이터가 남아있지 않도록 초기화(StorePage문제해결)
  void resetStoreData() {
    _isLoading = true;
    storeId = '';
    storeName = '';
    storeImages = [];
    latitude = null; // [수정] 초기화
    longitude = null; // [수정] 초기화

    // ... 등등 다른 필드도 기본값으로
    notifyListeners();
  }


  /// Firestore에서 특정 가게 문서(storeId)의 모든 필드 불러오기
  Future<void> loadStoreData(String storeId) async {
    // [추가] storeId가 비어있을 경우 방어 코드 추가
    if (storeId.isEmpty) {
      print('❌ loadStoreData 실패: storeId가 비어있음');
      storeName = '유효하지 않은 가게 ID';
      _isLoading = false;
      notifyListeners();
      return;
    }
    this.storeId = storeId; // [추가] storeId 저장
    _isLoading = true;
    notifyListeners(); // 로딩 상태 갱신

    try {
      final storeRef = FirebaseFirestore.instance
          .collection('stores')
          .doc(storeId);//해당되는 storeId 의 store 문서를 가져온다.

      final docSnap = await storeRef.get();

      if (docSnap.exists) {
        final data = docSnap.data() ?? {};

        // 📌 필드별로 파싱
        storeAddress = data['storeAddress'] ?? '';
        storeBizNumber = data['storeBizNumber'] ?? '';
        storeIntro = data['storeIntro'] ?? '';
        storeName = data['storeName'] ?? '';
        storeNotice = data['storeNotice'] ?? '';
        storeOrigin = data['storeOrigin'] ?? '';
        storeOwnerName = data['storeOwnerName'] ?? '';
        storeTime = data['storeTime'] ?? '';
        storeTip = data['storeTip'] ?? '';
// [수정] 기존 storeLocation 필드를 읽는 대신, 별도의 latitude, longitude 필드 읽기
        if (data.containsKey('latitude') && data.containsKey('longitude')) {
          double? lat = data['latitude'] is num ? (data['latitude'] as num).toDouble() : null;
          double? lon = data['longitude'] is num ? (data['longitude'] as num).toDouble() : null;
          latitude = lat;
          longitude = lon;
        } else {
          latitude = null;
          longitude = null;
        }
        // storeImages는 배열이므로, null 체크 후 map을 통해 String 리스트로 변환
        final List<dynamic>? images = data['storeImages'] as List<dynamic>?;
        if (images != null) {
          storeImages = images.map((e) => e.toString()).toList();
        } else {
          storeImages = [];
        }
      } else {
        // 문서가 아예 없을 때, 기본값 유지
        storeName = '가게 문서가 존재하지 않습니다.';
      }
    } catch (e) {
      print('❌ loadStoreData 실패: $e');
      storeName = '데이터 로드 에러 발생.';
    }

    _isLoading = false;
    notifyListeners(); // 데이터 불러온 뒤 UI 갱신
  }

  /// [updateStoreLocation] : 가게 위치 좌표를 Firestore에 저장하는 메서드
  Future<void> updateStoreLocation(double newLatitude, double newLongitude) async {
    // storeId가 유효한지 확인
    if (storeId.isEmpty) {
      print('❌ updateStoreLocation 실패: storeId가 비어있음');
      return;
    }
    try {
      // [수정] Firestore의 stores/{storeId} 문서에 별도의 latitude, longitude 필드 업데이트
      await FirebaseFirestore.instance.collection('stores').doc(storeId).update({
        'latitude': newLatitude,
        'longitude': newLongitude,
      });
      // 로컬 변수 업데이트
      latitude = newLatitude;
      longitude = newLongitude;
      print('[DEBUG] updateStoreLocation 완료: ($newLatitude, $newLongitude)');
      notifyListeners();
    } catch (e) {
      print('❌ updateStoreLocation 실패: $e');
    }
  }
}
