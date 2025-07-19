import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

// Providers
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favourites_provider.dart';

// Screens
import 'profile_screen.dart';
import 'favourites_screen.dart';
import 'login_screen.dart';
import 'cart_screen.dart'; // Import the CartScreen

// Widgets
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Shop'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          Consumer<CartProvider>(
            builder: (_, cart, __) => badges.Badge(
              badgeContent: Text(
                cart.totalItems.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              position: badges.BadgePosition.topEnd(top: 0, end: 0),
              showBadge: cart.totalItems > 0,
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CartScreen()), // Navigate to CartScreen
                  );
                },
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Hello, ${authProvider.username ?? 'Guest'}',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favourites'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FavouritesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Cart'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CartScreen()), // Navigate to CartScreen
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                Navigator.pop(context);
                await authProvider.logout();
                if (!context.mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: const ProductListWidget(),
    );
  }
}

class ProductListWidget extends StatefulWidget {
  const ProductListWidget({super.key});

  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ProductsProvider, FavouritesProvider, CartProvider>(
      builder: (context, productsProvider, favProvider, cartProvider, _) {
        if (productsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (productsProvider.error != null) {
          return Center(child: Text('Error: ${productsProvider.error}'));
        }
        final products = productsProvider.products;
        final categories = productsProvider.categories;
        final selectedCategory = productsProvider.selectedCategory;

        return RefreshIndicator(
          onRefresh: productsProvider.refreshProducts,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('Sort: '),
                        DropdownButton<ProductSort>(
                          value: productsProvider.sortMode,
                          items: const [
                            DropdownMenuItem(value: ProductSort.none, child: Text('None')),
                            DropdownMenuItem(value: ProductSort.priceLowHigh, child: Text('Price Low→High')),
                            DropdownMenuItem(value: ProductSort.priceHighLow, child: Text('Price High→Low')),
                            DropdownMenuItem(value: ProductSort.ratingHighLow, child: Text('Rating')),
                          ],
                          onChanged: (sorting) {
                            if (sorting != null) productsProvider.setSortMode(sorting);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Category: '),
                        DropdownButton<String>(
                          value: selectedCategory,
                          items: categories.map<DropdownMenuItem<String>>((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (String? newCategory) {
                            productsProvider.setSelectedCategory(newCategory);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: products.isEmpty
                    ? const Center(child: Text('No products found.'))
                    : GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, idx) {
                    final product = products[idx];
                    return ProductCard(product: product);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}