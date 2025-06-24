// lib/features/dashboard/modelus/Component/view/CustomWidget/ProductGrid.dart
import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/product_item.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onFavoriteToggle;
  final Function(Product, {int quantity}) onAddToCart;
  final Function(Product) onRemoveFromCart;
  final List<Product>
      favoriteProducts; // هذه القائمة المحلية المفضلة (من ComponentPage)
  final List<Product>
      cartProducts; // هذه القائمة المحلية للسلة (من ComponentPage)

  const ProductGrid({
    Key? key,
    required this.products,
    required this.onFavoriteToggle,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.favoriteProducts,
    required this.cartProducts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text("No products found."));
    }

    return GridView.builder(
      padding: const EdgeInsets.only(top: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 7,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        // product.isFavorite و product.isInCart سيتم تحديثهما في ComponentPage
        // لا نحتاج لـ isFavorite كـ parameter منفصل هنا
        return ProductItem(
          key: ValueKey(product.id),
          product: product, // المنتج نفسه يحتوي الآن على isFavorite و isInCart
          onFavoriteToggle: onFavoriteToggle,
          onAddToCart: onAddToCart,
          onRemoveFromCart: onRemoveFromCart, isFavorite: false,
        );
      },
    );
  }
}
/*// lib/features/dashboard/modelus/Component/view/CustomWidget/ProductGrid.dart
import 'package:flutter/material.dart';
// تأكد أن هذا هو الاستيراد الوحيد لملف الـ models والـ services الجديد
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/product_item.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products; // المنتجات التي سيتم عرضها في الـ Grid
  final Function(Product) onFavoriteToggle;
  final Function(Product, {int quantity}) onAddToCart; // تم تحديث التوقيع
  final Function(Product) onRemoveFromCart;
  final List<Product> favoriteProducts;
  final List<Product> cartProducts; // هذه ستستخدم لضبط isInCart في ProductItem

  const ProductGrid({
    Key? key,
    required this.products,
    required this.onFavoriteToggle,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.favoriteProducts,
    required this.cartProducts, // قائمة منتجات السلة (لضبط isInCart)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text("No products found."));
    }

    return GridView.builder(
      padding: const EdgeInsets.only(top: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 7,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        // تحديد ما إذا كان المنتج في السلة بناءً على cartProducts التي تم تمريرها
        final bool isInCart =
            cartProducts.any((cartP) => cartP.id == product.id);

        return ProductItem(
          key: ValueKey(product.id), // استخدام Product ID كـ Key أفضل
          product: product,
          isFavorite: favoriteProducts.any(
              (fav) => fav.id == product.id), // استخدام Product ID للمقارنة
          onFavoriteToggle: onFavoriteToggle,
          onAddToCart: onAddToCart, // تمرير الدالة الوهمية
          onRemoveFromCart: onRemoveFromCart, // تمرير الدالة الوهمية
        );
      },
    );
  }
}*/
/*
// lib/features/dashboard/modelus/Component/view/CustomWidget/ProductGrid.dart
import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/Component_data.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/product_item.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products; // Accept products directly
  final Function(Product) onFavoriteToggle;
  final Function(Product) onAddToCart;
  final Function(Product) onRemoveFromCart;
  final List<Product> favoriteProducts;
  final List<Product> cartProducts;

  const ProductGrid({
    Key? key,
    required this.products, // Renamed from selectedFilter
    required this.onFavoriteToggle,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.favoriteProducts,
    required this.cartProducts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text("No products found."));
    }

    return GridView.builder(
      padding: const EdgeInsets.only(top: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 7,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductItem(
          key: ValueKey(product.name),
          product: product,
          isFavorite: favoriteProducts.any((fav) => fav.name == product.name),
          onFavoriteToggle: onFavoriteToggle,
          onAddToCart: onAddToCart,
          onRemoveFromCart: onRemoveFromCart,
        );
      },
    );
  }
}*/
/*import 'package:flutter/material.dart';
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
*/
