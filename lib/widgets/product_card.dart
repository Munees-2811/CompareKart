import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/wishlist_provider.dart';
import '../providers/comparison_provider.dart';
import '../services/mock_product_service.dart';
import '../screens/compare_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  Color getPlatformColor(String platform) {
    switch (platform) {
      case 'Amazon':
        return const Color(0xFFFF9900);
      case 'Flipkart':
        return const Color(0xFF2874F0);
      case 'Meesho':
        return const Color(0xFFE72B70);
      case 'Myntra':
        return const Color(0xFFE61B58);
      case 'Croma':
        return const Color(0xFF00B9B0);
      case 'Reliance Digital':
        return const Color(0xFFE4252A);
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final comparisonProvider = Provider.of<ComparisonProvider>(context);
    
    final isWishlisted = wishlistProvider.isWishlisted(product);
    final isInCompare = comparisonProvider.isInCompareList(product);
    
    // Get other store listings for the comparison summary
    final relatedOptions = MockProductService.getComparisonsForProduct(product.id);
    final lowestPrice = relatedOptions.isNotEmpty ? relatedOptions.first.price : product.price;
    final otherStoresCount = relatedOptions.length;

    return GestureDetector(
      onTap: onTap ?? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompareScreen(initialProduct: product),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Platform tag
              Stack(
                children: [
                  Container(
                    width: 110,
                    height: 140,
                    padding: const EdgeInsets.all(8),
                    color: const Color(0xFFF8F9FA),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: getPlatformColor(product.platform),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.platform,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Product Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Wishlist Button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                height: 1.25,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isWishlisted ? Icons.favorite : Icons.favorite_border,
                              color: isWishlisted ? Colors.red : Colors.grey[400],
                              size: 20,
                            ),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.only(left: 8),
                            onPressed: () {
                              wishlistProvider.toggleWishlist(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isWishlisted
                                        ? 'Removed from wishlist'
                                        : 'Added to wishlist',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      
                      // Rating & Category
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF8E1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 12),
                                const SizedBox(width: 2),
                                Text(
                                  product.rating.toString(),
                                  style: TextStyle(
                                    color: Colors.amber[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            product.category,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      
                      // Pricing and Discount
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '₹${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '₹${product.originalPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${product.discountPercentage.toStringAsFixed(0)}% off',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 2),
                      // Delivery Charge
                      Text(
                        product.deliveryCharge == 0
                            ? 'Free Delivery'
                            : '+ ₹${product.deliveryCharge.toStringAsFixed(0)} Delivery',
                        style: TextStyle(
                          fontSize: 10,
                          color: product.deliveryCharge == 0 ? Colors.green[700] : Colors.grey[600],
                          fontWeight: product.deliveryCharge == 0 ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      // Platform comparisons summary or Compare action
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Comparisons Summary pill
                          Expanded(
                            child: Text(
                              otherStoresCount > 1
                                  ? 'In $otherStoresCount stores from ₹${lowestPrice.toStringAsFixed(0)}'
                                  : 'Exclusive to ${product.platform}',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue[900],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          
                          // Compare toggle button
                          InkWell(
                            onTap: () {
                              if (isInCompare) {
                                comparisonProvider.removeProduct(product);
                              } else {
                                final added = comparisonProvider.addProduct(product);
                                if (added) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Added "${product.name.split(' (').first}" to compare list.'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isInCompare ? const Color(0xFF0D47A1) : Colors.grey[300]!,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                color: isInCompare ? const Color(0xFF0D47A1).withOpacity(0.05) : Colors.transparent,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isInCompare ? Icons.check : Icons.compare_arrows,
                                    size: 11,
                                    color: isInCompare ? const Color(0xFF0D47A1) : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    isInCompare ? 'Added' : 'Compare',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isInCompare ? const Color(0xFF0D47A1) : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
