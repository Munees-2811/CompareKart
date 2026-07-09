import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/price_alert.dart';

class PriceAlertProvider extends ChangeNotifier {
  final List<PriceAlert> _alerts = [];

  List<PriceAlert> get alerts => _alerts;

  void addAlert(Product product, double targetPrice) {
    // Remove duplicate alerts for the same product to keep it clean
    _alerts.removeWhere((alert) => alert.productName == product.name);

    _alerts.add(PriceAlert(
      id: 'alert_${DateTime.now().millisecondsSinceEpoch}',
      productId: product.id,
      productName: product.name,
      imageUrl: product.imageUrl,
      platform: product.platform,
      targetPrice: targetPrice,
      initialPrice: product.price,
      currentPrice: product.price,
      isTriggered: product.price <= targetPrice,
      createdAt: DateTime.now(),
    ));
    notifyListeners();
  }

  void removeAlert(String alertId) {
    _alerts.removeWhere((alert) => alert.id == alertId);
    notifyListeners();
  }

  // Interactivity helper: Simulates a price drop below the target price
  void simulatePriceDrop(String alertId) {
    final index = _alerts.indexWhere((alert) => alert.id == alertId);
    if (index >= 0) {
      final alert = _alerts[index];
      final double newPrice = alert.targetPrice - (alert.targetPrice * 0.03) - 50.0;
      _alerts[index] = alert.copyWith(
        currentPrice: newPrice,
        isTriggered: true,
      );
      notifyListeners();
    }
  }

  // Reset helper: Returns the current price to the initial price
  void resetAlert(String alertId) {
    final index = _alerts.indexWhere((alert) => alert.id == alertId);
    if (index >= 0) {
      final alert = _alerts[index];
      _alerts[index] = alert.copyWith(
        currentPrice: alert.initialPrice,
        isTriggered: alert.initialPrice <= alert.targetPrice,
      );
      notifyListeners();
    }
  }
}
