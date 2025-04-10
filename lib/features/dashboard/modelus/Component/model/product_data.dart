class Product {
  final String imageUrl;
  final String name;
  final double price;
  final double oldPrice;
  final String category;
  bool isFavorite;
  bool isInCart;

  Product({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.category,
    this.isFavorite = false, // ✅ الافتراضي: غير مفضل
    this.isInCart = false, // ✅ الافتراضي: غير مضاف للسلة
  });
}
