import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../models/product_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final products = Provider.of<ProductsProvider>(context).products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: cart.totalItems == 0
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 64),
            const SizedBox(height: 16),
            const Text('Your cart is empty'),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, index) {
                final item = cart.items.entries.toList()[index];
                final product = products.firstWhere(
                      (p) => p.id == item.key,
                  orElse: () => Product(
                    id: item.key,
                    title: 'Unknown Product',
                    price: 0.0,
                    description: '',
                    imageUrl: '',
                    rating: 0.0,
                    ratingCount: 0,
                    category: '',
                  ),
                );

                return ListTile(
                  leading: product.imageUrl.isNotEmpty
                      ? Image.network(
                    product.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.image),
                  title: Text(product.title),
                  subtitle: Text(
                    '\$${product.price.toStringAsFixed(2)} × ${item.value} = \$${(product.price * item.value).toStringAsFixed(2)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (item.value > 1) {
                            cart.removeFromCart(product);
                          } else {
                            cart.removeAll(product);
                          }
                        },
                      ),
                      Text(item.value.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => cart.addToCart(product),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => cart.removeAll(product),
                        color: Colors.red,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Items:'),
                        Text(cart.totalItems.toString()),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Price:'),
                        Text(
                          '\$${cart.totalPrice(products).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Proceeding to checkout'),
                            ),
                          );
                        },
                        child: const Text('Proceed to Checkout'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}