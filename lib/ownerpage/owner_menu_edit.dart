import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:coupangeats/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
//editor  하연: 메뉴수정
class OwnerMenuEdit extends StatefulWidget {
  const OwnerMenuEdit({
    super.key,
    required this.storeId,
    required this.categoryId,
    required this.menuId,
    this.menuName,
    this.menuPrice,
  });

  final String storeId;
  final String categoryId;
  final String menuId;
  final String? menuName;
  final int? menuPrice;

  @override
  State<OwnerMenuEdit> createState() => _OwnerMenuEditState();
}

class _OwnerMenuEditState extends State<OwnerMenuEdit> {
  // 이미지 관련
  File? _image;
  String? _imageUrl;

  // 메인 데이터(이름, 가격, 품절, 숨김, 카테고리) 컨트롤러·변수
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  bool _isSoldOut = false;
  bool _isHidden = false;

  // 📌 변경/추가 1) 카테고리 목록 & 현재 선택된 카테고리
  List<String> _allCategories = [];
  String _selectedCategory = ''; // 드롭다운에서 선택된 카테고리
  @override
  void initState() {
    super.initState();
    // 초기 값 세팅 (위젯에 넘겨받은 값 -> Firestore에서 별도 값이 있을 시 덮어쓸 예정)
    _nameController.text = widget.menuName ?? '';
    if (widget.menuPrice != null) {
      _priceController.text = widget.menuPrice.toString();

    }

    // Firestore에서 기존 메뉴 정보 불러오기 (이미지 / 추가 필드)
    _loadMenuDataFromFirestore();
    _fetchAllCategories(); // 📌 추가: 전체 카테고리 목록 가져오기
  }

  // ----- [1] 전체 카테고리 목록 불러오기 ----------------------------
  Future<void> _fetchAllCategories() async {
    try {
      final storeRef = FirebaseFirestore.instance
          .collection('stores')
          .doc(widget.storeId);

      final querySnap = await storeRef.collection('categories').get();

      final List<String> categoryNames = [];
      for (var doc in querySnap.docs) {
        // 문서 ID 자체를 카테고리로 사용한다고 가정
        categoryNames.add(doc.id);
      }

      setState(() {
        _allCategories = categoryNames;
      });
    } catch (e) {
      debugPrint('카테고리 목록 불러오기 실패: $e');
    }
  }

  // ---- [Firestore에서 기존 문서 불러오기] ---------------------------------------
  Future<void> _loadMenuDataFromFirestore() async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('stores')
          .doc(widget.storeId)
          .collection('categories')
          .doc(widget.categoryId)
          .collection('menus')
          .doc(widget.menuId);

      final docSnap = await docRef.get();
      if (!docSnap.exists) {
        // 문서가 없으면 -> 기본값 그대로 (새 메뉴)
        return;
      }
      final data = docSnap.data();
      if (data == null) return;

      // 1) 이미지 URL
      if (data.containsKey('foodimgurl')) {
        final existingUrl = data['foodimgurl'] as String?;
        if (existingUrl != null && existingUrl.isNotEmpty) {
          setState(() {
            _imageUrl = existingUrl;
          });
        }
      }
      // 2) 메뉴 이름
      if (data.containsKey('menuName')) {
        _nameController.text = data['menuName'] ?? '';
      }
      // 3) 가격
      if (data.containsKey('menuPrice')) {
        final priceVal = data['menuPrice'];
        if (priceVal != null) {
          _priceController.text = priceVal.toString();
        }
      }
      // 4) 품절 여부
      if (data.containsKey('isSoldOut')) {
        _isSoldOut = data['isSoldOut'] == true;
      }
      // 5) 숨김 여부
      if (data.containsKey('isHidden')) {
        _isHidden = data['isHidden'] == true;
      }
      // 6) 메뉴 카테고리 (메뉴별 추가 카테고리)
      if (data.containsKey('menuCategory')) {
        _categoryController.text = data['menuCategory'] ?? '';
      }

      // 📌 변경/추가 2) 현재 문서가 있는 카테고리를 _selectedCategory로 설정
      //    (즉, 초기 드롭다운 값)
      setState(() {
        _selectedCategory = widget.categoryId;
        // 또는, data 안에 'categoryId'를 별도로 저장해둔 경우 그걸 써도 됨
      });
    } catch (e) {
      debugPrint("Firestore 메뉴 데이터 로드 실패: $e");
    }
  }

  // ---- [ImgBB로 이미지 업로드하기] ---------------------------------------------
  Future<void> _showImagePicker() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('갤러리에서 선택'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('카메라로 촬영'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _uploadImage(_image!);
    }
  }

  // ImgBB에 업로드 후, 성공 시 URL을 Firestore에 저장
  Future<void> _uploadImage(File imageFile) async {
    final uri = Uri.parse(
        "https://api.imgbb.com/1/upload?key=6ceb0f5b3409f424c1d15591ecf215c3");
    final request = http.MultipartRequest("POST", uri)
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      final imageUrl = jsonResponse['data']['url'];

      setState(() {
        _imageUrl = imageUrl;
      });

      debugPrint("업로드된 이미지 URL: $_imageUrl");
      _saveImageUrlToFirestore(imageUrl);
    } else {
      debugPrint("이미지 업로드 실패: ${response.statusCode}");
    }
  }

  Future<void> _saveImageUrlToFirestore(String imageUrl) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('stores')
          .doc(widget.storeId)
          .collection('categories')
          .doc(widget.categoryId)
          .collection('menus')
          .doc(widget.menuId);

      await docRef.set({'foodimgurl': imageUrl}, SetOptions(merge: true));
      debugPrint("✅ Firestore 이미지 URL 저장 성공! ID: ${widget.menuId}, URL: $imageUrl");
    } catch (e) {
      debugPrint("❌ Firestore 저장 실패: $e");
    }
  }

  // ---- [메뉴 정보 전체 저장] ---------------------------------------------------
  // ----- [4] 저장 버튼 로직: 카테고리 이동/삭제/생성 처리 ---------------
  Future<void> _saveMenuInfo() async {
    final name = _nameController.text.trim();
    final priceString = _priceController.text.trim();
    int parsedPrice = 0;
    if (priceString.isNotEmpty) {
      parsedPrice = int.tryParse(priceString) ?? 0;
    }

    // 1) 이동 전에, 변경된 데이터(품절/숨김 등) 준비
    final updatedData = {
      'menuName': name,
      'menuPrice': parsedPrice,
      'isSoldOut': _isSoldOut,
      'isHidden': _isHidden,
      // foodimgurl 는 이미 업로드 후 저장됨(위 _saveImageUrlToFirestore).
      // 그러나 만약 카테고리가 바뀌면 새 문서에도 이 필드가 필요하므로 아래서 문서 복사 시 가져와야 함.
    };

    // 2) 카테고리를 변경하지 않았다면 -> 기존 문서만 업데이트
    if (_selectedCategory == widget.categoryId) {
      try {
        final oldDocRef = FirebaseFirestore.instance
            .collection('stores')
            .doc(widget.storeId)
            .collection('categories')
            .doc(widget.categoryId)
            .collection('menus')
            .doc(widget.menuId);

        await oldDocRef.set(updatedData, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('메뉴 정보가 저장되었습니다. (카테고리 동일)')),
        );
      } catch (e) {
        debugPrint('메뉴 정보 저장 실패: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    } else {
      // 📌 변경/추가 3) 카테고리가 변경된 경우 -> "새 카테고리에 문서 생성" 후 "기존 카테고리 문서 삭제"
      try {
        final storeRef = FirebaseFirestore.instance.collection('stores').doc(widget.storeId);

        // (1) 먼저 기존 문서(foodimgurl 포함) 전체 데이터를 불러와서 Map으로 복사
        final oldDocRef = storeRef
            .collection('categories')
            .doc(widget.categoryId)
            .collection('menus')
            .doc(widget.menuId);

        final oldDocSnap = await oldDocRef.get();
        final oldData = oldDocSnap.data() ?? {};
        // oldData를 updatedData로 덮어씌워 최종 데이터로 만듦
        // (사용자가 변경한 내용이 우선순위)
        final newDataForCreation = {
          ...oldData,
          ...updatedData,
        };

        // (2) 새 카테고리에 동일한 docID 로 문서 생성
        final newDocRef = storeRef
            .collection('categories')
            .doc(_selectedCategory)
            .collection('menus')
            .doc(widget.menuId); // 문서 ID 재사용

        await newDocRef.set(newDataForCreation, SetOptions(merge: true));

        // (3) 기존 문서 삭제
        await oldDocRef.delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('메뉴 정보가 저장되었습니다. 메뉴창 재로딩시 반영(카테고리 변경: $_selectedCategory)'),
          ),
        );
      } catch (e) {
        debugPrint('카테고리 이동 중 오류: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('카테고리 이동 실패: $e')),
        );
      }
    }
  }


  // ---- [UI 빌드] --------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("메뉴수정", style: title1),
        backgroundColor: Colors.white,
        leading: BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1) 메뉴사진
            Text("메뉴사진", style: title1),
            const SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: _showImagePicker,
                child: _imageUrl != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    _imageUrl!,
                    width: 250,
                    height: 160,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 250,
                          height: 160,
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        width: 250,
                        height: 160,
                        child: Center(
                          child: Icon(Icons.broken_image, size: 50),
                        ),
                      );
                    },
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_a_photo, color: Colors.grey, size: 50),
                    Text(
                      "사진 추가",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            dividerLine,

            // 2) 메뉴 정보
            Text("메뉴정보", style: title1),
            const SizedBox(height: 15),

            // 메뉴 이름
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "메뉴 이름",
                labelStyle: const TextStyle(color: Colors.black54),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(4),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 메뉴 가격
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "메뉴 가격",
                      labelStyle: const TextStyle(color: Colors.black54),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text("원", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),

            // 가격 추가 버튼 (기능은 예시이므로 구현은 생략)
            TextButton(
              onPressed: () {
                // TODO: 여러 옵션 가격 추가 로직 등 필요하다면 구현
              },
              child: Row(
                children: const [
                  Icon(Icons.add),
                  Text("가격추가", style: TextStyle(fontSize: 16,color: Colors.blue)),
                ],
              ),
            ),
            dividerLine,

            // 3) 품절 (Switch)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("품절", style: title1),
                Switch(
                  value: _isSoldOut,
                  onChanged: (bool value) {
                    setState(() {
                      _isSoldOut = value;
                    });
                  },
                ),
              ],
            ),
            dividerLine,

            // 4) 숨김 (Switch)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("숨김", style: title1),
                Switch(
                  value: _isHidden,
                  onChanged: (bool value) {
                    setState(() {
                      _isHidden = value;
                    });
                  },
                ),
              ],
            ),
            dividerLine,

            // 📌 변경/추가 4) 카테고리 선택 (드롭다운)
            Text("메뉴카테고리", style: title1),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _selectedCategory.isNotEmpty ? _selectedCategory : null,
              hint: const Text("카테고리 선택"),
              items: _allCategories.map((String cat) {
                return DropdownMenuItem<String>(
                  value: cat,
                  child: Text(cat),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                }
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(4),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 저장 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveMenuInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '저장',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 편의를 위해 공용으로 쓰는 구분선
  Widget get dividerLine => const Padding(
    padding: EdgeInsets.symmetric(vertical: 16),
    child: Divider(
      color: Colors.black12,
      thickness: 1,
    ),
  );

  // BoxDecoration 스타일 (문제에서 사용한 예시 동일 유지)
  BoxDecoration get BorderBox => BoxDecoration(
    border: Border.all(color: Colors.black12),
    borderRadius: BorderRadius.circular(4),
  );
}
