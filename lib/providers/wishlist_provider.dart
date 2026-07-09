import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  bool isWishlisted(Product product) {
    // Match by product name to group same product across different platforms easily
    return _items.any((item) => item.name == product.name);
  }

  void toggleWishlist(Product product) {
    final index = _items.indexWhere((item) => item.name == product.name);
    if (index >= 0) {
      _items.removeAt(index);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void removeProduct(Product product) {
    _items.removeWhere((item) => item.name == product.name);
    notifyListeners();
  }
}
