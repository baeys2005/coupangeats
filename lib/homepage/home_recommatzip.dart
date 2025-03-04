import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class HomeRecommatzip extends StatefulWidget {
  const HomeRecommatzip({Key? key}) : super(key: key);

  @override
  State<HomeRecommatzip> createState() => _HomeRecommatzipState();
}

class _HomeRecommatzipState extends State<HomeRecommatzip> {
  bool _isLoading = true;
  String _errorMessage = '';
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Firebase 초기화 상태 확인
      try {
        Firebase.app();
      } catch (e) {
        // 앱이 초기화되지 않았다면 초기화
        try {
          await Firebase.initializeApp();
        } catch (initError) {
          print("Firebase 초기화 오류: $initError");
          setState(() {
            _isLoading = false;
            _errorMessage = "데이터를 로드할 수 없습니다.";
          });
          return;
        }
      }

      // 데이터 로드 - 원래 파일의 컬렉션 이름으로 변경하세요
      final snapshot =
          await FirebaseFirestore.instance.collection('recommatzip').get();

      setState(() {
        _data = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print("데이터 로드 오류: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "데이터를 로드할 수 없습니다.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage,
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    // 여기서 SliverToBoxAdapter를 반환하여 일관성 유지
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "추천 맛집",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 데이터 목록 표시
          _data.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: Text("추천 맛집이 없습니다")),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    final item = _data[index];
                    return ListTile(
                      title: Text(item['name'] ?? '이름 없음'),
                      subtitle: Text(item['description'] ?? '설명 없음'),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
