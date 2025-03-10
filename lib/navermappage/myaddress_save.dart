// myaddress_save.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool _isSaving = false;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주소 저장'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '현재 좌표: (${widget.latitude}, ${widget.longitude})',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _addressNameController,
              decoration: const InputDecoration(
                labelText: '주소명 입력',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveAddress,
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('주소 저장'),
            )
          ],
        ),
      ),
    );
  }
}
