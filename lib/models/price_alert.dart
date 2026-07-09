class PriceAlert {
  final String id;
  final String productId;
  final String productName;
  final String imageUrl;
  final String platform;
  final double targetPrice;
  final double initialPrice;
  final double currentPrice;
  final bool isTriggered;
  final DateTime createdAt;

  PriceAlert({
    required this.id,
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.platform,
    required this.targetPrice,
    required this.initialPrice,
    required this.currentPrice,
    this.isTriggered = false,
    required this.createdAt,
  });

  PriceAlert copyWith({
    String? id,
    String? productId,
    String? productName,
    String? imageUrl,
    String? platform,
    double? targetPrice,
    double? initialPrice,
    double? currentPrice,
    bool? isTriggered,
    DateTime? createdAt,
  }) {
    return PriceAlert(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      imageUrl: imageUrl ?? this.imageUrl,
      platform: platform ?? this.platform,
      targetPrice: targetPrice ?? this.targetPrice,
      initialPrice: initialPrice ?? this.initialPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      isTriggered: isTriggered ?? this.isTriggered,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
