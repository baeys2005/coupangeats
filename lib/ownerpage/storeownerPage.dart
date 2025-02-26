import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupangeats/ownerpage/owner_menu.dart';
import 'package:coupangeats/ownerpage/owner_setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:coupangeats/theme.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/store_info_provider.dart';
import '../providers/user_info_provider.dart';
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


  /// 아직 업로드하지 않은 (로컬에만 있는) 이미지 목록
  List<File> _tempLocalImages = [];



  /// PageController - PageView에 사용
  final PageController _pageController = PageController();

  /// 현재 보고있는 페이지 인덱스 (슬라이더 인디케이터를 위해 사용)
  int _currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final userInfoProv = Provider.of<UserInfoProvider>(context, listen: false);
    userInfoProv.loadUserInfo().then((_) {
      // 2. mystore 값이 준비되면, 그 값을 이용해 가게 정보를 불러옴
      final mystoreId = userInfoProv.userMyStore; // mystore에 저장된 가게 문서 ID
      final storeProv = Provider.of<StoreProvider>(context, listen: false);
      storeProv.loadStoreData(mystoreId); // [수정됨] 하드코딩 대신 mystore 사용
    });
    _loadStoreImagesFromFirestore();

  }

  /// Firestore에 저장된 storeImages 불러오기
  Future<void> _loadStoreImagesFromFirestore() async {
    try {
      // [수정됨] _storeId 대신 UserInfoProvider의 userMyStore를 사용
      final storeId = Provider.of<UserInfoProvider>(context, listen: false).userMyStore;
      final docRef =
          FirebaseFirestore.instance.collection('stores').doc(storeId);
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

  /// 바텀시트 열기
  void _openImageManagementBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 높이 제어
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        // StatefulBuilder : 바텀시트 내에서도 setState 가능하도록
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // 1) "갤러리에서 다중 선택" -> 로컬목록(_tempLocalImages)에만 추가
            Future<void> pickImagesFromGallery() async {
              final ImagePicker picker = ImagePicker();
              final List<XFile>? pickedFiles = await picker.pickMultiImage();
              if (pickedFiles == null || pickedFiles.isEmpty) return;

              // 현재 등록된 파일(업로드된 + 로컬) 개수
              int totalCount = _storeImageUrls.length + _tempLocalImages.length;
              int availableSlot = 4 - totalCount; // 최대 4장까지 가능

              // 넘어가면 안내
              if (pickedFiles.length > availableSlot) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("이미지는 최대 4장까지 가능합니다. (남은 슬롯: $availableSlot장)"),
                  ),
                );
                return;
              }

              // File로 변환 -> 로컬목록에 추가
              List<File> newFiles = pickedFiles.map((x) => File(x.path)).toList();
              setModalState(() {
                _tempLocalImages.addAll(newFiles);
              });
            }

            // 2) "카메라" -> 단일 이미지 촬영 -> 로컬목록(_tempLocalImages)에 추가
            Future<void> pickImageFromCamera() async {
              final ImagePicker picker = ImagePicker();
              final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
              if (pickedFile == null) return;

              int totalCount = _storeImageUrls.length + _tempLocalImages.length;
              if (totalCount >= 4) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("이미지는 최대 4장까지 가능합니다.")),
                );
                return;
              }

              setModalState(() {
                _tempLocalImages.add(File(pickedFile.path));
              });
            }

            // 3) "이미지를 추가하시겠습니까? 예" -> 로컬이미지들 업로드 & Firestore 반영
            Future<void> uploadTempLocalImages() async {
              if (_tempLocalImages.isEmpty) {
                Navigator.pop(context);
                return;
              }

              // [수정됨] 기존에 저장된 storeImages 삭제할 때 userInfoProv.userMyStore 사용
              final storeId = Provider.of<UserInfoProvider>(context, listen: false).userMyStore;
              // 0) Firestore의 기존 'storeImages' 필드를 먼저 전부 삭제
              final docRef = FirebaseFirestore.instance.collection('stores').doc(storeId);
              await docRef.update({'storeImages': FieldValue.delete()});

              List<String> uploadedUrls = [];
              for (File file in _tempLocalImages) {
                String? imageUrl = await uploadImageToImgBB(file);
                if (imageUrl != null) {
                  uploadedUrls.add(imageUrl);
                }
              }

              if (uploadedUrls.isNotEmpty) {
                // 기존 이미지 + 새로 업로드한 이미지
                List<String> newList = [..._storeImageUrls, ...uploadedUrls];
                // 4장 초과 시 잘라내기
                if (newList.length > 4) {
                  newList = newList.take(4).toList();
                }

                await saveStoreImagesToFirestore(storeId, newList);

                // state 갱신
                setState(() {
                  _storeImageUrls = newList;
                  _tempLocalImages.clear();
                });
              }

              Navigator.pop(context);
            }

            return FractionallySizedBox(
              heightFactor: 0.75, // 화면 높이 75% 정도
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16)),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 상단 드래그바
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            margin: EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),

                        Text(
                          "가게사진을 추가해주세요",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "직사각형(200*100)권장",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,color: Colors.black12
                          ),
                          textAlign: TextAlign.left,

                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton( onPressed: pickImagesFromGallery, icon: Icon(Icons.photo_library)),
                            IconButton(onPressed: pickImageFromCamera,icon: Icon(Icons.camera_alt)

                            ),
                          ],
                        ),
                        SizedBox(height: 10),

                        // (A) Firestore + 로컬 이미지 함께 보여주기
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Firestore 이미지들
                                ..._storeImageUrls.map(
                                      (imgUrl) => _buildImageItem(imgUrl: imgUrl),
                                ),
                                // 로컬 이미지들
                                ..._tempLocalImages.map(
                                      (file) => _buildImageItem(file: file),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(child: Text("사진추가시 기존에 저장된 이미지는 삭제됩니다.",style: TextStyle(color: Colors.grey),)),


                        // (B) 버튼들: 갤러리 / 카메라


                        SizedBox(height: 16),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          ElevatedButton(
                            onPressed: uploadTempLocalImages,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: Size(100, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // 모서리를 직각으로 설정
                              ),
                            ),
                            child: Text(
                              "사진추가",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 20,),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey.shade50,
                              minimumSize: Size(100, 50),shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // 모서리를 직각으로 설정
                            ),
                            ),
                            child: Text("닫기",
                                style: TextStyle(fontSize: 16, color: Colors.blue)),
                          ),
                        ],)


                      ],
                    ),
                  ),
                ),
              ),
            );
          },
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
      // [수정됨] 기존 _storeId 대신, UserInfoProvider의 mystore 값을 사용
      final storeId = Provider.of<UserInfoProvider>(context, listen: false).userMyStore;
      await saveStoreImagesToFirestore(storeId, newList);
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
      // [수정됨] 기존 _storeId 대신, UserInfoProvider의 mystore 값을 사용
      final storeId = Provider.of<UserInfoProvider>(context, listen: false).userMyStore;
      await saveStoreImagesToFirestore(storeId, newList);
      setState(() {
        _storeImageUrls = newList;
      });
    }
  }

  /// 직사각형(가로로 넓은) 이미지 위젯 빌더
  /// - [imgUrl]이 있으면 Network 이미지, [file]이 있으면 File 이미지
  Widget _buildImageItem({String? imgUrl, File? file}) {
    return Container(

      width: 320,
      height: 200,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imgUrl != null
            ? Image.network(
          imgUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.broken_image, size: 50, color: Colors.grey);
          },
        )
            : Image.file(file!, fit: BoxFit.cover),
      ),
    );
  }

  //본문
  @override
  Widget build(BuildContext context) {
    final storeProv = Provider.of<StoreProvider>(context);
    final userInfoProv = Provider.of<UserInfoProvider>(context);
    print('폰넘버'+userInfoProv.userPhone);
    return Scaffold(

      body: Container(
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
                    Column(
                      children: [
                        // (1) 이미지 슬라이더 PageView
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _storeImageUrls.isNotEmpty
                                ? _storeImageUrls.length
                                : 1, // 최소 1장(기본이미지)
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              if (_storeImageUrls.isNotEmpty) {
                                // 실제 저장된 이미지를 보여줍니다
                                final imageUrl = _storeImageUrls[index];
                                return Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      'https://i.ibb.co/JwCxP9br/1000007044.jpg',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                );
                              } else {
                                // 저장된 이미지가 없을 때는 기본이미지 1장을 보여줍니다
                                return Image.network(
                                  'https://i.ibb.co/JwCxP9br/1000007044.jpg',
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                        child: Icon(Icons.broken_image, size: 50));
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 50,)
                      ],
                    ),
                    Positioned(
                      bottom: 100,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _storeImageUrls.isNotEmpty
                              ? _storeImageUrls.length
                              : 1, // 이미지가 없으면 1개짜리 인디케이터
                              (index) {
                            bool isActive = (index == _currentPage);
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: isActive ? 10 : 8,
                              height: isActive ? 10 : 8,
                              decoration: BoxDecoration(
                                color: isActive ? Colors.white : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                        right: 10,
                        top: 20,
                        child: IconButton(
                          onPressed: () {
                            _openImageManagementBottomSheet();
                          },
                          icon: Material(
                            elevation: 5.0, // 그림자 높이
                            shape: CircleBorder(), // 아이콘 버튼이 원형이라면 CircleBorder 사용
                            shadowColor: Colors.black, // 그림자 색상
                            color: Colors.transparent, // 배경을 투명하게 유지
                            child: Icon(Icons.image, color: Colors.white, size: 30),
                          ),
                        ),),
                    // 2) 텍스트만큼만 폭을 차지하며, 아래쪽에 위치
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // 그림자 색상
                                offset: const Offset(-5, 0), // 왼쪽 그림자
                                blurRadius: 7,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // 그림자 색상
                                offset: const Offset(5, 0), // 오른쪽 그림자
                                blurRadius: 7,
                              ),
                        ],),
                        child: Container(
                            color: Colors.white,
                            width: 300,
                            height: 120, //글자상자 높이
                            child: Center(
                              child: Text(
                                storeProv.storeName,
                                style: pagetitle1,
                              ),
                            ),
                          ),
                      ),
                    ),
                  ],
                ),

                //여기서 오류남 긍아ㅏ앙ㄱ
                SizedBox(
                  height: 20,
                ),
                Text(
                  userInfoProv.userEmail,
                  style: pagebody1,
                ),
                Text(
                  userInfoProv.userPhone,//아니 숫자 왜 안뜸?
                  style: pagebody1,
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
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
                          return OwnerSetting();
                        }));
                      },
                      child: Column(
                        children: [
                          Icon(Icons.store_mall_directory_outlined),
                          Text('가게설정'),
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
