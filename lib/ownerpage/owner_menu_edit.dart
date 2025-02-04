import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:coupangeats/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart'; // 📌 Firestore 추가;

class OwnerMenuEdit extends StatefulWidget {
  const OwnerMenuEdit({
    super.key,
    required this.storeId,
    required this.categoryId,
    this.menuName,
    this.menuPrice,
    this.menuId,
  });

  final String storeId;
  final String categoryId;
  final menuId;
  final menuName;
  final menuPrice;

  @override
  State<OwnerMenuEdit> createState() => _OwnerMenuEditState();
}

class _OwnerMenuEditState extends State<OwnerMenuEdit> {
  File? _image;
  String? _imageUrl; // 📌 업로드된 이미지의 URL 저장
  Future<void> _showImagePicker() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('갤러리에서 선택'),
              onTap: () {
                _pickImage(ImageSource.gallery); // 📌 갤러리에서 이미지 선택
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('카메라로 촬영'),
              onTap: () {
                _pickImage(ImageSource.camera); // 📌 카메라 촬영
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // 📌 이미지 선택 함수
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _uploadImage(_image!);
    }
  }

  // 📌 ImgBB에 이미지 업로드
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

      debugPrint("업로드된 이미지 URL: $_imageUrl"); // 📌 이미지 URL 출력
      // 📌 업로드 후 Firestore 저장 실행
      _saveImageUrlToFirestore(imageUrl);
    } else {
      debugPrint("이미지 업로드 실패: ${response.statusCode}");
    }
  }

  /// 📌 Firestore에 이미지 URL 저장 (필드가 없으면 추가, 있으면 업데이트)
  Future<void> _saveImageUrlToFirestore(String imageUrl) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('stores')
          .doc(widget.storeId)
          .collection('categories')
          .doc(widget.categoryId)
          .collection('menus')
          .doc(widget.menuId);

      await docRef.set(
        {'foodimgurl': imageUrl},
        SetOptions(merge: true),
      );

      debugPrint("✅ Firestore 이미지 URL 저장 성공! ID: ${widget.menuId}, URL: $imageUrl");
    } catch (e) {
      debugPrint("❌ Firestore 저장 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("메뉴수정", style: title1),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("메뉴사진", style: title1),
            Center(
              child: GestureDetector(
                onTap: _showImagePicker,
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.file(
                          _image!,
                          width: 250,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, color: Colors.grey, size: 50),
                          Text(
                            "사진 추가",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            dividerLine,
            Text(
              "메뉴정보",
              style: title1,
            ),
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              height: 50,
              alignment: Alignment.centerLeft,
              decoration: BorderBox,
              child: Text(widget.menuName.toString()),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                  width: 150,
                  height: 50,
                  decoration: BorderBox,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  width: 100,
                  height: 50,
                  decoration: BorderBox,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(widget.menuPrice.toString()),
                      Text(
                        "원",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ],
            ),
            TextButton(
                onPressed: () {},
                child: Row(
                  children: [Icon(Icons.add), Text("가격추가")],
                )),
            dividerLine,
            Row(
              children: [Text("품절", style: title1)],
            ),
            dividerLine,
            Row(
              children: [Text("숨김", style: title1)],
            ),
            dividerLine,
            Text("메뉴카테고리", style: title1),
            SizedBox(height: 15),
            Container(
              height: 50,
              decoration: BorderBox,
            )
          ],
        ),
      ),
    );
  }
}
