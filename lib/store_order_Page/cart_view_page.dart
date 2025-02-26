import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupangeats/store_order_Page/cart_provider.dart';

class CartViewPage extends StatefulWidget {
  const CartViewPage({Key? key}) : super(key: key);

  @override
  State<CartViewPage> createState() => _CartViewPageState();
}

class _CartViewPageState extends State<CartViewPage> {
  @override
  void initState() {
    super.initState();
    // 페이지가 열릴 때 카트 아이템 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).loadCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('장바구니'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // 카트 비우기 다이얼로그
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  backgroundColor: Colors.white,
                  title: Text('장바구니 비우기'),
                  content: Text('장바구니를 비우시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('취소', style: TextStyle(color: Colors.blue)),
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false).clearCart();
                        Navigator.pop(context);
                      },
                      child: Text('확인', style: TextStyle(color: Colors.blue),),
                    ),
                  ],
                ),
              );
            },
            child: Text('전체 삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (cartProvider.items.isEmpty) {
            return Center(child: Text('장바구니가 비어있습니다.'));
          }

          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: cartProvider.items.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final item = cartProvider.items[index];
              return CartItemTile(item: item);
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '총 주문금액',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${cartProvider.totalPrice}원',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: cartProvider.items.isEmpty
                        ? null
                        : () {
                      // 주문 처리 로직 구현
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('주문 처리 준비 중입니다.')),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      '주문하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final CartItem item;

  const CartItemTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 메뉴 이미지
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: item.image != null
              ? Image.network(
            item.image!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Center(
              child: Icon(Icons.restaurant, size: 30, color: Colors.grey),
            ),
          )
              : Center(
            child: Icon(Icons.restaurant, size: 30, color: Colors.grey),
          ),
        ),
        SizedBox(width: 16),

        // 메뉴 정보
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${item.price}원',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '수량: ${item.quantity}개',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),

        // 총 가격
        Text(
          '${item.price * item.quantity}원',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}