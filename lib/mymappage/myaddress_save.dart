// myaddress_save.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coupangeats/theme.dart';

class MyAddressSave extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MyAddressSave({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<MyAddressSave> createState() => _MyAddressSaveState();
}

class _MyAddressSaveState extends State<MyAddressSave> {
  final TextEditingController _addressNameController = TextEditingController();
  final TextEditingController _detailAddressController = TextEditingController();
  final TextEditingController _directionsController = TextEditingController();
  bool _isSaving = false;
  String _addressType = '기타'; // 기본값 설정

  Future<void> _saveAddress() async {
    if (_addressNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('주소명을 입력해주세요.')),
      );
      return;
    }
    setState(() {
      _isSaving = true;
    });
    try {
      // 현재 로그인한 사용자 UID 가져오기
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("사용자가 로그인되어 있지 않습니다.");
      }
      // Firestore의 userinfo 컬렉션(예: signup) 문서를 업데이트
      await FirebaseFirestore.instance
          .collection('signup')
          .doc(user.uid)
          .update({
        'addressName': _addressNameController.text,
        'latitude': widget.latitude,
        'longitude': widget.longitude,
        'detailAddress': _detailAddressController.text,
        'directions': _directionsController.text,
        'addressType': _addressType,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('주소가 저장되었습니다.')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 중 오류 발생: $e')),
      );
    }
    setState(() {
      _isSaving = false;
    });
  }

  @override
  void dispose() {
    _addressNameController.dispose();
    _detailAddressController.dispose();
    _directionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
            SizedBox(width: 8),
            Text(
              '주소 상세 정보',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.withOpacity(0.2),
            height: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 주소 표시 및 WOW 배달 정보
            Row(
              children: [
                Icon(Icons.location_on_outlined, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _addressNameController.text.isEmpty
                            ? "주소를 입력하세요"
                            : _addressNameController.text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "위도: ${widget.latitude.toStringAsFixed(6)}, 경도: ${widget.longitude.toStringAsFixed(6)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'WOW',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '무료배달 가능 지역',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
            Divider(),

            // 상세 주소 입력 필드
            TextField(
              controller: _addressNameController,
              decoration: InputDecoration(
                hintText: '상세주소 (아파트/동/호)',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            Divider(),

            // 길 안내 입력 필드
            TextField(
              controller: _directionsController,
              decoration: InputDecoration(
                hintText: '길 안내 (예: 1층에 올리브영이 있는 오피스텔)',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            Divider(),

            // 주소 유형 선택 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAddressTypeButton(Icons.home_outlined, '집'),
                _buildAddressTypeButton(Icons.business, '회사'),
                _buildAddressTypeButton(Icons.location_on_outlined, '기타'),
              ],
            ),

            Spacer(),

            // 지도에서 위치 확인 버튼
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextButton.icon(
                onPressed: () {
                  // 지도 확인 기능 (추가 구현 필요)
                },
                icon: Icon(Icons.map_outlined, color: Colors.black87),
                label: Text(
                  '지도에서 위치 확인하기',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),

            // 완료 버튼
            SafeArea(
              child: Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.blue.withOpacity(0.6),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    '완료',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 주소 유형 선택 버튼 위젯
  Widget _buildAddressTypeButton(IconData icon, String type) {
    final isSelected = _addressType == type;

    return InkWell(
      onTap: () {
        setState(() {
          _addressType = type;
        });
      },
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.black54,
            ),
            SizedBox(height: 4),
            Text(
              type,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}