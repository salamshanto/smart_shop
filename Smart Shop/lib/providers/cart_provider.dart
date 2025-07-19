import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/product_model.dart'; // Ensure this import path is correct

class CartProvider with ChangeNotifier {
  // Map to hold product IDs and their quantities
  final Map<String, int> _items = {}; // productId (String) -> quantity (int)

  // Getter to access the items in the cart
  Map<String, int> get items => _items;

  // Method to add a product to the cart
  void addToCart(Product product) {
    _items.update(product.id, (qty) => qty + 1, ifAbsent: () => 1);
    notifyListeners(); // Notify listeners about the change
  }

  // Method to remove one quantity of a product from the cart
  void removeFromCart(Product product) {
    if (!_items.containsKey(product.id)) return; // Check if product is in cart
    if (_items[product.id]! > 1) {
      _items[product.id] = _items[product.id]! - 1; // Decrease quantity
    } else {
      _items.remove(product.id); // Remove product if quantity is 0
    }
    notifyListeners(); // Notify listeners about the change
  }

  // Method to remove all quantities of a product from the cart
  void removeAll(Product product) {
    _items.remove(product.id); // Remove product from cart
    notifyListeners(); // Notify listeners about the change
  }

  // Getter to calculate the total number of items in the cart
  int get totalItems => _items.values.fold(0, (prev, curr) => prev + curr);

  // Method to calculate the total price of items in the cart
  double totalPrice(List<Product> products) {
    double total = 0;
    _items.forEach((id, qty) {
      // Find the product by its string ID
      final prod = products.firstWhere(
            (p) => p.id == id,
        orElse: () => Product( // Fallback Product
          id: id,
          title: 'Unknown Product',
          imageUrl: 'https://via.placeholder.com/150',
          price: 0.0,
          description: 'Product details not available.',
          category: 'N/A',
          rating: 0.0,
          ratingCount: 0,
        ),
      );
      total += prod.price * qty; // Calculate total price
    });
    return total; // Return the total price
  }
}