import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Firestore 필드를 여기에 저장
  DateTime? userCreateAt;
  String userEmail = '';
  String userName = '';
  String userPhone = '';
  String userRole = '';
  String userMyStore = ''; // 추가: mystore 필드
  String userUid = '';

  // ★ 주소 관련 필드
  String addressName = '';      // 주소 명
  double? latitude;             // 위도
  double? longitude;            // 경도
  String detailAddress = '';    // 상세주소 (아파트/동/호)
  String directions = '';       // 길 안내
  String addressType = '기타';   // 주소 유형 (집, 회사, 기타)

  /// Firestore의 signup/{uid}에서 사용자 정보 가져오기
  Future<void> loadUserInfo() async {
    _isLoading = true;
    notifyListeners(); // 로딩 시작

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // FirebaseAuth에서 가져올 수 있는 email
        print("🔹 Current user's UID: ${user.uid}");
        userEmail = user.email ?? '';
        userUid   = user.uid; // ★ UID 저장

        // Firestore에서 signup/{user.uid} 문서 가져오기
        final docSnap = await FirebaseFirestore.instance
            .collection('signup')
            .doc(user.uid)
            .get();

        if (docSnap.exists) {
          final data = docSnap.data() ?? {};
          print('docSnap data: $data');

          // ✅ Timestamp를 DateTime으로 변환 (없으면 null)
          Timestamp? timestamp = data['createAt'] as Timestamp?;
          userCreateAt = timestamp?.toDate(); // 🔹 `Timestamp` → `DateTime` 변환

          userName     = data['name'] ?? '';
          userPhone    = data['num'] ?? '';
          userRole     = data['role'] ?? '일반'; // 기본값 "일반" 등
          // 추가: mystore 필드가 있으면 불러오기
          userMyStore = data['mystore'] ?? '';

          // ★ 주소 관련 필드 불러오기
          addressName = data['addressName'] ?? '';
          latitude    = data['latitude'];
          longitude   = data['longitude'];

          // 추가된 필드들
          detailAddress = data['detailAddress'] ?? '';
          directions = data['directions'] ?? '';
          addressType = data['addressType'] ?? '기타';
        } else {
          userName = '문서가 존재하지 않습니다.';
        }
      } else {
        // 로그인 안 된 상태면
        userUid     = '';
        userEmail = '';
        userName = '';
        userPhone = '입력된번호가 없음ㅁ';
        userRole = '';
        userCreateAt = null;
        userMyStore = '';

        // 주소 관련 필드 초기화
        addressName = '';
        latitude = null;
        longitude = null;
        detailAddress = '';
        directions = '';
        addressType = '기타';
      }
    } catch (e) {
      debugPrint('loadUserInfo 실패: $e');
      userName = '데이터 로드 오류 발생.';
    }

    _isLoading = false;
    notifyListeners(); // 로딩 완료 후 UI 갱신
  }
}