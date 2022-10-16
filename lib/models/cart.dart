import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

import 'cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemsCount => _items.length;

  void addItemToCart(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
          product.id,
          (existingItem) => CartItem(
                id: existingItem.id,
                name: existingItem.name,
                productId: existingItem.productId,
                price: existingItem.price,
                quantity: existingItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          product.id,
          () => CartItem(
                id: _items.length.toString(),
                name: product.name,
                productId: product.id,
                price: product.price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]?.quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(
          productId,
          (existingItem) => CartItem(
                id: existingItem.id,
                name: existingItem.name,
                productId: existingItem.productId,
                price: existingItem.price,
                quantity: existingItem.quantity - 1,
              ));
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }
}
