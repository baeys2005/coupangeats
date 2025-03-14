import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//editor 하연: 가게 정보 프로바이더
/// StoreProvider: 특정 가게(stores/{storeId})의 상세정보를 불러와 전역 관리
class StoreProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ▷ 불러올 필드들
  String storeId = ''; // [추가] 현재 가게 문서 ID 저장 (업데이트 시 필요)
  // ▷ 불러올 필드들
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
  // [추가] 가게 위치 좌표 (GeoPoint 형식)
  GeoPoint? storeLocation;

  /// [resetStoreData] : 이전 store 데이터가 남아있지 않도록 초기화(StorePage문제해결)
  void resetStoreData() {
    _isLoading = true;
    storeId = ''; // [추가] 초기화
    storeName = '';
    storeImages = [];
    storeLocation = null; // [추가] 위치 초기화
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
// [추가] storeLocation 필드 파싱 (GeoPoint 형식)
        storeLocation = data['storeLocation'] as GeoPoint?;
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
  Future<void> updateStoreLocation(double latitude, double longitude) async {
    // storeId가 유효한지 확인
    if (storeId.isEmpty) {
      print('❌ updateStoreLocation 실패: storeId가 비어있음');
      return;
    }
    try {
      // Firestore의 stores/{storeId} 문서의 storeLocation 필드를 업데이트
      await FirebaseFirestore.instance.collection('stores').doc(storeId).update({
        'storeLocation': GeoPoint(latitude, longitude),
      });
      // 로컬 변수도 업데이트 (필요한 경우)
      storeLocation = GeoPoint(latitude, longitude);
      print('[DEBUG] updateStoreLocation 완료: ($latitude, $longitude)');
      notifyListeners();
    } catch (e) {
      print('❌ updateStoreLocation 실패: $e');
    }
  }
}
