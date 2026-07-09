import 'package:flutter/material.dart';
import '../models/product.dart';

class ComparisonProvider extends ChangeNotifier {
  final List<Product> _compareList = [];
  static const int maxCompareLimit = 3;

  List<Product> get compareList => _compareList;

  bool isInCompareList(Product product) {
    // Match by base name to see if this canonical product is in compare list
    return _compareList.any((item) => item.name == product.name);
  }

  bool addProduct(Product product) {
    if (isInCompareList(product)) {
      return false; // Already present
    }

    if (_compareList.length >= maxCompareLimit) {
      // Remove first item if full (circular queue behavior) or return false
      _compareList.removeAt(0);
    }

    _compareList.add(product);
    notifyListeners();
    return true;
  }

  void removeProduct(Product product) {
    _compareList.removeWhere((item) => item.name == product.name);
    notifyListeners();
  }

  void clearCompareList() {
    _compareList.clear();
    notifyListeners();
  }
}
