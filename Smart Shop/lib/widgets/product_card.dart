import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/favourites_provider.dart';
import '../screens/product_details_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavouritesProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final isFav = favProvider.isFavourite(product.id);

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(product: product),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: Hero(
                  tag: 'productImage-${product.id}',
                  child: Image.network(
                    product.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 80),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Product Title
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 5),
              // Product Price
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green, fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              // Rating
              Row(
                children: [
                  RatingBarIndicator(
                    rating: product.rating,
                    itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    itemSize: 18.0,
                    direction: Axis.horizontal,
                  ),
                  Text(' (${product.rating.toStringAsFixed(1)})'),
                ],
              ),
              const SizedBox(height: 10),
              // Add to Cart and Favorite Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        cartProvider.addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${product.title} added to cart!')),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                      label: const Text('Add', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : null),
                    onPressed: () => favProvider.toggleFavourite(product.id),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}