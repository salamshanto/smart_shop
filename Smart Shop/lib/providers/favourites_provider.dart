// lib/providers/favourites_provider.dart
import 'package:flutter/material.dart';

class FavouritesProvider with ChangeNotifier {
  // Use a Set of String IDs for efficient lookup
  final Set<String> _favouriteProductIds = {};

  Set<String> get favouriteProductIds => _favouriteProductIds;

  // Method to toggle favourite status, accepting String ID
  void toggleFavourite(String productId) {
    if (_favouriteProductIds.contains(productId)) {
      _favouriteProductIds.remove(productId);
    } else {
      _favouriteProductIds.add(productId);
    }
    notifyListeners();
  }

  // Method to check if a product is favourite, accepting String ID
  bool isFavourite(String productId) {
    return _favouriteProductIds.contains(productId);
  }
}