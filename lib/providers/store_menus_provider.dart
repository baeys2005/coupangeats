import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//editor 하연: 가게메뉴 관련 프로바이더
/// [OptionModel] : 메뉴 1개에 속한 옵션 정보
class OptionModel {
  final String optionId;
  final String name;
  final int price;

  OptionModel({
    required this.optionId,
    required this.name,
    required this.price,
  });
}

/// [MenuModel] : 카테고리 1개에 속한 메뉴 정보
class MenuModel {
  final String menuId;
  final String name;
  final int price;
  final List<OptionModel> options;

  MenuModel({
    required this.menuId,
    required this.name,
    required this.price,
    required this.options,
  });
}

/// [CategoryModel] : 가게 1개에 속한 카테고리 정보
class CategoryModel {
  final String categoryId;
  final String name;               // 예: categoryDoc.data()['name']
  final List<MenuModel> menus;

  CategoryModel({
    required this.categoryId,
    required this.name,
    required this.menus,
  });
}

/// [StoreMenusProvider] : 특정 storeId의 카테고리, 메뉴, 옵션 정보를 한 번에 불러와 관리
class StoreMenusProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 불러온 전체 카테고리 목록
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  /// Firestore에서 storeId 하위의 'categories' 컬렉션,
  /// 그리고 각 category 문서 아래 'menus' 서브컬렉션,
  /// 그리고 각 menu 문서 아래 'options' 서브컬렉션을 불러옵니다.
  Future<void> loadStoreMenus(String storeId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final storeRef =
      FirebaseFirestore.instance.collection('stores').doc(storeId);

      // 1) 카테고리 목록 가져오기
      final categoriesSnapshot = await storeRef.collection('categories').get();

      List<CategoryModel> tempCategories = [];//모든 카테고리 리스트에 저장

      for (final categoryDoc in categoriesSnapshot.docs) {
        final catId = categoryDoc.id;
        final catData = categoryDoc.data();
        final catName = catData['name'] ?? catId; // name 필드 없으면 문서 ID 대체

        // 2) 해당 카테고리의 메뉴 목록 가져오기
        final menusSnapshot =
        await categoryDoc.reference.collection('menus').get();
        List<MenuModel> tempMenus = [];

        for (final menuDoc in menusSnapshot.docs) {
          final menuId = menuDoc.id;
          final menuData = menuDoc.data();
          final menuName = menuData['name'] ?? '이름 없는 메뉴';
          final menuPrice = menuData['price'] ?? 0;

          // 3) 해당 메뉴의 옵션 목록 가져오기
          final optionsSnapshot =
          await menuDoc.reference.collection('options').get();
          List<OptionModel> tempOptions = [];

          for (final optDoc in optionsSnapshot.docs) {
            final optId = optDoc.id;
            final optData = optDoc.data();
            final optName = optData['name'] ?? '옵션';
            final optPrice = optData['price'] ?? 0;

            tempOptions.add(OptionModel(
              optionId: optId,
              name: optName,
              price: optPrice,
            ));
          }

          tempMenus.add(
            MenuModel(
              menuId: menuId,
              name: menuName,
              price: menuPrice,
              options: tempOptions,
            ),
          );
        }

        tempCategories.add(
          CategoryModel(
            categoryId: catId,
            name: catName,
            menus: tempMenus,
          ),
        );
      }

      _categories = tempCategories;

    } catch (e) {
      print('❌ loadStoreMenus 실패: $e');
      // 오류가 나면 빈 목록 유지 or 에러 상태 표시
      _categories = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
