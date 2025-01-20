import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


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

      print('Menu added successfully.');
    } catch (e) {
      print('Failed to add menu: $e');
    }
  }
}
class MenuItem {
  final String name; // 메뉴 이름
  final int price; // 메뉴 가격

  MenuItem({required this.name, required this.price});
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
    'Category 1': [
      MenuItem(name: 'Curry', price: 10000),
      MenuItem(name: 'Rice', price: 8000),
      MenuItem(name: 'Soup', price: 7000),
    ],
    'Category 2': [
      MenuItem(name: 'Pizza', price: 15000),
      MenuItem(name: 'Pasta', price: 12000),
      MenuItem(name: 'Salad', price: 9000),
    ],
    'Category 3': [
      MenuItem(name: 'Burger', price: 11000),
      MenuItem(name: 'Fries', price: 5000),
      MenuItem(name: 'Shake', price: 6000),
    ],
    'Category 4': [
      MenuItem(name: 'Steak', price: 20000),
      MenuItem(name: 'Wine', price: 30000),
      MenuItem(name: 'Dessert', price: 10000),
    ],
  };

  //각메뉴 정보 저장 .

  // 메뉴 추가 Dialog 함수.
  void _showAddMenuDialog() {
    final TextEditingController menuNameController = TextEditingController();
    final TextEditingController menuPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$_selectedCategory에 메뉴 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: menuNameController,
                decoration: InputDecoration(labelText: '메뉴 이름'),
              ),
              SizedBox(height: 30),
              TextField(
                controller: menuPriceController,
                decoration: InputDecoration(labelText: '가격',
                  hintText: 'ex) 10000', // 회색 글씨로 표시되는 힌트
                  suffixText: '원', // 오른쪽에 표시되는 텍스트
                  border: OutlineInputBorder(), // 테두리 추가 (옵션)
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
              child: const Text('닫기'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String menuName = menuNameController.text;
                final int? menuPrice = int.tryParse(menuPriceController.text);

                // 입력값 디버깅
                print('Entered Menu Name: $menuName');
                print('Entered Menu Price: ${menuPriceController.text}');
                print('Parsed Menu Price: $menuPrice');
                print('Selected Category for Addition: $_selectedCategory');

                if (menuName.isNotEmpty && menuPrice != null) {
                  //메뉴리스트를 하나의 변수에 넣어 전달(메뉴정보 묶어서 전달)
                  final newMenuItem = MenuItem(name: menuName, price: menuPrice);

                  setState(() {
                    // 선택된 카테고리에 메뉴 추가
                    menuItems[_selectedCategory]?.add(
                      MenuItem(name: menuName, price: menuPrice),
                    );

                    // 추가된 메뉴 디버깅
                    print('Added Menu: $menuName, $menuPrice원');
                    print('Updated Menus in $_selectedCategory:');
                    for (var menu in menuItems[_selectedCategory]!) {
                      print('- ${menu.name}: ${menu.price}원');
                    }
                  }
                  );
                  // Firebase Firestore에 메뉴 저장
                  await FirestoreService().addMenuToFirestore(
                    storeId: 'store123', // 가게 ID (여기서 고정값, 실제로는 동적으로 설정 필요)
                    categoryId: _selectedCategory, // 선택된 카테고리
                    menuItem: newMenuItem,
                  );

                  Navigator.of(context).pop(); // Dialog 닫기
                } else {
                  // 입력값이 비어있거나 유효하지 않을 경우 디버깅 출력
                  print(
                      'Invalid input: Menu Name or Price is missing or incorrect.');
                }
              },
              child: const Text('저장'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          Expanded(
            flex: 1, // 비율 3
            child: Container(
              child: Center(
                  child: ListView.builder(
                    itemCount: categories.length + 1, // +1로 항목 추가
                    itemBuilder: (c, i) {
                      if (i == categories.length) {
                        // 마지막 항목 (categories.length+1)
                        return ListTile(
                          title: const Icon(Icons.add),
                          
                          onTap: () {
                            print('fddd'); // 마지막 항목 클릭 시 실행될 함수 호출
                          },
                        );
                      } else {
                        // 일반 카테고리 항목
                        return ListTile(
                          title: Text(categories[i]),
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
            flex: 3, // 비율 2
            child: Container(
                color: Colors.grey.shade300,
                child: ListView.builder(
                    itemCount: menuItems[_selectedCategory]?.length ?? 0,
                    itemBuilder: (c, i) {
                      final menu = menuItems[_selectedCategory]![i];
                      return ListTile(
                        title: Text(menu.name),
                        subtitle: Text('${menu.price}원'),
                      );
                    })),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMenuDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
