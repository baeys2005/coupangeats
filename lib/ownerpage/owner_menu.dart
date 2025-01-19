import 'package:flutter/material.dart';

class OwnerMenu extends StatefulWidget {
  const OwnerMenu({super.key});

  @override
  State<OwnerMenu> createState() => _OwnerMenuState();
}

class _OwnerMenuState extends State<OwnerMenu> {

  //선택된 카테고리
  String _selectedCategory= '식사';

  //카테고리
  final List<String> categories=[
    'Category 1',
    'Category 2',
    'Category 3',
    'Category 4',
  ];
  // 메뉴 데이터 (카테고리별)
  final Map<String, List<String>> menuItems = {
    'Category 1': ['Item 1-1', 'Item 1-2', 'Item 1-3'],
    'Category 2': ['Item 2-1', 'Item 2-2', 'Item 2-3'],
    'Category 3': ['Item 3-1', 'Item 3-2', 'Item 3-3'],
    'Category 4': ['Item 4-1', 'Item 4-2', 'Item 4-3'],
  };

  // 메뉴 추가 Dialog 함수.
  void _showAddMenuDialog() {
    final TextEditingController menuNameController = TextEditingController();
    final TextEditingController menuPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(' $_selectedCategory에 메뉴추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: menuNameController,
                decoration: InputDecoration(labelText: '메뉴 이름'),
              ),
              TextField(
                controller: menuPriceController,
                decoration: InputDecoration(labelText: '가격'),
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
              onPressed: () {
                final String menuName = menuNameController.text;
                final String menuPrice = menuPriceController.text;

                if (menuName.isNotEmpty && menuPrice.isNotEmpty) {
                  setState(() {
                    // 메뉴 추가
                    menuItems[_selectedCategory]?.add({
                      'name': menuName,
                      'price': menuPrice,
                    } as String);
                  });
                  Navigator.of(context).pop(); // Dialog 닫기
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
        children: [Expanded(
        flex: 1, // 비율 3
        child: Container(

          child: Center(
            child: ListView.builder(itemCount: categories.length,itemBuilder: (c,i){

              return ListTile(
                title: Text(categories[i]),
                selected: _selectedCategory == categories[i],
                selectedTileColor: Colors.blue.shade300,
                onTap: (){
                  setState(() {
                    _selectedCategory=categories[i];
                  });
                },
              );
            })
            ),
          ),
        ),

      Expanded(
        flex: 3, // 비율 2
        child: Container(
          color: Colors.grey.shade300,
          child: ListView.builder(itemCount: menuItems[_selectedCategory]?.length ?? 0
              ,itemBuilder: (c,i){
            return ListTile(title: Text(menuItems[_selectedCategory]![i]));
              })
        ),
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
