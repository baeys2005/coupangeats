import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
//editor  하연: 가게이미지 함수
/// 1) ImgBB 업로드를 위한 함수
/// 파일을 넣으면 업로드 후 다운로드 URL 반환
Future<String?> uploadImageToImgBB(File imageFile) async {
  try {
    final uri = Uri.parse(
        "https://api.imgbb.com/1/upload?key=6ceb0f5b3409f424c1d15591ecf215c3");
    final request = http.MultipartRequest("POST", uri)
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      final imageUrl = jsonResponse['data']['url'];
      debugPrint("업로드된 이미지 URL: $imageUrl");
      return imageUrl;
    } else {
      debugPrint("이미지 업로드 실패: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    debugPrint("이미지 업로드 에러: $e");
    return null;
  }
}

/// 2) Firestore에 가게 이미지 배열로 저장하는 함수
///
/// 기존에 `OwnerMenuEdit`에서는 단일 이미지(`foodimgurl`)만 저장했지만
/// 여기서는 [imageUrls] 배열을 통째로 저장(merge)한다.
///
/// [storeId] 문서 아래에 `"storeImages"` 필드가 없으면 생성, 있으면 업데이트.
Future<void> saveStoreImagesToFirestore(String storeId, List<String> imageUrls) async {
  try {
    final docRef = FirebaseFirestore.instance.collection('stores').doc(storeId);

    // Firestore에 'storeImages' 라는 필드로 배열 저장
    await docRef.set(
      {'storeImages': imageUrls},
      SetOptions(merge: true),
    );

    debugPrint("✅ Firestore 가게이미지 URL 배열 저장 성공! storeId: $storeId");
  } catch (e) {
    debugPrint("❌ Firestore 저장 실패: $e");
  }
}
