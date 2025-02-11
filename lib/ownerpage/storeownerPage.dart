import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupangeats/ownerpage/owner_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:coupangeats/theme.dart';

import 'storeowner_images_util.dart';

//사장님페이지

class Storeownerpage extends StatefulWidget {
  const Storeownerpage({super.key});

  @override
  State<Storeownerpage> createState() => _StoreownerpageState();
}

class _StoreownerpageState extends State<Storeownerpage> {

  /// 최대 4장 이미지 URL 보관할 리스트
  List<String> _storeImageUrls = [];

  /// Firestore 상의 storeId (예: 현재 로그인 유저와 연결, 또는 이미 알고있는 storeId)
  /// 실제로는 인증 로직이나 다른 방식으로 storeId를 구해야 합니다.
  final String _storeId = "store123";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadStoreImagesFromFirestore();
  }

  /// Firestore에 저장된 storeImages 불러오기
  Future<void> _loadStoreImagesFromFirestore() async {
    try {
      final docRef =
      FirebaseFirestore.instance.collection('stores').doc(_storeId);
      final docSnap = await docRef.get();
      if (docSnap.exists) {
        final data = docSnap.data();
        if (data != null && data.containsKey('storeImages')) {
          List<dynamic> storedImages = data['storeImages'];
          // String List 로 캐스팅
          List<String> imageUrls =
          storedImages.map((e) => e.toString()).toList();
          setState(() {
            _storeImageUrls = imageUrls;
          });
        }
      }
    } catch (e) {
      debugPrint("Firestore storeImages 로드 실패: $e");
    }
  }
  /// 이미지 선택 BottomSheet 열기
  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('갤러리에서 이미지 선택 (다중)'),
                onTap: () {
                  _pickMultipleImages();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('카메라로 촬영 (단일)'),
                onTap: () {
                  _pickSingleImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  /// 1) 갤러리에서 다중 이미지를 선택(최대 4장)
  Future<void> _pickMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles == null || pickedFiles.isEmpty) {
      return; // 아무것도 선택안함
    }

    if (pickedFiles.length > 4) {
      // 4장 초과 선택 시 알림
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("이미지는 최대 4장까지만 선택 가능합니다."),
        ),
      );
      return;
    }

    // 선택한 만큼 업로드 진행
    List<String> uploadedUrls = [];

    for (var file in pickedFiles) {
      File imageFile = File(file.path);

      // ImgBB 업로드 (재사용)
      String? imageUrl = await uploadImageToImgBB(imageFile);

      if (imageUrl != null) {
        uploadedUrls.add(imageUrl);
      }
    }

    // 업로드된 URL들을 Firestore에 저장
    if (uploadedUrls.isNotEmpty) {
      // 기존 저장된 이미지에 덧붙이는 형태인지, 완전히 새로 덮어쓰는지 결정
      // 여기는 "덮어쓰기" 혹은 "이어붙이기" 예시
      // 1) 기존 _storeImageUrls + 새로 업로드된 URL 합치기
      List<String> newList = [..._storeImageUrls, ...uploadedUrls];

      // 만약 최대 4장 제한을 Firestore에서도 보장해야 한다면
      // newList = newList.take(4).toList();

      await saveStoreImagesToFirestore(_storeId, newList);
      setState(() {
        _storeImageUrls = newList; // UI 갱신
      });
    }
  }
  /// 2) 카메라로 단일 이미지 촬영 & 업로드 (필요시)
  Future<void> _pickSingleImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    String? imageUrl = await uploadImageToImgBB(imageFile);
    if (imageUrl != null) {
      List<String> newList = [..._storeImageUrls, imageUrl];
      // 최대 4장으로 제한
      if (newList.length > 4) {
        newList = newList.take(4).toList();
      }
      await saveStoreImagesToFirestore(_storeId, newList);
      setState(() {
        _storeImageUrls = newList;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20),

        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // 1) 배경 이미지
                    Image.network(
                      'https://i.ibb.co/JwCxP9br/1000007044.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: Icon(
                        Icons.image,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                    // 2) 텍스트만큼만 폭을 차지하며, 아래쪽에 위치
                    Positioned(
                      bottom: 0,
                      child: Container(
                        color: Colors.white.withOpacity(0.9),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          '배윤선 사장님',
                          style: pagetitle1,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),

                  child: Text(
                    '맛있는카레집',
                    style: pagetitle1,
                  ),
                ),
                //여기서 오류남 긍아ㅏ앙ㄱ
                SizedBox(
                  height: 20,
                ),
                Text(
                  'beayes@naver.com',
                  style: pagebody1,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '010-****-****',
                  style: pagebody1,
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black12, width: 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) {
                          return OwnerMenu();
                        }));
                      },
                      child: Column(
                        children: [
                          Icon(Icons.menu_book),
                          Text('메뉴관리'),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) {
                          return OwnerMenu();
                        }));
                      },
                      child: Column(
                        children: [
                          Icon(Icons.monetization_on_outlined),
                          Text('수익관리'),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) {
                          return OwnerMenu();
                        }));
                      },
                      child: Column(
                        children: [
                          Icon(Icons.store_mall_directory_outlined),
                          Text('가게설정'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

var buttonsizefix = ElevatedButton.styleFrom(
  fixedSize: Size(60, 60), // 정사각형 크기
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5), // 모서리를 각지게 설정
  ),
);
