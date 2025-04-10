import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/product_data.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/product_item.dart';

class ProductGrid extends StatelessWidget {
  final String selectedFilter;
  final Function(Product) onFavoriteToggle;
  final Function(Product) onAddToCart;
  final Function(Product) onRemoveFromCart;
  final List<Product> favoriteProducts;
  final List<Product> cartProducts;

  const ProductGrid({
    Key? key,
    required this.selectedFilter,
    required this.onFavoriteToggle,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.favoriteProducts,
    required this.cartProducts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Product> products = [
      Product(
          imageUrl: 'assets/images/componentexamle.png',
          name: '60L Solid Nutrient Tank',
          price: 625,
          oldPrice: 780,
          category: 'Best seller'),
      Product(
          imageUrl: 'assets/images/componentexamle.png',
          name: 'Product 2',
          price: 177,
          oldPrice: 247,
          category: 'Air pump'),
    ];

    final List<Product> filteredProducts = selectedFilter.isEmpty
        ? products
        : products.where((p) => p.category == selectedFilter).toList();

    return GridView.builder(
      padding: const EdgeInsets.only(top: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8, // ✅ تحسين النسبة لتناسب النص والصورة
        crossAxisSpacing: 7, // ✅ إضافة مسافة بين الأعمدة
        mainAxisSpacing: 10, // ✅ إضافة مسافة بين الصفوف
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return ProductItem(
          key: ValueKey(product.name), // ✅ تحسين الأداء باستخدام Key
          product: product,
          isFavorite: favoriteProducts.any((fav) => fav.name == product.name),
          onFavoriteToggle: onFavoriteToggle,
          onAddToCart: onAddToCart,
          onRemoveFromCart: onRemoveFromCart,
        );
      },
    );
  }
}
