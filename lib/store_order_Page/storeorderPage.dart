import 'package:flutter/material.dart';

class storeorderPage extends StatefulWidget {
  final String menuName;
  final int menuPrice;
  final String? menuImage;

  const storeorderPage({
    Key? key,
    required this.menuName,
    required this.menuPrice,
    this.menuImage,
  }) : super(key: key);

  @override
  State<storeorderPage> createState() => _storeorderPageState();
}

class _storeorderPageState extends State<storeorderPage> {
  // 수량 상태 관리
  int _quantity = 1;

  // 총 가격 계산
  int get _totalPrice => widget.menuPrice * _quantity;

  // 수량 증가 메서드
  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  // 수량 감소 메서드
  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.black),
            onPressed: () {
              // 공유 기능 구현
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 메뉴 이미지
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 메뉴 이미지
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: widget.menuImage != null
                        ? Image.network(
                      widget.menuImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(Icons.restaurant, size: 80, color: Colors.grey),
                      ),
                    )
                        : Center(
                      child: Icon(Icons.restaurant, size: 80, color: Colors.grey),
                    ),
                  ),
                  // 메뉴 정보
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // NEW 태그 (있을 경우)
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '[NEW]',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),

                        // 메뉴 이름
                        Text(
                          widget.menuName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),

                        // 좋아요 표시
                        Row(
                          children: [
                            Icon(Icons.thumb_up_outlined, size: 18),
                            SizedBox(width: 4),
                            Text(
                              '100% (1개)',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),

                        Divider(height: 32),

                        // 가격 섹션
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '가격',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${widget.menuPrice.toString()}원',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16),

                        // 수량 조절 섹션
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '수량',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                // 감소 버튼
                                InkWell(
                                  onTap: _decrementQuantity,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Icon(
                                      Icons.remove,
                                      color: _quantity > 1 ? Colors.black : Colors.grey,
                                    ),
                                  ),
                                ),

                                // 수량 표시
                                Container(
                                  width: 40,
                                  alignment: Alignment.center,
                                  child: Text(
                                    _quantity.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                // 증가 버튼
                                InkWell(
                                  onTap: _incrementQuantity,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Icon(Icons.add),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 장바구니 담기 버튼
          Container(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                // 장바구니에 담는 로직 구현
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('장바구니에 추가되었습니다.'),
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text(
                '배달 카트에 담기',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}