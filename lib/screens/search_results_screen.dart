import 'package:flutter/material.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/product_card.dart';
import '../services/mock_product_service.dart';
import '../models/product.dart';

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;

  const SearchResultsScreen({super.key, required this.searchQuery});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late TextEditingController _searchController;
  late String _query;
  String _activeSort = 'price_asc'; // 'price_asc', 'rating_desc', 'discount_desc'
  List<Product> _results = [];

  @override
  void initState() {
    super.initState();
    _query = widget.searchQuery;
    _searchController = TextEditingController(text: _query);
    _performSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    setState(() {
      _results = MockProductService.search(_query);
      _applySort();
    });
  }

  void _applySort() {
    if (_activeSort == 'price_asc') {
      _results.sort((a, b) => a.price.compareTo(b.price));
    } else if (_activeSort == 'rating_desc') {
      _results.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_activeSort == 'discount_desc') {
      _results.sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));
    }
  }

  void _changeSort(String sortType) {
    setState(() {
      _activeSort = sortType;
      _applySort();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF0D47A1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _query.isEmpty ? 'All Products' : 'Search Results',
          style: TextStyle(color: Colors.grey[800], fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: CustomSearchBar(
                hintText: 'Search for products...',
                controller: _searchController,
                onSubmitted: (val) {
                  setState(() {
                    _query = val.trim();
                    _performSearch();
                  });
                },
              ),
            ),
            
            // Sort Filter Options Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      'Sort by:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 12),
                    _buildSortPill('price_asc', 'Lowest Price', Icons.arrow_downward),
                    const SizedBox(width: 8),
                    _buildSortPill('rating_desc', 'Highest Rating', Icons.star),
                    const SizedBox(width: 8),
                    _buildSortPill('discount_desc', 'Best Discount', Icons.percent),
                  ],
                ),
              ),
            ),
            
            // Results List
            Expanded(
              child: _results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'No results found for "$_query"',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text('Try looking up general items like "iPhone" or "Nike"', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final product = _results[index];
                        return ProductCard(product: product);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortPill(String value, String label, IconData icon) {
    final active = _activeSort == value;
    final primaryBlue = const Color(0xFF0D47A1);

    return InkWell(
      onTap: () => _changeSort(value),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? primaryBlue.withOpacity(0.08) : Colors.transparent,
          border: Border.all(
            color: active ? primaryBlue : Colors.grey[300]!,
            width: active ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 13,
              color: active ? primaryBlue : Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active ? primaryBlue : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
