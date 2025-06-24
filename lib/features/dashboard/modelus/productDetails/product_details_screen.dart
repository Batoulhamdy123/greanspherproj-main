// lib/features/dashboard/modelus/productDetails/product_details_screen.dart
import 'package:flutter/material.dart';
//import 'package:greanspherproj/features/dashboard/modelus/CartPage/cartScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/CartPage/view/cartScreen.dart';
// تأكد أن هذا هو الاستيراد الوحيد لملف الـ models والـ services الجديد
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final Function(Product, {int quantity}) onAddToCart;
  final Function(Product) onRemoveFromCart;
  final Function(Product)
      onFavoriteToggle; // <--- إضافة دالة الـ callback للمفضلة

  const ProductDetailsScreen({
    Key? key,
    required this.product,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onFavoriteToggle, // <--- يجب أن تكون مطلوبة
  }) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: const TextField(
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: "Hinted search text",
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              suffixIcon: Icon(Icons.search, color: Colors.green),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                // استخدام widget.product.isFavorite لتحديد شكل القلب
                widget.product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.green,
                size: 30,
              ),
              onPressed: () {
                // استدعاء الدالة الممررة لتغيير حالة المفضلة
                widget.onFavoriteToggle(widget.product);
                // لا نحتاج لإعادة بناء هنا، لأن الـ callback سيقوم بذلك في ComponentPage
              },
            ),
            Center(
              child: Image.network(
                widget.product.imageUrl,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/placeholder.png',
                    height: 250,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "EGP ${widget.product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    if (widget.product.oldPrice != null) ...[
                      Text(
                        "EGP ${widget.product.oldPrice!.toStringAsFixed(2)}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 66,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.green),
                          ),
                        ),
                        child: Text(
                          "$quantity",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: increaseQuantity,
                            child: Container(
                              width: 40,
                              height: 33,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.green),
                                  left: BorderSide(color: Colors.green),
                                ),
                              ),
                              child: const Text(
                                "+",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: decreaseQuantity,
                            child: Container(
                              width: 40,
                              height: 33,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(
                                    left: BorderSide(color: Colors.green)),
                              ),
                              child: const Text(
                                "-",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            buildStars(widget.product.rate),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      widget.onAddToCart(widget.product, quantity: quantity);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScreen(
                            cartItems: [],
                            onRemoveFromCart: (product) {},
                            onAddToCart: (product, {quantity = 1}) {},
                          ),
                        ),
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text(
                      "Add to cart",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement buy now logic
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Buy now",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.product.description,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStars(int rating) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.green,
          size: 24,
        ),
      ),
    );
  }
}
/*// lib/features/dashboard/modelus/productDetails/product_details_screen.dart
import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/CartPage/view/cartScreen.dart';
// تأكد أن هذا هو الاستيراد الوحيد لملف الـ models والـ services الجديد
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Favourite/view/Favourite.dart';
//import 'package:greanspherproj/features/dashboard/modelus/CartPage/cartScreen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final Function(Product, {int quantity}) onAddToCart;
  final Function(Product) onRemoveFromCart;

  const ProductDetailsScreen({
    Key? key,
    required this.product,
    required this.onAddToCart,
    required this.onRemoveFromCart,
  }) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: const TextField(
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: "Hinted search text",
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              suffixIcon: Icon(Icons.search, color: Colors.green),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(
                Icons.favorite_border,
                color: Colors.green,
                size: 30,
              ),
              onPressed: () {
                FavouriteScreen(favoriteProducts: []);
                // TODO: Implement add to favorite logic for this single product
              },
            ),
            Center(
              child: Image.network(
                widget.product.imageUrl,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/placeholder.png',
                    height: 250,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "EGP ${widget.product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    if (widget.product.oldPrice != null) ...[
                      Text(
                        "EGP ${widget.product.oldPrice!.toStringAsFixed(2)}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 66,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.green),
                          ),
                        ),
                        child: Text(
                          "$quantity",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: increaseQuantity,
                            child: Container(
                              width: 40,
                              height: 33,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.green),
                                  left: BorderSide(color: Colors.green),
                                ),
                              ),
                              child: const Text(
                                "+",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: decreaseQuantity,
                            child: Container(
                              width: 40,
                              height: 33,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(
                                    left: BorderSide(color: Colors.green)),
                              ),
                              child: const Text(
                                "-",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            buildStars(widget.product.rate),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // استدعاء الدالة الوهمية للإضافة
                      widget.onAddToCart(widget.product, quantity: quantity);

                      // التنقل إلى شاشة السلة مباشرة
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScreen(
                            cartItems: [], // CartScreen ستجلب بياناتها بنفسها
                            onRemoveFromCart: (product) {}, // دالة وهمية للحذف
                            onAddToCart: (product,
                                {quantity = 1}) {}, // دالة وهمية للإضافة
                          ),
                        ),
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: const Text(
                      "Add to cart",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement checkout logic
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Buy now",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.product.description,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStars(int rating) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.green,
          size: 24,
        ),
      ),
    );
  }
}*/
// lib/features/dashboard/modelus/ProductDetails/view/ProductDetailsScreen.dart
/*import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/Component_data.dart';
import 'package:greanspherproj/features/dashboard/modelus/CartPage/cartScreen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final Function(Product, {int quantity}) onAddToCart;
  final Function(Product) onRemoveFromCart;

  const ProductDetailsScreen({
    Key? key,
    required this.product,
    required this.onAddToCart,
    required this.onRemoveFromCart,
  }) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: const TextField(
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: "Hinted search text",
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              suffixIcon: Icon(Icons.search, color: Colors.green),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(
                Icons.favorite_border,
                color: Colors.green,
                size: 30,
              ),
              onPressed: () {
                // TODO: Implement add to favorite logic for this single product
              },
            ),
            Center(
              child: Image.network(
                widget.product.imageUrl,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/placeholder.png',
                    height: 250,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "EGP ${widget.product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    if (widget.product.oldPrice != null) ...[
                      Text(
                        "EGP ${widget.product.oldPrice!.toStringAsFixed(2)}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 66,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.green),
                          ),
                        ),
                        child: Text(
                          "$quantity",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: increaseQuantity,
                            child: Container(
                              width: 40,
                              height: 33,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.green),
                                  left: BorderSide(color: Colors.green),
                                ),
                              ),
                              child: const Text(
                                "+",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: decreaseQuantity,
                            child: Container(
                              width: 40,
                              height: 33,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(
                                    left: BorderSide(color: Colors.green)),
                              ),
                              child: const Text(
                                "-",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            buildStars(widget.product.rate),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Call the dummy onAddToCart function
                      widget.onAddToCart(widget.product, quantity: quantity);
                      // Navigator.pop(context); // Optional: if you want to go back after dummy add

                      // Navigate to CartScreen directly
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScreen(
                            cartItems: [], // CartScreen will fetch its own data
                            onRemoveFromCart: (product) {}, // Dummy function
                            onAddToCart: (product, {quantity = 1}) {}, // Dummy function
                          ),
                        ),
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text(
                      "Add to cart",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement buy now logic
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Buy now",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.product.description,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStars(int rating) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.green,
          size: 24,
        ),
      ),
    );
  }
}*/
// lib/features/dashboard/modelus/ProductDetails/view/ProductDetailsScreen.dart
/*import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/product_data.dart';
import 'package:greanspherproj/features/dashboard/modelus/CartPage/view/cartScreen.dart'; // Import CartScreen

// lib/features/dashboard/modelus/ProductDetails/view/ProductDetailsScreen.dart
import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/product_data.dart';
import 'package:greanspherproj/features/dashboard/modelus/CartPage/view/cartScreen.dart'; // Import CartScreen

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final Function(Product) onAddToCart; // Add onAddToCart callback
  final Function(Product) onRemoveFromCart; // Add onRemoveFromCart callback

  const ProductDetailsScreen({
    Key? key,
    required this.product,
    required this.onAddToCart, // Make sure these are required
    required this.onRemoveFromCart, // Make sure these are required
  }) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: const TextField(
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: "Hinted search text",
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              suffixIcon: Icon(Icons.search, color: Colors.green),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(
                Icons.favorite_border,
                color: Colors.green,
                size: 30,
              ),
              onPressed: () {
                // TODO: Implement add to favorite logic for this single product
              },
            ),
            Center(
              child: Image.network(
                widget.product.imageUrl,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/placeholder.png',
                    height: 250,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "EGP ${widget.product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    if (widget.product.oldPrice != null) ...[
                      Text(
                        "EGP ${widget.product.oldPrice!.toStringAsFixed(2)}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 66,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.green),
                          ),
                        ),
                        child: Text(
                          "$quantity",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: increaseQuantity,
                            child: Container(
                              width: 40,
                              height: 33,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.green),
                                  left: BorderSide(color: Colors.green),
                                ),
                              ),
                              child: const Text(
                                "+",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: decreaseQuantity,
                            child: Container(
                              width: 40,
                              height: 33,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(
                                    left: BorderSide(color: Colors.green)),
                              ),
                              child: const Text(
                                "-",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            buildStars(widget.product.rate),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add the product to cart using the callback
                      widget.onAddToCart(widget.product);

                      // Navigate to CartScreen directly
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScreen(
                            cartItems: [], // You'll need to pass the actual cart items here
                            onRemoveFromCart:
                                widget.onRemoveFromCart, // Pass the callback
                            onAddToCart:
                                widget.onAddToCart, // Pass the callback
                          ),
                        ),
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text(
                      "Add to cart",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement buy now logic, possibly navigating to a checkout directly
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Buy now",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.product.description,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStars(int rating) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.green,
          size: 24,
        ),
      ),
    );
  }
}
*/
