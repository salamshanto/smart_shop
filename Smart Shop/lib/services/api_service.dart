// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart'; // Ensure Product model is correctly imported

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));

    if (response.statusCode == 200) {
      List<dynamic> productJson = json.decode(response.body);
      return productJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/products/categories'));

    if (response.statusCode == 200) {
      List<dynamic> categoryJson = json.decode(response.body);
      return categoryJson.map((c) => c.toString()).toList();
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }

// You can add more API methods here (e.g., fetchProductById, login, register)
}