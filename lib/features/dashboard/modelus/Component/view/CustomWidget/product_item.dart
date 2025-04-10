import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/product_data.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final bool hasFreeShipping;
  final Function(Product) onFavoriteToggle;
  final Function(Product) onAddToCart;
  final Function(Product) onRemoveFromCart;

  const ProductItem({
    Key? key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    this.hasFreeShipping = false,
  }) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  late bool isFavorite;
  late bool isInCart;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
    isInCart = widget.product.isInCart;
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    widget.onFavoriteToggle(widget.product);
  }

  void toggleCart() {
    setState(() {
      isInCart = !isInCart;
    });
    if (isInCart) {
      widget.onAddToCart(widget.product);
    } else {
      widget.onRemoveFromCart(widget.product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    widget.product.imageUrl,
                    height: 80,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.product.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isInCart ? Icons.remove_circle : Icons.add_circle,
                        color: Colors.green,
                      ),
                      onPressed: toggleCart,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'EGP ${widget.product.price}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    if (widget.product.oldPrice != null) ...[
                      const SizedBox(width: 7),
                      Text(
                        'EGP ${widget.product.oldPrice}',
                        style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 18),
                      ),
                    ],
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return const Icon(
                              Icons.star,
                              color: Colors.green,
                              size: 16,
                            );
                          }),
                        ),
                        if (widget.hasFreeShipping)
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Image.asset(
                              'assets/images/freedelivery.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ✅ أيقونة Favorite خارج الصورة (في أعلى اليمين)
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.green,
              ),
              onPressed: toggleFavorite,
            ),
          ),
        ],
      ),
    );
  }
}
