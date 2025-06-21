// lib/features/dashboard/modelus/Component/view/CustomWidget/product_item.dart
import 'package:flutter/material.dart';
// تأكد أن هذا هو الاستيراد الوحيد لملف الـ models والـ services الجديد
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/productDetails/product_details_screen.dart'; // Import the ProductDetailsScreen

class ProductItem extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final Function(Product) onFavoriteToggle;
  final Function(Product, {int quantity}) onAddToCart; // تم تحديث التوقيع
  final Function(Product) onRemoveFromCart;

  const ProductItem({
    Key? key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onAddToCart,
    required this.onRemoveFromCart,
  }) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  late bool isFavorite;
  late bool isInCart; // هل المنتج في السلة (لغرض عرض الأيقونة)

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
    isInCart = widget.product.isInCart; // تحديث isInCart من خصائص المنتج
  }

  @override
  void didUpdateWidget(covariant ProductItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite) {
      isFavorite = widget.isFavorite;
    }
    // تحديث حالة isInCart إذا تغيرت من الخارج (مثلاً بعد إضافة المنتج للسلة من شاشة أخرى)
    if (widget.product.isInCart != oldWidget.product.isInCart) {
      isInCart = widget.product.isInCart;
    }
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    widget.onFavoriteToggle(widget.product);
  }

  void toggleCart() {
    setState(() {
      isInCart = !isInCart; // تبديل حالة isInCart
    });
    if (isInCart) {
      widget.onAddToCart(widget.product,
          quantity: 1); // استدعاء دالة الإضافة مع كمية 1
    } else {
      widget.onRemoveFromCart(widget.product); // استدعاء دالة الحذف
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              product: widget.product,
              onAddToCart: widget.onAddToCart, // تمرير دالة الإضافة الوهمية
              onRemoveFromCart:
                  widget.onRemoveFromCart, // تمرير دالة الحذف الوهمية
            ),
          ),
        );
      },
      child: Card(
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
                    child: Image.network(
                      // استخدام Image.network
                      widget.product.imageUrl,
                      height: 80,
                      width: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/placeholder.png', // Fallback to placeholder
                          height: 80,
                          width: 150,
                          fit: BoxFit.cover,
                        );
                      },
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
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to start
                    children: [
                      Text(
                        'EGP ${widget.product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      if (widget.product.oldPrice != null) ...[
                        Text(
                          'EGP ${widget.product.oldPrice!.toStringAsFixed(2)}',
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
                        children: List.generate(5, (index) {
                          return Icon(
                            index < widget.product.rate
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.green,
                            size: 16,
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
      ),
    );
  }
}
// lib/features/dashboard/modelus/Component/view/CustomWidget/product_item.dart
/*import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/Component_data.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
//import 'package:greanspherproj/features/dashboard/modelus/ProductDetails/view/ProductDetailsScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/productDetails/product_details_screen.dart'; // Import the ProductDetailsScreen

// lib/features/dashboard/modelus/Component/view/CustomWidget/product_item.dart
import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/Component_data.dart';
//import 'package:greanspherproj/features/dashboard/modelus/ProductDetails/view/ProductDetailsScreen.dart'; // Import the ProductDetailsScreen

// lib/features/dashboard/modelus/Component/view/CustomWidget/product_item.dart
import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/Component_data.dart';
//import 'package:greanspherproj/features/dashboard/modelus/ProductDetails/view/ProductDetailsScreen.dart'; // Import the ProductDetailsScreen

class ProductItem extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final Function(Product) onFavoriteToggle;
  final Function(Product)
      onAddToCart; // This callback is passed from ComponentPage
  final Function(Product)
      onRemoveFromCart; // This callback is passed from ComponentPage

  const ProductItem({
    Key? key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onAddToCart, // Make sure these are required in ProductItem's constructor
    required this.onRemoveFromCart, // Make sure these are required in ProductItem's constructor
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

  @override
  void didUpdateWidget(covariant ProductItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite) {
      isFavorite = widget.isFavorite;
    }
    if (widget.product.isInCart != oldWidget.product.isInCart) {
      isInCart = widget.product.isInCart;
    }
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
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              product: widget.product,
              // Fix: Pass the required onAddToCart and onRemoveFromCart callbacks
              onAddToCart: widget
                  .onAddToCart, // Pass it down from ProductItem's widget to ProductDetailsScreen
              onRemoveFromCart: widget
                  .onRemoveFromCart, // Pass it down from ProductItem's widget to ProductDetailsScreen
            ),
          ),
        );
      },
      child: Card(
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
                    child: Image.network(
                      widget.product.imageUrl,
                      height: 80,
                      width: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/placeholder.png',
                          height: 80,
                          width: 150,
                          fit: BoxFit.cover,
                        );
                      },
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EGP ${widget.product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      if (widget.product.oldPrice != null) ...[
                        Text(
                          'EGP ${widget.product.oldPrice!.toStringAsFixed(2)}',
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
                        children: List.generate(5, (index) {
                          return Icon(
                            index < widget.product.rate
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.green,
                            size: 16,
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
      ),
    );
  }
}*/
// lib/features/dashboard/modelus/Component/view/CustomWidget/product_item.dart
/*import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/product_data.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  final bool isFavorite;
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

  @override
  void didUpdateWidget(covariant ProductItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite) {
      isFavorite = widget.isFavorite;
    }
    if (widget.product.isInCart != oldWidget.product.isInCart) {
      isInCart = widget.product.isInCart;
    }
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
                  child: Image.network(
                    // Use Image.network for URLs
                    widget.product.imageUrl,
                    height: 80,
                    width: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        // Fallback to a placeholder if image fails
                        'assets/images/componentexamle.png', // Make sure you have a placeholder image
                        height: 80,
                        width: 150,
                        fit: BoxFit.cover,
                      );
                    },
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
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to start
                  children: [
                    Text(
                      'EGP ${widget.product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    if (widget.product.oldPrice != null) ...[
                      // const SizedBox(width: 7), // Removed as it causes horizontal overflow in column
                      Text(
                        'EGP ${widget.product.oldPrice!.toStringAsFixed(2)}',
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
                            return Icon(
                              index < widget.product.rate
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.green,
                              size: 16,
                            );
                          }),
                        ),
                        // You need to determine if a product has free shipping from the API response
                        // For now, removing the hardcoded `widget.hasFreeShipping`
                        // if (widget.hasFreeShipping)
                        //   Padding(
                        //     padding: const EdgeInsets.only(left: 5),
                        //     child: Image.asset(
                        //       'assets/images/freedelivery.png',
                        //       width: 20,
                        //       height: 20,
                        //     ),
                        //   ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
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
}*/
/*import 'package:flutter/material.dart';
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
*/
