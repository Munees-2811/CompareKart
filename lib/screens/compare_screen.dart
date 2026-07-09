import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/comparison_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/mock_product_service.dart';
import '../widgets/platform_price_row.dart';
import '../widgets/alert_dialogs.dart';

class CompareScreen extends StatelessWidget {
  final Product? initialProduct;

  const CompareScreen({super.key, this.initialProduct});

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF0D47A1);

    if (initialProduct != null) {
      // MODE 1: Comparing one product across multiple platforms
      final Product target = initialProduct!;
      final platformOptions = MockProductService.getComparisonsForProduct(target.id);
      final wishlistProvider = Provider.of<WishlistProvider>(context);
      final isWishlisted = wishlistProvider.isWishlisted(target);

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Price Comparison',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Product Header Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(
                        target.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            target.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
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
                                      target.rating.toString(),
                                      style: TextStyle(
                                        color: Colors.amber[900],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                target.category,
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    // Price Alert Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => PriceAlertDialog(product: target),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          foregroundColor: themeColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.notifications_active_outlined, size: 18),
                        label: const Text(
                          'Set Price Alert',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Wishlist Button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          wishlistProvider.toggleWishlist(target);
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
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isWishlisted ? Colors.red : Colors.grey[700],
                          side: BorderSide(
                            color: isWishlisted ? Colors.red : Colors.grey[300]!,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: isWishlisted ? Colors.red : Colors.grey[600],
                        ),
                        label: Text(
                          isWishlisted ? 'Wishlisted' : 'Wishlist',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: isWishlisted ? Colors.red : Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Available Offers',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              // Stores Pricing List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: platformOptions.length,
                  itemBuilder: (context, index) {
                    final option = platformOptions[index];
                    // Since option is sorted ascending, index == 0 is the lowest price (Best Deal)
                    final isBest = index == 0;
                    return PlatformPriceRow(
                      product: option,
                      isBestDeal: isBest,
                      onBuyTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Redirecting to ${option.platform}... (Mock Link)'),
                            action: SnackBarAction(label: 'OK', onPressed: () {}),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // MODE 2: Multi-Product Comparison Tab (Queue system)
      final comparisonProvider = Provider.of<ComparisonProvider>(context);
      final list = comparisonProvider.compareList;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Product Comparison Dashboard',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            if (list.isNotEmpty)
              TextButton(
                onPressed: () => comparisonProvider.clearCompareList(),
                child: const Text('Clear All', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        body: SafeArea(
          child: list.isEmpty
              ? _buildEmptyCompareQueue(context)
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.blue[50],
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: themeColor, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Comparing ${list.length} item(s). Add up to 3 products from search results.',
                              style: TextStyle(fontSize: 11, color: Colors.blue[900], fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[200]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Attributes Column
                                  _buildAttributesColumn(),
                                  // Product Columns
                                  ...list.map((prod) => _buildProductColumn(context, prod, comparisonProvider)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      );
    }
  }

  Widget _buildEmptyCompareQueue(BuildContext context) {
    final themeColor = const Color(0xFF0D47A1);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.compare_arrows_rounded, size: 84, color: Colors.grey[300]),
            const SizedBox(height: 20),
            const Text(
              'Your Compare Queue is Empty',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Add products from the Search Results or Home screens to compare them side-by-side.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Return to Home or instruct search
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Search for products first to add them to comparison!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Find Products to Compare', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributesColumn() {
    return Container(
      width: 110,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        border: Border(right: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCell('Product', height: 100, isHeader: true),
          _buildCell('Platform'),
          _buildCell('Price'),
          _buildCell('Rating'),
          _buildCell('Discount'),
          _buildCell('Delivery Fee'),
          _buildCell('Buy Link'),
        ],
      ),
    );
  }

  Widget _buildProductColumn(
    BuildContext context,
    Product product,
    ComparisonProvider comparisonProvider,
  ) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          // Header cell (Image + Title + Delete option)
          Container(
            height: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(product.imageUrl, fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -6,
                  right: -6,
                  child: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red, size: 16),
                    onPressed: () => comparisonProvider.removeProduct(product),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          
          // Platform Cell
          _buildCell(product.platform, isBold: true),
          
          // Price Cell
          _buildCell('₹${product.price.toStringAsFixed(0)}', textColor: const Color(0xFF0D47A1), isBold: true),
          
          // Rating Cell
          Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 12),
                const SizedBox(width: 2),
                Text(
                  product.rating.toString(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          
          // Discount Cell
          _buildCell('${product.discountPercentage.toStringAsFixed(0)}% Off', textColor: Colors.green, isBold: true),
          
          // Delivery Cell
          _buildCell(
            product.deliveryCharge == 0 ? 'Free' : '₹${product.deliveryCharge.toStringAsFixed(0)}',
            textColor: product.deliveryCharge == 0 ? Colors.green[800] : Colors.black87,
          ),
          
          // Buy Button Cell
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening ${product.platform} buy link (Mock)')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                padding: EdgeInsets.zero,
              ),
              child: const Text('Buy Now', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(
    String text, {
    double height = 48,
    bool isHeader = false,
    bool isBold = false,
    Color? textColor,
  }) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey[100] : Colors.transparent,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isHeader ? 11 : 12,
            fontWeight: (isHeader || isBold) ? FontWeight.bold : FontWeight.normal,
            color: textColor ?? (isHeader ? Colors.grey[700] : Colors.black87),
          ),
        ),
      ),
    );
  }
}
