import 'package:coupangeats/diliverypage/dilivery.dart';
import 'package:coupangeats/orderpage/store_cart_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupangeats/providers/cart_provider.dart';
import 'package:coupangeats/store_order_Page/delivery_method_selector.dart';
//카트 페이지
class CartViewPage extends StatefulWidget {
  const CartViewPage({Key? key}) : super(key: key);

  @override
  State<CartViewPage> createState() => _CartViewPageState();
}

class _CartViewPageState extends State<CartViewPage> {

  @override
  void initState() {
    super.initState();
    CartOverlayManager.hideOverlay();
  }
  @override
  Widget build(BuildContext context) {

    // (1) 매 build마다 오버레이가 떠 있는지 확인
    if (CartOverlayManager.isOverlayActive) {
      // (2) 떠 있다면 즉시 hideOverlay() 호출
      print('[DEBUG] CartViewPage build() - overlay가 있어서 hideOverlay() 수행');
      CartOverlayManager.hideOverlay();
    }
    // 장바구니 Provider 사용
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;

    return WillPopScope(
      onWillPop: () async {
        ///다시 home 으로 돌아갈때.
        // 뒤로가기 시 먼저 오버레이 해제
        CartOverlayManager.hideOverlay();
        CartOverlayManager.showOverlay(context,bottom: 0);
        // true를 리턴하면 실제 pop 진행
        Navigator.of(context).popUntil((route) => route.isFirst);return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('장바구니'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            // 장바구니 비우기 버튼
            if (cartItems.isNotEmpty)
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('장바구니 비우기'),
                      content: Text('장바구니를 비우시겠습니까?'),
                      actions: [
                        TextButton(
                          child: Text('취소'),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                        TextButton(
                          child: Text('확인'),
                          onPressed: () {
                            cartProvider.clear();
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
        body: cartItems.isEmpty
            ? _buildEmptyCart() // 장바구니가 비어있을 때
            : _buildCartList(cartItems, cartProvider), // 장바구니에 아이템이 있을 때
        bottomNavigationBar: cartItems.isEmpty
            ? null
            : _buildOrderButton(context, cartProvider), // 주문하기 버튼
      ),
    );
  }

  // 장바구니가 비어있을 때 표시할 위젯
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 70,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            '장바구니가 비어있습니다',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 10),
          Text(
            '메뉴를 추가해보세요!',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // 배달비 계산 함수
  int _getDeliveryFee(CartProvider cartProvider) {
    // 선택된 배달 방법에 따라 배달비 반환
    final selectedMethodId = cartProvider.selectedDeliveryMethodId;

    if (selectedMethodId == 'standard') {
      return 5800; // 한집배달 요금
    } else if (selectedMethodId == 'save') {
      return 4800; // 세이브배달 요금
    } else {
      return 5800; // 기본 배달 요금 (방어 코드)
    }
  }

  // 장바구니 리스트 위젯
  Widget _buildCartList(List<CartItem> cartItems, CartProvider cartProvider) {
    // 배달비 계산
    final deliveryFee = _getDeliveryFee(cartProvider);
    // 최종 결제 금액 계산 (주문 금액 + 배달비)
    final finalAmount = cartProvider.totalAmount + deliveryFee;

    return ListView(
      children: [
        // 배달 정보 섹션
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '배달 정보',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.location_on_outlined, size: 18, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '배달 주소를 입력해주세요',
                      style: TextStyle(color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 4), // 아이콘과 텍스트 사이 간격 추가
                  Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[600]),
                ],
              ),
            ],
          ),
        ),
        Divider(thickness: 8, color: Colors.grey[200]),

        DeliveryMethodSelector(),

        // 메뉴 목록 헤더
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '주문 메뉴',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '+메뉴 추가하기',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),

        // 메뉴 아이템 리스트
        ...cartItems.map((item) => _buildCartItem(item, cartProvider)).toList(),

        Divider(thickness: 8, color: Colors.grey[200]),

        // 주문 금액 정보
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '결제 금액',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              _buildPriceRow('주문 금액', '${cartProvider.totalAmount}원'),
              SizedBox(height: 8),
              _buildPriceRow('배달비', '${deliveryFee}원'),
              Divider(height: 24),
              _buildPriceRow(
                  '총 결제 금액',
                  '${finalAmount}원',
                  isBold: true),
            ],
          ),
        ),
      ],
    );
  }

  // 장바구니 메뉴 아이템 위젯
  Widget _buildCartItem(CartItem item, CartProvider cartProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 메뉴 이미지 (있을 경우만)
          if (item.menuImage != null)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(item.menuImage!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: Icon(Icons.restaurant, color: Colors.grey),
            ),
          SizedBox(width: 12),

          // 메뉴 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.menuName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 4),
                Text(
                  '${item.price}원',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),

                // 수량 조절 버튼
                Row(
                  children: [
                    InkWell(
                      onTap: () => cartProvider.decrementQuantity(item.menuName),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Icon(Icons.remove, size: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        item.quantity.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () => cartProvider.incrementQuantity(item.menuName),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Icon(Icons.add, size: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 총 가격 - 고정 너비 추가
          SizedBox(
            width: 80, // 가격을 위한 고정 너비 설정
            child: Text(
              '${item.totalPrice}원',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // 가격 정보 행 위젯
  Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(  // 라벨에 Expanded 추가
          child: Text(
            label,
            style: TextStyle(
              color: isBold ? Colors.black : Colors.grey[600],
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 8),  // 여백 추가
        SizedBox(
          width: 100,  // 가격에 고정 너비 추가
          child: Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 14,
            ),
            textAlign: TextAlign.right,  // 오른쪽 정렬
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // 주문하기 버튼
  Widget _buildOrderButton(BuildContext context, CartProvider cartProvider) {
    // 배달비 계산
    final deliveryFee = _getDeliveryFee(cartProvider);
    // 최종 결제 금액 계산 (주문 금액 + 배달비)
    final finalAmount = cartProvider.totalAmount + deliveryFee;

    return SafeArea(  // SafeArea 추가
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('주문이 완료되었습니다.'),
              duration: Duration(seconds: 2),
            ),
          );

          // [수정] 장바구니에 담긴 메뉴의 storeId를 추출 (모든 아이템이 동일한 가게라고 가정)
          String storeId = "";
          if (cartProvider.items.isNotEmpty) {
            storeId = cartProvider.items.first.storeId;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Dilivery(storeId: storeId)
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '${finalAmount}원 결제하기',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,  // 텍스트 넘침 방지
            ),
          ),
        ),
      ),
    );
  }
}