import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// StoreProvider: 특정 가게(stores/{storeId})의 상세정보를 불러와 전역 관리
class StoreProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

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

  /// Firestore에서 특정 가게 문서(storeId)의 모든 필드 불러오기
  Future<void> loadStoreData(String storeId) async {
    _isLoading = true;
    notifyListeners(); // 로딩 상태 갱신

    try {
      final storeRef = FirebaseFirestore.instance
          .collection('stores')
          .doc(storeId);

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
}
