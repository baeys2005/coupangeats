import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String menuName;
  final int price;
  int quantity;
  String? menuImage;
  String? id; // Firestore 문서 ID

  CartItem({
    required this.menuName,
    required this.price,
    required this.quantity,
    this.menuImage,
    this.id,
  });

  int get totalPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'menuName': menuName,
      'price': price,
      'quantity': quantity,
      'menuImage': menuImage,
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
    );
  }
}

class CartProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _userId = "user123"; // 실제 앱에서는 로그인한 사용자 ID를 사용

  List<CartItem> _items = [];
  bool _isLoading = true;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  int get totalItemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  int get totalAmount => _items.fold(0, (sum, item) => sum + item.totalPrice);

  CartProvider() {
    // 생성자에서 장바구니 데이터 로드
    loadCartItems();
  }

  // 장바구니 데이터 로드
  Future<void> loadCartItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      final cartSnapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .orderBy('timestamp', descending: true)
          .get();

      _items = cartSnapshot.docs
          .map((doc) => CartItem.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('장바구니 로드 중 오류: $e');
      _items = []; // 오류 발생 시 빈 리스트로 초기화
    }

    _isLoading = false;
    notifyListeners();
  }

  // 메뉴 추가
  Future<void> addItem(String menuName, int price, int quantity, {String? menuImage}) async {
    // 이미 있는 메뉴인지 확인
    final existingItemIndex = _items.indexWhere((item) => item.menuName == menuName);

    try {
      if (existingItemIndex >= 0) {
        // 기존 메뉴 수량 증가
        await _firestore
            .collection('users')
            .doc(_userId)
            .collection('cart')
            .doc(_items[existingItemIndex].id)
            .update({'quantity': _items[existingItemIndex].quantity + quantity});

        _items[existingItemIndex].quantity += quantity;
      } else {
        // 새 메뉴 추가
        final docRef = await _firestore.collection('users').doc(_userId).collection('cart').add({
          'menuName': menuName,
          'price': price,
          'quantity': quantity,
          'menuImage': menuImage,
          'timestamp': FieldValue.serverTimestamp(),
        });

        _items.add(CartItem(
          menuName: menuName,
          price: price,
          quantity: quantity,
          menuImage: menuImage,
          id: docRef.id,
        ));
      }
      notifyListeners();
    } catch (e) {
      print('장바구니에 추가 중 오류: $e');
    }
  }

  // 수량 증가
  Future<void> incrementQuantity(String menuName) async {
    try {
      final item = _items.firstWhere((item) => item.menuName == menuName);
      item.quantity++;

      await _firestore
          .collection('users')
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
    try {
      final item = _items.firstWhere((item) => item.menuName == menuName);
      if (item.quantity > 1) {
        item.quantity--;

        await _firestore
            .collection('users')
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
    try {
      final item = _items.firstWhere((item) => item.menuName == menuName);

      await _firestore
          .collection('users')
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
    try {
      final batch = _firestore.batch();
      final cartSnapshot = await _firestore
          .collection('users')
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