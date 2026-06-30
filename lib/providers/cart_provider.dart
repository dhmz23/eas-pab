// lib/providers/cart_provider.dart

import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);

  int quantityInCart(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    return index >= 0 ? _items[index].quantity : 0;
  }

  bool canIncreaseQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    return index >= 0 && _items[index].quantity < _items[index].product.stock;
  }

  bool canAddItem(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    return index < 0 ? product.stock > 0 : _items[index].quantity < product.stock;
  }

  bool isInCart(int productId) {
    return _items.any((item) => item.product.id == productId);
  }

  bool addItem(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (_items[index].quantity >= product.stock) {
        return false;
      }
      _items[index].quantity++;
    } else {
      if (product.stock <= 0) {
        return false;
      }
      _items.add(CartItem(product: product));
    }
    notifyListeners();
    return true;
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void decreaseQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  bool increaseQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0 && _items[index].quantity < _items[index].product.stock) {
      _items[index].quantity++;
      notifyListeners();
      return true;
    }
    return false;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
