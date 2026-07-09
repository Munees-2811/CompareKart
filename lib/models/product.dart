class Product {
  final String id;
  final String name;
  final String platform; // 'Amazon', 'Flipkart', 'Meesho', 'Myntra', 'Croma', 'Reliance Digital'
  final double price;
  final double originalPrice;
  final double discountPercentage;
  final double rating;
  final double deliveryCharge;
  final String imageUrl;
  final String buyLink;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.platform,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.rating,
    required this.deliveryCharge,
    required this.imageUrl,
    required this.buyLink,
    required this.category,
  });

  double get savingsAmount => originalPrice - price;

  // Simple copyWith helper
  Product copyWith({
    String? id,
    String? name,
    String? platform,
    double? price,
    double? originalPrice,
    double? discountPercentage,
    double? rating,
    double? deliveryCharge,
    String? imageUrl,
    String? buyLink,
    String? category,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      platform: platform ?? this.platform,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      rating: rating ?? this.rating,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      imageUrl: imageUrl ?? this.imageUrl,
      buyLink: buyLink ?? this.buyLink,
      category: category ?? this.category,
    );
  }
}
