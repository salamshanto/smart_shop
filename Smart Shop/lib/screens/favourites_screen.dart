// lib/screens/favourites_screen.dart
import 'package:flutter/material.dart' show AppBar, BuildContext, Center, Colors, Icon, IconButton, Icons, Image, ListTile, ListView, MaterialPageRoute, Navigator, Scaffold, StatelessWidget, Text, Widget;
import 'package:provider/provider.dart';
import '../providers/favourites_provider.dart';
import '../providers/products_provider.dart';
import 'product_details_screen.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavouritesProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);

    // Filter products based on String IDs in favouriteProductIds set
    final favProducts = productsProvider.products
        .where((p) => favProvider.isFavourite(p.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: favProducts.isEmpty
          ? const Center(child: Text('No favourites yet'))
          : ListView.builder(
        itemCount: favProducts.length,
        itemBuilder: (context, idx) {
          final product = favProducts[idx];
          return ListTile(
            leading: Image.network(product.imageUrl, width: 40, height: 40),
            title: Text(product.title),
            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () => favProvider.toggleFavourite(product.id), // Use String ID
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
              );
            },
          );
        },
      ),
    );
  }
}