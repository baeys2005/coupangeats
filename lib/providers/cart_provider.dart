import 'package:flutter/material.dart';

// 장바구니 아이템 클래스
class CartItem {
  final String menuName;
  final int price;
  int quantity;
  final String? menuImage;
  final String storeId; // 가게 ID
  final String id; // Firestore 문서 ID

  CartItem({
    required this.menuName,
    required this.price,
    required this.quantity,
    this.menuImage,
    required this.storeId,
    this.id = '', // 기본값은 빈 문자열
  });

  // 총 가격 계산
  int get totalPrice => price * quantity;
}

// 장바구니 Provider 클래스
class CartProvider with ChangeNotifier {
  // 장바구니 아이템 목록
  List<CartItem> _items = [];

  // 선택된 배달 방법 ID (기본값: 'standard')
  String _selectedDeliveryMethodId = 'standard';

  // 배달비 (기본값: 5800원 - 한집배달)
  int _deliveryFee = 5800;

  // 사용자 ID (Firestore 연동용)
  String _userId = '';

  // 장바구니 아이템 목록 getter
  List<CartItem> get items => [..._items];

  // 선택된 배달 방법 ID getter
  String get selectedDeliveryMethodId => _selectedDeliveryMethodId;

  // 배달비 getter
  int get deliveryFee => _deliveryFee;

  // 사용자 ID getter
  String get userId => _userId;

  // 총 아이템 개수 계산 (수량 고려)
  int get totalItemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // 총 상품 금액 계산
  int get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  // 최종 결제 금액 계산 (상품 금액 + 배달비)
  int get finalAmount {
    return totalAmount + _deliveryFee;
  }

  // 사용자 ID 설정 메서드 (Firestore 연동용)
  Future<void> setUserId(String userId) async {
    _userId = userId;
    // 여기에 Firestore에서 장바구니 데이터를 불러오는 로직이 있을 수 있음
    // 지금은 임시로 비워둠
    notifyListeners();
    return Future.value(); // Future<void> 반환
  }

  // 아이템 추가 메서드
  void addItem(String menuName, int price, int quantity, {String? menuImage, required String storeId, String id = ''}) {
    // 이미 있는 메뉴인지 확인
    final existingItemIndex = _items.indexWhere((item) => item.menuName == menuName);

    if (existingItemIndex >= 0) {
      // 이미 있는 메뉴면 수량만 증가
      _items[existingItemIndex].quantity += quantity;
    } else {
      // 새 메뉴면 추가
      _items.add(
        CartItem(
          menuName: menuName,
          price: price,
          quantity: quantity,
          menuImage: menuImage,
          storeId: storeId,
          id: id, // Firestore 문서 ID도 함께 저장
        ),
      );
    }
    notifyListeners();
  }

  // 수량 증가 메서드
  void incrementQuantity(String menuName) {
    final index = _items.indexWhere((item) => item.menuName == menuName);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  // 수량 감소 메서드
  void decrementQuantity(String menuName) {
    final index = _items.indexWhere((item) => item.menuName == menuName);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        // 수량이 1이면 삭제
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // 장바구니 비우기 메서드 - 비동기로 변경
  Future<void> clear() async {
    // Firestore에서 카트 데이터 삭제가 필요한 경우 여기에 비동기 코드 추가
    // 예: if (_userId.isNotEmpty) { await FirebaseFirestore.instance.collection('carts').doc(_userId).delete(); }

    _items = [];
    notifyListeners();
    return Future.value(); // Future<void> 반환
  }

  // 배달 방법 설정 메서드
  void setDeliveryMethod(String methodId, int fee) {
    _selectedDeliveryMethodId = methodId;
    _deliveryFee = fee;
    notifyListeners();
  }
}