// lib/providers/products_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart'; // Ensure correct import

enum ProductSort { none, priceLowHigh, priceHighLow, ratingHighLow }

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [];
  List<String> _categories = ['All']; // Initialize with 'All'
  bool _isLoading = false;
  String? _error;
  ProductSort _sortMode = ProductSort.none;
  String? _selectedCategory = 'All'; // Initialize as 'All'

  List<Product> get products {
    List<Product> filteredProducts = _products;

    if (_selectedCategory != 'All' && _selectedCategory != null) {
      filteredProducts = filteredProducts
          .where((product) => product.category == _selectedCategory)
          .toList();
    }

    switch (_sortMode) {
      case ProductSort.priceLowHigh:
        filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSort.priceHighLow:
        filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSort.ratingHighLow:
        filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ProductSort.none:
        break;
    }
    return filteredProducts;
  }

  List<String> get categories => _categories; // Getter for categories
  bool get isLoading => _isLoading;
  String? get error => _error;
  ProductSort get sortMode => _sortMode;
  String? get selectedCategory => _selectedCategory;

  ProductsProvider() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final productResponse = await http.get(Uri.parse('https://fakestoreapi.com/products'));
      if (productResponse.statusCode == 200) {
        List<dynamic> productJson = json.decode(productResponse.body);
        _products = productJson.map((json) => Product.fromJson(json)).toList();

        // Fetch categories separately
        final categoryResponse = await http.get(Uri.parse('https://fakestoreapi.com/products/categories'));
        if (categoryResponse.statusCode == 200) {
          List<dynamic> categoryJson = json.decode(categoryResponse.body);
          _categories = ['All', ...categoryJson.map((c) => c.toString()).toList()];
        } else {
          _error = 'Failed to load categories: ${categoryResponse.statusCode}';
        }
      } else {
        _error = 'Failed to load products: ${productResponse.statusCode}';
      }
    } catch (e) {
      _error = 'Error fetching products: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshProducts() async {
    await fetchProducts();
  }

  void setSortMode(ProductSort sort) {
    _sortMode = sort;
    notifyListeners();
  }

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }
}