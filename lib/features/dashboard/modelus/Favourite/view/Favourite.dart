import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/product_item.dart';

class FavouriteScreen extends StatefulWidget {
  final List<Product> favoriteProducts;
  final Function(Product) onRemoveFavorite; // دالة callback للحذف
  final VoidCallback onClearAllFavorites;
  const FavouriteScreen(
      {Key? key,
      required this.favoriteProducts,
      required this.onRemoveFavorite,
      required this.onClearAllFavorites})
      : super(key: key);

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<Product> _displayFavoriteItems = [];

  @override
  void initState() {
    super.initState();
    _displayFavoriteItems = List.from(widget.favoriteProducts);
  }

  @override
  void didUpdateWidget(covariant FavouriteScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.favoriteProducts != oldWidget.favoriteProducts) {
      _displayFavoriteItems = List.from(widget.favoriteProducts);
    }
  }

  void _removeProductFromFavouriteLocally(Product product) {
    setState(() {
      _displayFavoriteItems.removeWhere((item) => item.id == product.id);
      product.isFavorite = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} removed from favorites ')),
    );
    widget.onRemoveFavorite(product);
  }

  // دالة وهمية لإضافة منتج إلى السلة من شاشة المفضلة
  void _dummyAddToCartFromFavourite(Product product, {int quantity = 1}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(' Added ${product.name} to cart from favorites ')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text("Favourite List",
            style: TextStyle(
              color: Colors.black,
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.black),
            onPressed: () {
              setState(() {
                for (var product in _displayFavoriteItems) {
                  product.isFavorite = false;
                }
                _displayFavoriteItems.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All favourites cleared ')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Hinted search text",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: const Icon(Icons.search, color: Colors.green),
              ),
              onChanged: (query) {
                // TODO: Implement search/filter logic for favourites locally
              },
            ),
          ),
          Expanded(
            child: _displayFavoriteItems.isEmpty
                ? const Center(child: Text("No favourite items yet."))
                : GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _displayFavoriteItems.length,
                    itemBuilder: (context, index) {
                      final product = _displayFavoriteItems[index];
                      return ProductItem(
                        product: product,
                        isFavorite: true,
                        onFavoriteToggle: (p) =>
                            _removeProductFromFavouriteLocally(p),
                        onAddToCart: _dummyAddToCartFromFavourite,
                        onRemoveFromCart: (p) {},
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
