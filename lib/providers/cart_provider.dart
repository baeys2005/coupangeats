import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String menuName;
  final int price;
  int quantity;
  String? menuImage;
  String? id; // Firestore 문서 ID
  final String storeId; // [추가] 가게 ID 필드

  CartItem({
    required this.menuName,
    required this.price,
    required this.quantity,
    this.menuImage,
    this.id,
    required this.storeId, // [추가]
  });

  int get totalPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'menuName': menuName,
      'price': price,
      'quantity': quantity,
      'menuImage': menuImage,
      'storeId': storeId, // [추가] 가게 ID 저장
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map, String id) {
    return CartItem(
      menuName: map['menuName'] ?? '',
      price: map['price'] ?? 0,
      quantity: map['quantity'] ?? 1,
      menuImage: map['menuImage'],
      id: id,
      storeId: map['storeId'] ?? '', // [추가] storeId 파싱
    );
  }
}

class CartProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ★ 초기에 빈 문자열
  String _userId = "";

  List<CartItem> _items = [];
  bool _isLoading = true;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  int get totalItemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  int get totalAmount => _items.fold(0, (sum, item) => sum + item.totalPrice);

  // 생성자
  CartProvider() {
    // 여기서 바로 loadCartItems()를 호출하면 userId가 비어 있을 수 있으므로
    // 원하는 경우, 아래처럼 호출을 막고,
    // setUserId() 호출 시점에서 loadCartItems()를 실행하는 편이 안전합니다.
    //
    // loadCartItems();
  }

  /// userId 설정 후 장바구니 재로딩
  Future<void> setUserId(String userId) async {
    if (userId.isEmpty) {
      // 빈 UID라면 Firestore 접근 안 함
      print("[DEBUG] setUserId() - 전달받은 userId가 비어 있음. Firestore 호출 스킵");
      _userId = "";
      return;
    }

    _userId = userId;
    print("[DEBUG] setUserId() - userId 세팅됨: $_userId");
    await loadCartItems();
  }

  // 장바구니 데이터 로드
  Future<void> loadCartItems() async {
    // ★ _userId가 비어 있다면 로딩 스킵
    if (_userId.isEmpty) {
      print("[DEBUG] loadCartItems() - _userId가 비어 있음. 로딩 스킵");
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      print("[DEBUG] loadCartItems() - Firestore에서 장바구니 로드 시작. userId=$_userId");
      final cartSnapshot = await _firestore
          .collection('signup')
          .doc(_userId)
          .collection('cart')
          .orderBy('timestamp', descending: true)
          .get();

      _items = cartSnapshot.docs
          .map((doc) => CartItem.fromMap(doc.data(), doc.id))
          .toList();

      print("[DEBUG] loadCartItems() - 로드 완료. 총 ${_items.length}개의 아이템");
    } catch (e) {
      print('[DEBUG] 장바구니 로드 중 오류: $e');
      _items = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // 메뉴 추가
  Future<void> addItem(String menuName, int price, int quantity, {String? menuImage, required String storeId}) async {

    // 이미 있는 메뉴이면서 같은 가게의 메뉴인지 확인
    final existingItemIndex = _items.indexWhere((item) => item.menuName == menuName && item.storeId == storeId);
    // ★ _userId가 비어 있다면 스킵
    if (_userId.isEmpty) {
      print("[DEBUG] addItem() - _userId가 비어 있어 Firestore 접근 불가. 스킵");
      return;
    }

    try {
      if (existingItemIndex >= 0) {
        final oldQuantity = _items[existingItemIndex].quantity;
        final newQuantity = oldQuantity + quantity;
        print('[DEBUG] 기존 아이템 수량 증가 시도');
        print('  - 기존 수량: $oldQuantity, 추가할 수량: $quantity, 최종 수량: $newQuantity');

        await _firestore
            .collection('signup')
            .doc(_userId)
            .collection('cart')
            .doc(_items[existingItemIndex].id)
            .update({'quantity': newQuantity});

        _items[existingItemIndex].quantity = newQuantity;
        print('[DEBUG] 기존 아이템 업데이트 완료');
      } else {
        print('[DEBUG] 새 아이템 추가 시도');
        final docRef = await _firestore
            .collection('signup')
            .doc(_userId)
            .collection('cart')
            .add({
          'menuName': menuName,
          'price': price,
          'quantity': quantity,
          'menuImage': menuImage,
          'timestamp': FieldValue.serverTimestamp(),
          'storeId': storeId, // [추가] 가게 ID 저장
        });

        _items.add(CartItem(
          menuName: menuName,
          price: price,
          quantity: quantity,
          menuImage: menuImage,
          id: docRef.id,
          storeId: storeId, // [추가]
        ));

      }


      notifyListeners();
      print('[DEBUG] addItem() 메서드 종료');
    } catch (e) {
      print('[DEBUG] 장바구니에 추가 중 오류: $e');
    }
  }

  // 수량 증가
  Future<void> incrementQuantity(String menuName) async {
    if (_userId.isEmpty) {
      print("[DEBUG] incrementQuantity() - _userId가 비어 있어 Firestore 접근 불가. 스킵");
      return;
    }

    try {
      final item = _items.firstWhere((item) => item.menuName == menuName);
      item.quantity++;

      await _firestore
          .collection('signup')
          .doc(_userId)
          .collection('cart')
          .doc(item.id)
          .update({'quantity': item.quantity});

      notifyListeners();
    } catch (e) {
      print('수량 증가 중 오류: $e');
    }
  }

  // 수량 감소
  Future<void> decrementQuantity(String menuName) async {
    if (_userId.isEmpty) {
      print("[DEBUG] decrementQuantity() - _userId가 비어 있어 Firestore 접근 불가. 스킵");
      return;
    }

    try {
      final item = _items.firstWhere((item) => item.menuName == menuName);
      if (item.quantity > 1) {
        item.quantity--;

        await _firestore
            .collection('signup')
            .doc(_userId)
            .collection('cart')
            .doc(item.id)
            .update({'quantity': item.quantity});
      } else {
        removeItem(menuName);
      }
      notifyListeners();
    } catch (e) {
      print('수량 감소 중 오류: $e');
    }
  }

  // 메뉴 제거
  Future<void> removeItem(String menuName) async {
    if (_userId.isEmpty) {
      print("[DEBUG] removeItem() - _userId가 비어 있어 Firestore 접근 불가. 스킵");
      return;
    }

    try {
      final item = _items.firstWhere((item) => item.menuName == menuName);

      await _firestore
          .collection('signup')
          .doc(_userId)
          .collection('cart')
          .doc(item.id)
          .delete();

      _items.removeWhere((item) => item.menuName == menuName);
      notifyListeners();
    } catch (e) {
      print('메뉴 제거 중 오류: $e');
    }
  }

  // 장바구니 비우기
  Future<void> clear() async {
    if (_userId.isEmpty) {
      print("[DEBUG] clear() - _userId가 비어 있어 Firestore 접근 불가. 스킵");
      return;
    }

    try {
      final batch = _firestore.batch();
      final cartSnapshot = await _firestore
          .collection('signup')
          .doc(_userId)
          .collection('cart')
          .get();

      for (var doc in cartSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      _items.clear();
      notifyListeners();
    } catch (e) {
      print('장바구니 비우기 중 오류: $e');
    }
  }
}
