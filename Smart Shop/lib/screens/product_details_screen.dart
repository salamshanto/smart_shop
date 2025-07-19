import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/favourites_provider.dart';
import '../providers/cart_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavouritesProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: Icon(
              favProvider.isFavourite(product.id) ? Icons.favorite : Icons.favorite_border,
              color: favProvider.isFavourite(product.id) ? Colors.red : null,
            ),
            onPressed: () => favProvider.toggleFavourite(product.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            product.imageUrl.isNotEmpty
                ? Image.network(product.imageUrl, height: 180)
                : const SizedBox(
              height: 180,
              child: Center(child: Text('Image Not Available')),
            ),
            const SizedBox(height: 20),
            Text(product.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            RatingBarIndicator(
              rating: product.rating,
              itemBuilder: (ctx, _) => const Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 22,
            ),
            Text('(${product.ratingCount} reviews)'),
            const SizedBox(height: 16),
            Text(product.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 18),
            Text('\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add to Cart'),
              onPressed: () {
                cartProvider.addToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item added to cart')));
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 46)),
            ),
          ],
        ),
      ),
    );
  }
}