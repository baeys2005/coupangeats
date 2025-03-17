import 'package:coupangeats/ownerpage/owner_menu_UI.dart';
import 'package:coupangeats/ownerpage/owner_menu_edit.dart';
import 'package:flutter/material.dart';
import 'package:coupangeats/theme.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/user_info_provider.dart';
import 'owner_category_edit.dart';

//FirestoreService: 파이어베이스에 메뉴 저장
//class MenuItem : 메뉴 저장용 class
//
//
//
//fetchMenusFromFirebase: 데이터 가져오기

//firebase에 메뉴 저장 함수
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMenuToFirestore({
    required String storeId,
    required String categoryId,
    required MenuItem menuItem,
  }) async {
    try {
      final categoryRef = _firestore
          .collection('stores')
          .doc(storeId)
          .collection('categories')
          .doc(categoryId);

      // 메뉴 추가
      await categoryRef.collection('menus').add({
        'name': menuItem.name,
        'price': menuItem.price,
        'createdAt': FieldValue.serverTimestamp(),
      });

      debugPrint('Menu added successfully.');
    } catch (e) {
      debugPrint('Failed to add menu: $e');
    }
  }
}

class MenuItem {
  final String name; // 메뉴 이름
  final int price; // 메뉴 가격
  final String? imageUrl; // 🔶 메뉴 이미지 URL (Null 가능)

  MenuItem({
    required this.name,
    required this.price,
    this.imageUrl,
  });
}

class OwnerMenu extends StatefulWidget {
  const OwnerMenu({super.key});

  @override
  State<OwnerMenu> createState() => _OwnerMenuState();
}

class _OwnerMenuState extends State<OwnerMenu> {
  //선택된 카테고리
  String _selectedCategory = '식사';

  //카테고리
  final List<String> categories = [
    'Category 1',
    'Category 2',
    'Category 3',
    'Category 4',
  ];

  // 메뉴 데이터 (카테고리별)
  final Map<String, List<MenuItem>> menuItems = {
    '카테고리 로딩중': [],
  };

  // 메뉴 ID를 따로 저장하는 맵 추가
  final Map<String, List<String>> menuIds = {}; // 📌 카테고리별 메뉴 ID 저장ㅊ
  // 메뉴 추가 Dialog 함수.
  void _showAddMenuDialog() {
    final TextEditingController menuNameController = TextEditingController();
    final TextEditingController menuPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$_selectedCategory', // 선택된 카테고리
                  style: modaltitle1.copyWith(
                      color: Colors.blue.shade200), // 회색 스타일 적용
                ),
                TextSpan(
                  text: '에 메뉴 추가', // 나머지 텍스트
                  style: modaltitle1, // 기존 스타일 유지
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: menuNameController,
                decoration: InputDecoration(
                  labelText: '메뉴 이름',
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.black), // 기본(비활성) 밑줄 색상
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue, width: 2), // 포커스(클릭 시) 밑줄 색상
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: menuPriceController,
                decoration: InputDecoration(
                  labelText: '가격',
                  hintText: 'ex) 10000',
                  // 회색 글씨로 표시되는 힌트
                  suffixText: '원',
                  // 오른쪽에 표시되는 텍스트
                  // 기본 테두리 색상 (비활성 상태)
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.black, width: 1), // 기본 검은색 테두리
                  ),

                  // 포커스된 상태 (클릭 시) 테두리 색상 설정
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue, width: 2), // 포커스 시 파란색 테두리
                  ), // 테두리 추가 (옵션)
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog 닫기
              },
              child: const Text('닫기',
                  style: TextStyle(color: Colors.blue, fontSize: 16)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                final String menuName = menuNameController.text;
                final int? menuPrice = int.tryParse(menuPriceController.text);

                // 입력값 디버깅
                debugPrint('Entered Menu Name: $menuName');
                debugPrint('Entered Menu Price: ${menuPriceController.text}');
                debugPrint('Parsed Menu Price: $menuPrice');
                debugPrint(
                    'Selected Category for Addition: $_selectedCategory');

                if (menuName.isNotEmpty && menuPrice != null) {
                  //메뉴리스트를 하나의 변수에 넣어 전달(메뉴정보 묶어서 전달)
                  final newMenuItem =
                  MenuItem(name: menuName, price: menuPrice);

                  // [추가] mystore 값이 로드되었는지 확인
                  final storeId = Provider.of<UserInfoProvider>(context, listen: false).userMyStore;
                  if (storeId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('가게 정보가 아직 로드되지 않았습니다. 잠시 후 다시 시도해주세요.')),
                    );
                    return;
                  }
                  setState(() {
                    // 선택된 카테고리에 메뉴 추가
                    menuItems[_selectedCategory]?.add(
                      MenuItem(name: menuName, price: menuPrice),
                    );

                    // 추가된 메뉴 디버깅
                    debugPrint('Added Menu: $menuName, $menuPrice원');
                    debugPrint('Updated Menus in $_selectedCategory:');
                    for (var menu in menuItems[_selectedCategory]!) {
                      debugPrint('- ${menu.name}: ${menu.price}원');
                    }
                  });

                  // Firebase Firestore에 메뉴 저장
                  await FirestoreService().addMenuToFirestore(
                    storeId: storeId, // 가게 ID (여기서 고정값, 실제로는 동적으로 설정 필요)
                    categoryId: _selectedCategory, // 선택된 카테고리
                    menuItem: newMenuItem,
                  );

                  Navigator.of(context).pop(); // Dialog 닫기
                } else {
                  // 입력값이 비어있거나 유효하지 않을 경우 디버깅 출력
                  debugPrint(
                      'Invalid input: Menu Name or Price is missing or incorrect.');
                }
              },
              child: const Text(
                '저장',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  void fetchMenusFromFirebase() async {
    try {
      debugPrint('Fetching menus from Firebase...');
      final storeId = Provider.of<UserInfoProvider>(context, listen: false).userMyStore;
      final storeRef =
      FirebaseFirestore.instance.collection('stores').doc(storeId);

      // 가게 데이터 확인
      final storeSnapshot = await storeRef.get();
      if (!storeSnapshot.exists) {
        debugPrint('Store with ID $storeId does not exist in Firestore.');
        return;
      }

      final categoriesSnapshot = await storeRef.collection('categories').get();

      // 카테고리 초기화
      categories.clear();
      menuItems.clear();
      menuIds.clear();

      debugPrint(
          'Categories fetched: ${categoriesSnapshot.docs.length} categories found.');

      // 각 카테고리 데이터를 읽어옴
      for (var categoryDoc in categoriesSnapshot.docs) {
        final categoryId = categoryDoc.id; //엥 이게 카테고리 이름인데
        final categoryName = categoryDoc.data()['name'];
        debugPrint(
            'Processing category: $categoryId (ID: $categoryId)'); //카테고리 이름

        // 카테고리 추가
        categories.add(categoryId);

        // 해당 카테고리의 메뉴 가져오기
        final menuSnapshot =
        await categoryDoc.reference.collection('menus').get();
        debugPrint(
            'Menus fetched for category $categoryId: ${menuSnapshot.docs.length} items found.');
        final menuIdList = <String>[];
        final menus = menuSnapshot.docs.map((menuDoc) {
          final menuData = menuDoc.data();
          final imageUrl = menuData['foodimgurl'] as String? ?? '';
          debugPrint('Menu item: ${menuData['name']} - ${menuData['price']}원');

          menuIdList.add(menuDoc.id);
          return MenuItem(
            name: menuData['name'],
            price: menuData['price'],
            imageUrl:
            imageUrl.isNotEmpty ? imageUrl : null, // 빈 문자열일 경우 null로 처리
          );
        }).toList();

        // 메뉴 추가
        menuItems[categoryId] = menus;
        menuIds[categoryId] = menuIdList;
      }

      // 상태 업데이트
      debugPrint('Categories and menus successfully loaded into local state.');
      debugPrint('Categories: $categories');
      debugPrint('Menu Items: $menuItems');
      setState(() {});
    } catch (e) {
      debugPrint('Failed to fetch menus: $e');
    }
  }

  /// 새 카테고리 추가 다이얼로그
  void _showAddCategoryDialog() {
    final TextEditingController categoryNameController =
    TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          title: const Text('새 카테고리 생성',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
          content: TextField(
            style: TextStyle(color: Colors.black),
            controller: categoryNameController,
            decoration: const InputDecoration(
              labelText: '카테고리 이름',
              labelStyle: TextStyle(color: Colors.black),
              hintText: '예) 음료, 식사 등',
              hintStyle: TextStyle(color: Colors.black12),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black), // 기본(비활성) 밑줄 색상
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                BorderSide(color: Colors.blue, width: 2), // 포커스(클릭 시) 밑줄 색상
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기',
                  style: TextStyle(fontSize: 16, color: Colors.blue)),
            ),
            ElevatedButton(
              onPressed: () async {
                final storeId = Provider.of<UserInfoProvider>(context, listen: false).userMyStore;
                final newCategoryName = categoryNameController.text.trim();

                if (newCategoryName.isNotEmpty) {
                  try {
                    // Firestore에 새 카테고리 문서를 "사용자 입력값"으로 ID를 지정하여 생성
                    final storeRef = FirebaseFirestore.instance
                        .collection('stores')
                        .doc(storeId);

                    // doc(카테고리이름)을 그대로 문서 ID로 사용
                    final newCategoryDoc =
                    storeRef.collection('categories').doc(newCategoryName);

                    await newCategoryDoc.set({
                      'createdAt': FieldValue.serverTimestamp(),
                      // 필요에 따라 다른 필드도 저장 가능
                      // 'someOtherField': ...,
                    });

                    // 생성된 문서의 ID(=newCategoryName)
                    final newCategoryId = newCategoryName;

                    debugPrint('New category created with ID: $newCategoryId');

                    // 로컬 상태에도 카테고리 추가
                    setState(() {
                      categories.add(newCategoryId);
                      // 해당 카테고리의 메뉴 리스트도 초기화
                      menuItems[newCategoryId] = [];
                      // [추가] 새 카테고리의 메뉴 ID 리스트도 초기화
                      menuIds[newCategoryId] = [];  // <-- 추가된 부분
                      // 새로 생성한 카테고리를 현재 선택 상태로 변경
                      _selectedCategory = newCategoryId;
                    });

                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  } catch (e) {
                    debugPrint('Failed to create category: $e');
                  }
                } else {
                  debugPrint('Category name is empty!');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                '생성',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchMenusFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "메뉴추가",
          style: title1,
        ),
        actions: [
          // OwnerMenu 혹은 해당 화면에서
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // 현재 선택된 카테고리 이름을 넘김
              showEditCategoryDialog(context, _selectedCategory, (newCategoryName) {
                // 여기서 로컬 상태(카테고리 리스트, 메뉴 맵 등)를 업데이트합니다.
                setState(() {
                  // 예: 기존 카테고리 이름을 새로운 이름으로 교체
                  int index = categories.indexOf(_selectedCategory);
                  if (index != -1) {
                    categories[index] = newCategoryName;
                    // 추가로 menuItems와 menuIds의 키도 업데이트해야 합니다.
                    menuItems[newCategoryName] = menuItems.remove(_selectedCategory) ?? [];
                    menuIds[newCategoryName] = menuIds.remove(_selectedCategory) ?? [];
                    _selectedCategory = newCategoryName;
                  }
                });
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDeleteCategoryDialog(context, _selectedCategory, () {
                // 삭제 후 로컬 상태 업데이트: 해당 카테고리 제거
                setState(() {
                  categories.remove(_selectedCategory);
                  menuItems.remove(_selectedCategory);
                  menuIds.remove(_selectedCategory);
                  // 필요에 따라 다른 처리를 진행 (예: _selectedCategory를 다른 값으로 설정)
                  _selectedCategory = categories.isNotEmpty ? categories.first : '';
                });
              });
            },
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3, // 비율 3
            child: Container(
              child: Center(
                child: ListView.builder(
                  itemCount: categories.length + 1, // +1로 항목 추가
                  itemBuilder: (c, i) {
                    if (i == categories.length) {
                      // 마지막 항목 (categories.length+1)
                      return ListTile(
                        title: const Icon(Icons.add),
                        onTap: _showAddCategoryDialog,
                      );
                    } else {
                      // 일반 카테고리 항목
                      return ListTile(
                        title: Text(
                          categories[i],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black, // 여기에 색상을 명시적으로 지정
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        selected: _selectedCategory == categories[i],
                        selectedTileColor: Colors.blue.shade300,
                        onTap: () {
                          setState(() {
                            _selectedCategory = categories[i];
                          });
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7, // 비율 2
            child: Container(
                color: Colors.white,
                child: ListView.builder(
                    itemCount: menuItems[_selectedCategory]?.length ?? 0,
                    itemBuilder: (c, i) {
                      final menu = menuItems[_selectedCategory]![i];
                      // [수정] menuIds가 비어있다면 빈 문자열을 사용
                      final menuIdList = menuIds[_selectedCategory] ?? [];
                      final menuId = menuIdList.isNotEmpty ? menuIdList[i] : '';
                      return Container(
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          padding: EdgeInsets.all(3),
                          child: ListTile(
                            leading: (menu.imageUrl != null &&
                                menu.imageUrl!.isNotEmpty)
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              // 필요하면 모서리 둥글게
                              child: Image.network(
                                menu.imageUrl!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  // URL이 잘못되었거나 로딩 실패 시 대체
                                  return Icon(Icons.broken_image,
                                      color: Colors.grey);
                                },
                              ),
                            )
                                : imgAddButton, // 이미지가 없으면 기존 아이콘 버튼
                            title: Text(menu.name),
                            subtitle: Text('${menu.price}원'),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (c) {
                                    return OwnerMenuEdit(
                                        storeId: Provider.of<UserInfoProvider>(context, listen: false).userMyStore,
                                        categoryId: _selectedCategory,
                                        menuId: menuId,
                                        menuName: menu.name,
                                        menuPrice: menu.price);
                                  }));
                            },
                          ),
                          decoration: menuTileDecoration);
                    })),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMenuDialog,
        backgroundColor: Colors.blue,
        child: FABchild,
      ),
    );
  }
}