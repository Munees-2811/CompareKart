import 'package:flutter/material.dart';
import '../models/product.dart';

class PlatformPriceRow extends StatelessWidget {
  final Product product;
  final bool isBestDeal;
  final VoidCallback onBuyTap;

  const PlatformPriceRow({
    super.key,
    required this.product,
    required this.isBestDeal,
    required this.onBuyTap,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isBestDeal ? const Color(0xFFE8F5E9) : Colors.white, // light green for best deal
        border: Border.all(
          color: isBestDeal ? Colors.green[400]! : Colors.grey[200]!,
          width: isBestDeal ? 1.5 : 1.0,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isBestDeal
            ? [
                BoxShadow(
                  color: Colors.green.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: Row(
        children: [
          // Platform Badge
          Container(
            width: 90,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: getPlatformColor(product.platform),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                product.platform,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Price Details & Delivery
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isBestDeal ? Colors.green[900] : const Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (product.discountPercentage > 0)
                      Text(
                        '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      product.deliveryCharge == 0
                          ? 'Free Delivery'
                          : '+₹${product.deliveryCharge.toStringAsFixed(0)} delivery',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.star, color: Colors.amber[700], size: 10),
                    const SizedBox(width: 2),
                    Text(
                      product.rating.toString(),
                      style: TextStyle(
                        fontSize: 9.5,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Action Button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isBestDeal)
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'BEST DEAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: onBuyTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBestDeal ? Colors.green : const Color(0xFF0D47A1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Buy Now',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
