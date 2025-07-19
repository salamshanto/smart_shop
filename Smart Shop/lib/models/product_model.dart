// lib/models/product.dart
class Product {
  final String id; // Keep this as String
  final String title;
  final String description;
  final double price;
  final String imageUrl; // Correct field name
  final double rating;
  final int ratingCount;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.ratingCount,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '', // Ensure ID is String
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image'] as String, // 'image' from API maps to 'imageUrl'
      rating: (json['rating']['rate'] as num).toDouble(),
      ratingCount: json['rating']['count'] as int,
      category: json['category'] as String,
    );
  }

  String? get image => null;
}