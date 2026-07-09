import '../models/product.dart';

class MockProductService {
  // A master dataset of base products. We will generate platform-specific listings dynamically.
  static final List<Map<String, dynamic>> _baseProducts = [
    {
      'id': 'iphone15',
      'name': 'Apple iPhone 15 (128 GB) - Black',
      'category': 'Electronics',
      'imageUrl': 'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?q=80&w=400',
      'platforms': {
        'Amazon': {
          'price': 71200.0,
          'originalPrice': 79900.0,
          'rating': 4.6,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.amazon.in/dp/B0CHX1W1XY',
        },
        'Flipkart': {
          'price': 70999.0,
          'originalPrice': 79900.0,
          'rating': 4.5,
          'deliveryCharge': 40.0,
          'buyLink': 'https://www.flipkart.com/apple-iphone-15-black-128-gb/p/itm2d73c24d4370a',
        },
        'Croma': {
          'price': 71900.0,
          'originalPrice': 79900.0,
          'rating': 4.4,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.croma.com/apple-iphone-15-128gb-black/p/300652',
        },
        'Reliance Digital': {
          'price': 71500.0,
          'originalPrice': 79900.0,
          'rating': 4.5,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.reliancedigital.in/apple-iphone-15-128-gb-black/p/494229999',
        },
      }
    },
    {
      'id': 'macbookair',
      'name': 'Apple MacBook Air Laptop M2 (8GB RAM, 256GB SSD)',
      'category': 'Electronics',
      'imageUrl': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=400',
      'platforms': {
        'Amazon': {
          'price': 89900.0,
          'originalPrice': 99900.0,
          'rating': 4.7,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.amazon.in/dp/B0B3C56SKB',
        },
        'Flipkart': {
          'price': 88490.0,
          'originalPrice': 99900.0,
          'rating': 4.6,
          'deliveryCharge': 99.0,
          'buyLink': 'https://www.flipkart.com/apple-2022-macbook-air-m2-8-gb-256-gb-ssd/p/itm12345',
        },
        'Croma': {
          'price': 89100.0,
          'originalPrice': 99900.0,
          'rating': 4.5,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.croma.com/apple-macbook-air-m2/p/256789',
        },
        'Reliance Digital': {
          'price': 89500.0,
          'originalPrice': 99900.0,
          'rating': 4.6,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.reliancedigital.in/apple-macbook-air-m2/p/4923456',
        },
      }
    },
    {
      'id': 'sonywh1000xm4',
      'name': 'Sony WH-1000XM4 Wireless Noise Cancelling Headphones',
      'category': 'Electronics',
      'imageUrl': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=400',
      'platforms': {
        'Amazon': {
          'price': 19990.0,
          'originalPrice': 29990.0,
          'rating': 4.6,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.amazon.in/dp/B08C56GNEK',
        },
        'Flipkart': {
          'price': 20990.0,
          'originalPrice': 29990.0,
          'rating': 4.5,
          'deliveryCharge': 40.0,
          'buyLink': 'https://www.flipkart.com/sony-wh-1000xm4-active-noise-cancellation/p/itm123',
        },
        'Croma': {
          'price': 19999.0,
          'originalPrice': 29990.0,
          'rating': 4.4,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.croma.com/sony-wh-1000xm4/p/1234',
        },
        'Reliance Digital': {
          'price': 20490.0,
          'originalPrice': 29990.0,
          'rating': 4.5,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.reliancedigital.in/sony-wh-1000xm4/p/5678',
        },
      }
    },
    {
      'id': 'nike_air_max',
      'name': 'Nike Air Max Men\'s Running Shoes',
      'category': 'Footwear',
      'imageUrl': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=400',
      'platforms': {
        'Amazon': {
          'price': 7495.0,
          'originalPrice': 9995.0,
          'rating': 4.3,
          'deliveryCharge': 100.0,
          'buyLink': 'https://www.amazon.in/dp/nike-air-max',
        },
        'Flipkart': {
          'price': 7299.0,
          'originalPrice': 9995.0,
          'rating': 4.2,
          'deliveryCharge': 50.0,
          'buyLink': 'https://www.flipkart.com/nike-air-max',
        },
        'Myntra': {
          'price': 6996.0,
          'originalPrice': 9995.0,
          'rating': 4.4,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.myntra.com/nike-air-max',
        },
        'Meesho': {
          'price': 6499.0,
          'originalPrice': 9995.0,
          'rating': 3.9,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.meesho.com/nike-air-max',
        },
      }
    },
    {
      'id': 'levis_jeans',
      'name': 'Levi\'s Men\'s 511 Slim Fit Jeans',
      'category': 'Fashion',
      'imageUrl': 'https://images.unsplash.com/photo-1542272604-787c3835535d?q=80&w=400',
      'platforms': {
        'Amazon': {
          'price': 1899.0,
          'originalPrice': 3299.0,
          'rating': 4.1,
          'deliveryCharge': 40.0,
          'buyLink': 'https://www.amazon.in/levis-511',
        },
        'Flipkart': {
          'price': 1799.0,
          'originalPrice': 3299.0,
          'rating': 4.0,
          'deliveryCharge': 40.0,
          'buyLink': 'https://www.flipkart.com/levis-511',
        },
        'Myntra': {
          'price': 1649.0,
          'originalPrice': 3299.0,
          'rating': 4.2,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.myntra.com/levis-511',
        },
        'Meesho': {
          'price': 1499.0,
          'originalPrice': 3299.0,
          'rating': 3.8,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.meesho.com/levis-511',
        },
      }
    },
    {
      'id': 'adidas_hoodie',
      'name': 'Adidas Essentials Men\'s Fleece Hoodie',
      'category': 'Fashion',
      'imageUrl': 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?q=80&w=400',
      'platforms': {
        'Amazon': {
          'price': 2799.0,
          'originalPrice': 3999.0,
          'rating': 4.4,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.amazon.in/adidas-hoodie',
        },
        'Flipkart': {
          'price': 2899.0,
          'originalPrice': 3999.0,
          'rating': 4.3,
          'deliveryCharge': 50.0,
          'buyLink': 'https://www.flipkart.com/adidas-hoodie',
        },
        'Myntra': {
          'price': 2599.0,
          'originalPrice': 3999.0,
          'rating': 4.5,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.myntra.com/adidas-hoodie',
        },
        'Meesho': {
          'price': 2199.0,
          'originalPrice': 3999.0,
          'rating': 3.7,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.meesho.com/adidas-hoodie',
        },
      }
    },
    {
      'id': 'samsung_tv',
      'name': 'Samsung 138 cm (55 inches) 4K Ultra HD Smart LED TV',
      'category': 'Appliances',
      'imageUrl': 'https://images.unsplash.com/photo-1593305841991-05c297ba4575?q=80&w=400',
      'platforms': {
        'Amazon': {
          'price': 44990.0,
          'originalPrice': 64900.0,
          'rating': 4.4,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.amazon.in/dp/samsung-tv',
        },
        'Flipkart': {
          'price': 43999.0,
          'originalPrice': 64900.0,
          'rating': 4.3,
          'deliveryCharge': 500.0,
          'buyLink': 'https://www.flipkart.com/samsung-tv',
        },
        'Croma': {
          'price': 45990.0,
          'originalPrice': 64900.0,
          'rating': 4.5,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.croma.com/samsung-tv',
        },
        'Reliance Digital': {
          'price': 44500.0,
          'originalPrice': 64900.0,
          'rating': 4.4,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.reliancedigital.in/samsung-tv',
        },
      }
    },
    {
      'id': 'boat_smartwatch',
      'name': 'boAt Xtend Smartwatch with Alexa Built-in',
      'category': 'Electronics',
      'imageUrl': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=400',
      'platforms': {
        'Amazon': {
          'price': 1999.0,
          'originalPrice': 7990.0,
          'rating': 4.1,
          'deliveryCharge': 40.0,
          'buyLink': 'https://www.amazon.in/dp/boat-smartwatch',
        },
        'Flipkart': {
          'price': 1899.0,
          'originalPrice': 7990.0,
          'rating': 4.2,
          'deliveryCharge': 40.0,
          'buyLink': 'https://www.flipkart.com/boat-smartwatch',
        },
        'Croma': {
          'price': 2199.0,
          'originalPrice': 7990.0,
          'rating': 4.0,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.croma.com/boat-smartwatch',
        },
        'Reliance Digital': {
          'price': 1999.0,
          'originalPrice': 7990.0,
          'rating': 4.1,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.reliancedigital.in/boat-smartwatch',
        },
        'Meesho': {
          'price': 1799.0,
          'originalPrice': 7990.0,
          'rating': 3.7,
          'deliveryCharge': 0.0,
          'buyLink': 'https://www.meesho.com/boat-smartwatch',
        },
      }
    }
  ];

  // Get all platforms
  static final List<String> platforms = [
    'Amazon',
    'Flipkart',
    'Meesho',
    'Myntra',
    'Croma',
    'Reliance Digital'
  ];

  // Helper to compile dynamic Product instances for a search result or category.
  // By default, a search result lists one primary product representing the "best option" or representative store.
  // Tapping that item allows side-by-side comparison across all stores where it's listed.
  static List<Product> getAllProducts() {
    List<Product> products = [];
    for (var item in _baseProducts) {
      final String id = item['id'];
      final String name = item['name'];
      final String category = item['category'];
      final String imageUrl = item['imageUrl'];
      final Map<String, dynamic> platformData = item['platforms'];

      platformData.forEach((platformName, details) {
        final double price = details['price'];
        final double originalPrice = details['originalPrice'];
        final double discount = ((originalPrice - price) / originalPrice) * 100;

        products.add(Product(
          id: '${id}_$platformName',
          name: name,
          platform: platformName,
          price: price,
          originalPrice: originalPrice,
          discountPercentage: double.parse(discount.toStringAsFixed(1)),
          rating: details['rating'],
          deliveryCharge: details['deliveryCharge'],
          imageUrl: imageUrl,
          buyLink: details['buyLink'],
          category: category,
        ));
      });
    }
    return products;
  }

  // Get representative items (e.g. one card per base product, showing the lowest price)
  static List<Product> getRepresentativeProducts() {
    List<Product> reps = [];
    for (var item in _baseProducts) {
      final String id = item['id'];
      final String name = item['name'];
      final String category = item['category'];
      final String imageUrl = item['imageUrl'];
      final Map<String, dynamic> platformData = item['platforms'];

      // Find the store with the lowest price to represent the product
      String bestPlatform = platformData.keys.first;
      double minPrice = platformData[bestPlatform]['price'];

      platformData.forEach((platformName, details) {
        if (details['price'] < minPrice) {
          minPrice = details['price'];
          bestPlatform = platformName;
        }
      });

      var details = platformData[bestPlatform];
      final double price = details['price'];
      final double originalPrice = details['originalPrice'];
      final double discount = ((originalPrice - price) / originalPrice) * 100;

      reps.add(Product(
        id: '${id}_$bestPlatform',
        name: name,
        platform: bestPlatform,
        price: price,
        originalPrice: originalPrice,
        discountPercentage: double.parse(discount.toStringAsFixed(1)),
        rating: details['rating'],
        deliveryCharge: details['deliveryCharge'],
        imageUrl: imageUrl,
        buyLink: details['buyLink'],
        category: category,
      ));
    }
    return reps;
  }

  // Get all platforms' pricing for a specific base product ID (e.g. 'iphone15')
  static List<Product> getComparisonsForProduct(String baseProductId) {
    // Strip platform suffix if present (e.g., 'iphone15_Amazon' -> 'iphone15')
    final String cleanId = baseProductId.split('_').first;
    
    final item = _baseProducts.firstWhere(
      (element) => element['id'] == cleanId,
      orElse: () => {},
    );

    if (item.isEmpty) return [];

    final String name = item['name'];
    final String category = item['category'];
    final String imageUrl = item['imageUrl'];
    final Map<String, dynamic> platformData = item['platforms'];

    List<Product> comparisons = [];
    platformData.forEach((platformName, details) {
      final double price = details['price'];
      final double originalPrice = details['originalPrice'];
      final double discount = ((originalPrice - price) / originalPrice) * 100;

      comparisons.add(Product(
        id: '${cleanId}_$platformName',
        name: name,
        platform: platformName,
        price: price,
        originalPrice: originalPrice,
        discountPercentage: double.parse(discount.toStringAsFixed(1)),
        rating: details['rating'],
        deliveryCharge: details['deliveryCharge'],
        imageUrl: imageUrl,
        buyLink: details['buyLink'],
        category: category,
      ));
    });

    // Sort comparisons by price ascending by default
    comparisons.sort((a, b) => a.price.compareTo(b.price));
    return comparisons;
  }

  // Search products
  static List<Product> search(String query) {
    if (query.isEmpty) {
      return getRepresentativeProducts();
    }

    final lowercaseQuery = query.toLowerCase();
    final reps = getRepresentativeProducts();

    return reps.where((product) {
      return product.name.toLowerCase().contains(lowercaseQuery) ||
             product.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get trending products (e.g., highly rated or discounted)
  static List<Product> getTrendingProducts() {
    final reps = getRepresentativeProducts();
    reps.sort((a, b) => b.rating.compareTo(a.rating));
    return reps.take(4).toList();
  }

  // Get hot deals (highest discount percentages)
  static List<Product> getHotDeals() {
    final reps = getRepresentativeProducts();
    reps.sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));
    return reps.take(4).toList();
  }
}
