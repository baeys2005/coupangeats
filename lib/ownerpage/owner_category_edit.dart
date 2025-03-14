// owner_category_edit.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupangeats/theme.dart';
import 'package:provider/provider.dart';
import '../providers/user_info_provider.dart';
//editor 하연: 카테고리 수정 다이얼로그
/// 카테고리 이름 수정 다이얼로그
/// [context]: BuildContext
/// [currentCategory]: 기존 카테고리 이름 (문서 ID)
/// [onCategoryUpdated]: 수정 완료 후 새 카테고리 이름을 전달하는 콜백
Future<void> showEditCategoryDialog(
    BuildContext context, String currentCategory, Function(String newCategoryName) onCategoryUpdated) async {
  final TextEditingController _editController = TextEditingController(text: currentCategory);

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('카테고리 수정', style: title1),
        content: TextField(
          controller: _editController,
          decoration: InputDecoration(
            labelText: '새 카테고리 이름',
            hintText: '예) 음료, 식사 등',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('취소', style: TextStyle(color: Colors.blue)),
          ),
          ElevatedButton(
            onPressed: () async {
              final newCategoryName = _editController.text.trim();
              if (newCategoryName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('카테고리 이름을 입력해주세요.')),
                );
                return;
              }
              // [Modified] mystore 값을 사용하여 가게 문서를 참조
              final storeId = Provider.of<UserInfoProvider>(context, listen: false).userMyStore;
              if (storeId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('가게 정보가 로드되지 않았습니다.')),
                );
                return;
              }
              try {
                final storeRef = FirebaseFirestore.instance.collection('stores').doc(storeId);
                final categoryRef = storeRef.collection('categories').doc(currentCategory);
                final newCategoryRef = storeRef.collection('categories').doc(newCategoryName);

                // 기존 카테고리 문서 데이터를 가져옴
                final docSnap = await categoryRef.get();
                if (!docSnap.exists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('기존 카테고리 문서를 찾을 수 없습니다.')),
                  );
                  return;
                }
                final data = docSnap.data() ?? {};

                // 새 카테고리 문서를 생성하면서 데이터 복사 및 수정
                await newCategoryRef.set({
                  ...data,
                  'createdAt': FieldValue.serverTimestamp(),
                  'editedAt': FieldValue.serverTimestamp(),
                });

                // 기존 카테고리 문서 삭제
                await categoryRef.delete();

                onCategoryUpdated(newCategoryName);
                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('카테고리 수정 실패: $e')),
                );
              }
            },
            child: Text('수정', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ],
      );
    },
  );
}

/// 카테고리 삭제 확인 다이얼로그
/// [context]: BuildContext
/// [categoryName]: 삭제할 카테고리 이름 (문서 ID)
/// [onCategoryDeleted]: 삭제 성공 후 호출되는 콜백
Future<void> showDeleteCategoryDialog(
    BuildContext context, String categoryName, Function() onCategoryDeleted) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('카테고리 삭제', style: title1),
        content: Text('정말로 "$categoryName" 카테고리를 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('취소', style: TextStyle(color: Colors.blue)),
          ),
          ElevatedButton(
            onPressed: () async {
              // [Modified] mystore 값을 사용하여 가게 문서를 참조
              final storeId = Provider.of<UserInfoProvider>(context, listen: false).userMyStore;
              if (storeId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('가게 정보가 로드되지 않았습니다.')),
                );
                return;
              }
              try {
                final storeRef = FirebaseFirestore.instance.collection('stores').doc(storeId);
                final categoryRef = storeRef.collection('categories').doc(categoryName);
                await categoryRef.delete();
                onCategoryDeleted();
                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('카테고리 삭제 실패: $e')),
                );
              }
            },
            child: Text('삭제', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      );
    },
  );
}
