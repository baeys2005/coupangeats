import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final int price;
  final int quantity;
  final String? image;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'image': image,
      'addedAt': Timestamp.now(),
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      name: map['name'] ?? '',
      price: map['price'] ?? 0,
      quantity: map['quantity'] ?? 1,
      image: map['image'],
    );
  }
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = false;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;

  // 총 가격 계산
  int get totalPrice {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // 총 아이템 개수
  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // 카트에 아이템 추가하고 Firestore에 저장
  Future<void> addItem(CartItem newItem) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('사용자가 로그인되어 있지 않습니다.');
      }

      // Firestore에 아이템 추가
      await FirebaseFirestore.instance
          .collection('signup')
          .doc(user.uid)
          .collection('food')
          .add(newItem.toMap());

      // 로컬 목록에도 추가
      _items.add(newItem);
    } catch (e) {
      debugPrint('카트에 아이템 추가 실패: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Firestore에서 카트 아이템 불러오기
  Future<void> loadCartItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('사용자가 로그인되어 있지 않습니다.');
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('signup')
          .doc(user.uid)
          .collection('food')
          .orderBy('addedAt', descending: true)
          .get();

      _items = querySnapshot.docs
          .map((doc) => CartItem.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('카트 아이템 로드 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 카트 비우기
  Future<void> clearCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('사용자가 로그인되어 있지 않습니다.');
      }

      // Firestore에서 모든 food 아이템 삭제
      final querySnapshot = await FirebaseFirestore.instance
          .collection('signup')
          .doc(user.uid)
          .collection('food')
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      _items.clear();
    } catch (e) {
      debugPrint('카트 비우기 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}