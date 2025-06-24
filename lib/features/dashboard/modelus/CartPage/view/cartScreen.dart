// lib/features/dashboard/modelus/CartPage/cartScreen.dart
import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/CheckoutScreen/CheckoutScreen.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart'; // <--- تأكد من صحة هذا الاستيراد
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/product_item.dart';
import 'package:collection/collection.dart'; // <--- أضف هذا السطر

class CartScreen extends StatefulWidget {
  final List<Product> cartItems;
  final Function(Product) onRemoveFromCart;
  final Function(Product, {int quantity}) onAddToCart;

  const CartScreen({
    Key? key,
    required this.cartItems,
    required this.onRemoveFromCart,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String specialRequest = "";
  double deliveryFee = 35.0;
  bool showSuggestions = false;
  List<Product> suggestedProducts = [];
  bool _isLoadingSuggestions = false;
  final ApiService _apiService = ApiService();
  int _apiCartCount = 0;
  List<CartItem> _currentCartItems = [];
  bool _isLoadingCart = true;

  @override
  void initState() {
    super.initState();
    _fetchBasketItems();
  }

  Future<void> _fetchBasketItems() async {
    setState(() {
      _isLoadingCart = true;
    });
    try {
      _currentCartItems = await _apiService
          .fetchBasketItems(); // جلب CartItem مع productDetails
      _apiCartCount = _currentCartItems.fold(0,
          (sum, item) => sum + item.quantity); // Update count from actual items
      await _fetchSuggestedProducts();
    } catch (e) {
      print("Failed to fetch current basket items: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load cart items: $e')),
      );
      if (mounted) {
        setState(() {
          _currentCartItems = [];
          _apiCartCount = 0;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCart = false;
        });
      }
    }
  }

  Future<void> _fetchSuggestedProducts() async {
    setState(() {
      _isLoadingSuggestions = true;
    });
    try {
      List<Product> allProducts =
          await _apiService.fetchProducts(endpoint: '/api/v1/products');
      suggestedProducts = allProducts
          .where((p) => !_currentCartItems.any((cartP) =>
              cartP.productDetails?.id == p.id)) // استخدام productDetails
          .toList();
    } catch (e) {
      print("Failed to fetch suggested products: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load suggestions: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingSuggestions = false;
        });
      }
    }
  }

  Future<void> _handleAddToCartFromSuggestion(Product product,
      {int quantity = 1}) async {
    try {
      await _apiService.addProductToBasket(product.id, quantity);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} added to cart successfully!')),
      );
      await _fetchBasketItems();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add ${product.name} to cart: $e')),
      );
      print("Error adding to cart: $e");
    }
  }

  // في ملف cartScreen.dart
// ...
  Future<void> _handleUpdateQuantityInCart(
      CartItem cartItem, int change) async {
    int newQuantity = cartItem.quantity + change;
    try {
      if (newQuantity <= 0) {
        // إذا أصبحت الكمية صفر أو أقل، استدعي دالة الحذف الرئيسية التي تستقبل Product
        if (cartItem.productDetails != null) {
          await _handleRemoveFromCart(
              cartItem.productDetails!); // <--- استدعاء _handleRemoveFromCart
        } else {
          // لو مفيش تفاصيل منتج، نعتبره حذف مباشر
          await _apiService.removeProductFromBasket(cartItem.productId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Item removed from cart (no product details).')),
          );
        }
      } else {
        await _apiService.updateBasketItemQuantity(
            cartItem.itemId, newQuantity);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Quantity for ${cartItem.productDetails?.name ?? 'Item'} updated to $newQuantity.')),
        );
      }
      await _fetchBasketItems(); // تحديث السلة من الـ API بعد التعديل
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Failed to update quantity for ${cartItem.productDetails?.name ?? 'Item'}: $e')),
      );
      print("Error updating quantity: $e");
    }
  }
// ...

  // في ملف cartScreen.dart
// ...
  Future<void> _handleRemoveFromCart(Product product) async {
    // <--- تم تغيير التوقيع لقبول Product فقط
    try {
      // البحث عن الـ CartItem المقابل لهذا الـ Product
      CartItem? itemToRemove = _currentCartItems
          .firstWhereOrNull(// استخدام firstWhereOrNull لضمان الأمان
              (item) => item.productId == product.id);

      if (itemToRemove != null) {
        await _apiService.removeProductFromBasket(
            itemToRemove.itemId); // <--- استخدام itemId من CartItem
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} removed from cart.')),
        );
        await _fetchBasketItems(); // تحديث السلة من الـ API بعد الحذف
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Product not found in cart for removal: ${product.name}')),
        );
        print(
            'Error: Attempted to remove product ${product.name} but it was not found in _currentCartItems.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to remove ${product.name} from cart: $e')),
      );
      print("Error removing from cart: $e");
    }
  }
// ...

  void openSpecialRequestSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        TextEditingController requestController =
            TextEditingController(text: specialRequest);
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Any special requests?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.green),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              TextField(
                controller: requestController,
                maxLines: 3,
                maxLength: 200,
                decoration: const InputDecoration(
                  hintText: "Anything else we need to know?",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    specialRequest = requestController.text;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child:
                    const Text("Save", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext overrideContext) {
    double cartTotal = _currentCartItems.fold(
        0.0,
        (sum, item) =>
            sum +
            ((item.productDetails?.price ?? 0.0) *
                item.quantity)); // استخدام productDetails
    double totalAmount = cartTotal + deliveryFee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(overrideContext),
        ),
        title: Text("Cart (${_apiCartCount})",
            style: const TextStyle(color: Colors.black)),
      ),
      body: _isLoadingCart
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _currentCartItems.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text("Your cart is empty.",
                                style: TextStyle(fontSize: 16)),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _currentCartItems.length,
                          itemBuilder: (context, index) {
                            final cartItem = _currentCartItems[index];
                            final product = cartItem
                                .productDetails; // استخدام productDetails
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      product?.imageUrl ??
                                          'assets/images/placeholder.png', // استخدام productDetails
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          Image.asset(
                                              'assets/images/placeholder.png',
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product?.name ??
                                              'Unknown Product', // استخدام productDetails
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          "EGP ${product?.price?.toStringAsFixed(2) ?? '0.00'}", // استخدام productDetails
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.green),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 60,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                  color: Colors.green),
                                            ),
                                          ),
                                          child: Text(
                                            "${cartItem.quantity}",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () =>
                                                  _handleUpdateQuantityInCart(
                                                      cartItem, 1),
                                              child: Container(
                                                width: 40,
                                                height: 30,
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.green),
                                                    left: BorderSide(
                                                        color: Colors.green),
                                                  ),
                                                ),
                                                child: const Text("+",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () =>
                                                  _handleUpdateQuantityInCart(
                                                      cartItem, -1),
                                              child: Container(
                                                width: 40,
                                                height: 30,
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                      left: BorderSide(
                                                          color: Colors.green)),
                                                ),
                                                child: const Text("-",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                  const SizedBox(height: 20),
                  if (showSuggestions) ...[
                    const Text(
                      "You might also like ...",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    _isLoadingSuggestions
                        ? const Center(
                            child:
                                CircularProgressIndicator(color: Colors.green))
                        : suggestedProducts.isEmpty
                            ? const Center(
                                child: Text("No suggestions available."))
                            : SizedBox(
                                height: 220,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: suggestedProducts.length,
                                  itemBuilder: (context, index) {
                                    final product = suggestedProducts[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: SizedBox(
                                        width: 190,
                                        child: ProductItem(
                                          product: product,
                                          isFavorite: false,
                                          onFavoriteToggle: (p) {},
                                          onAddToCart:
                                              _handleAddToCartFromSuggestion,
                                          onRemoveFromCart:
                                              _handleRemoveFromCart,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                    const SizedBox(height: 20),
                  ],
                  GestureDetector(
                    onTap: openSpecialRequestSheet,
                    child: Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline,
                            color: Colors.black),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Any special requests?",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              specialRequest.isEmpty
                                  ? "Anything else we need to know?"
                                  : specialRequest,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Payment summary",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Cart total"),
                      Text("EGP ${cartTotal.toStringAsFixed(2)}"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Delivery"),
                      Text("EGP ${deliveryFee.toStringAsFixed(2)}"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total amount",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                      Text("EGP ${totalAmount.toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              showSuggestions = !showSuggestions;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.green),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                              showSuggestions
                                  ? "Hide suggestions"
                                  : "Add items",
                              style: const TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement checkout logic
                            // Navigate to CheckoutScreen
                            Navigator.push(
                              overrideContext,
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                  cartTotal: cartTotal,
                                  deliveryFee: deliveryFee,
                                  totalAmount: totalAmount,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Checkout",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
// import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/product_item.dart';

// class CartScreen extends StatefulWidget {
//   final List<Product> cartItems;
//   final Function(Product) onRemoveFromCart;
//   final Function(Product, {int quantity}) onAddToCart;
//   const CartScreen({
//     Key? key,
//     required this.cartItems,
//     required this.onRemoveFromCart,
//     required this.onAddToCart,
//   }) : super(key: key);

//   @override
//   _CartScreenState createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   String specialRequest = "";
//   double deliveryFee = 35.0;
//   bool showSuggestions = false;
//   List<Product> suggestedProducts = [];
//   bool _isLoadingSuggestions = false;
//   final ApiService _apiService = ApiService();
//   int _apiCartCount = 0;
//   List<CartItem> _currentCartItems = [];
//   bool _isLoadingCart = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchBasketItems();
//   }

//   Future<void> _fetchBasketItems() async {
//     setState(() {
//       _isLoadingCart = true;
//     });
//     try {
//       _currentCartItems = await _apiService.fetchBasketItems();

//       _apiCartCount =
//           _currentCartItems.fold(0, (sum, item) => sum + item.quantity);

//       await _fetchSuggestedProducts();
//     } catch (e) {
//       print("Failed to fetch current basket items: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load cart items: $e')),
//       );
//       if (mounted) {
//         // التأكد من أن الـ widget ما زال موجوداً قبل setState
//         setState(() {
//           _currentCartItems = []; // مسح السلة محلياً في حالة الخطأ
//           _apiCartCount = 0; // مسح العدد أيضاً
//         });
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoadingCart = false;
//         });
//       }
//     }
//   }

//   // جلب المنتجات المقترحة (غير الموجودة في السلة حالياً)
//   Future<void> _fetchSuggestedProducts() async {
//     setState(() {
//       _isLoadingSuggestions = true;
//     });
//     try {
//       // استدعاء fetchProducts من ApiService وتحديد الـ endpoint الخاص بالمنتجات الرئيسية
//       List<Product> allProducts =
//           await _apiService.fetchProducts(endpoint: '/api/v1/products');
//       // فلترة المنتجات المقترحة: عرض المنتجات التي ليست موجودة في _currentCartItems
//       suggestedProducts = allProducts
//           .where((p) =>
//               !_currentCartItems.any((cartP) => cartP.product.id == p.id))
//           .toList();
//     } catch (e) {
//       print("Failed to fetch suggested products: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load suggestions: $e')),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoadingSuggestions = false;
//         });
//       }
//     }
//   }

//   // دوال الإضافة/التعديل/الحذف الآن تستدعي الـ API الحقيقي
//   Future<void> _handleAddToCartFromSuggestion(Product product,
//       {int quantity = 1}) async {
//     try {
//       await _apiService.addProductToBasket(
//           product.id, quantity); // استدعاء API الإضافة الحقيقية
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('${product.name} added to cart successfully!')),
//       );
//       await _fetchBasketItems(); // تحديث السلة من الـ API بعد الإضافة
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to add ${product.name} to cart: $e')),
//       );
//       print("Error adding to cart: $e");
//     }
//   }

//   Future<void> _handleUpdateQuantityInCart(
//       CartItem cartItem, int change) async {
//     int newQuantity = cartItem.quantity + change;
//     try {
//       if (newQuantity <= 0) {
//         // إذا أصبحت الكمية صفر أو أقل، قم بحذف العنصر
//         await _apiService
//             .removeProductFromBasket(cartItem.product.id); // استدعاء API الحذف
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text('${cartItem.product.name} removed from cart.')),
//         );
//       } else {
//         await _apiService.updateBasketItemQuantity(
//             cartItem.itemId, newQuantity); // استدعاء API التحديث
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//                   'Quantity for ${cartItem.product.name} updated to $newQuantity.')),
//         );
//       }
//       await _fetchBasketItems(); // تحديث السلة من الـ API بعد التعديل
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(
//                 'Failed to update quantity for ${cartItem.product.name}: $e')),
//       );
//       print("Error updating quantity: $e");
//     }
//   }

//   // دالة الحذف المنفصلة (تستخدم في زر "-" بالـ ProductItem، أو يمكن استخدامها لزر حذف مباشر)
//   Future<void> _handleRemoveFromCart(Product product) async {
//     try {
//       await _apiService
//           .removeProductFromBasket(product.id); // استدعاء API الحذف
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('${product.name} removed from cart.')),
//       );
//       await _fetchBasketItems(); // تحديث السلة من الـ API بعد الحذف
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text('Failed to remove ${product.name} from cart: $e')),
//       );
//       print("Error removing from cart: $e");
//     }
//   }

//   void openSpecialRequestSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         TextEditingController requestController =
//             TextEditingController(text: specialRequest);
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 16,
//             right: 16,
//             top: 16,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text("Any special requests?",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                   IconButton(
//                     icon: const Icon(Icons.close, color: Colors.green),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//               TextField(
//                 controller: requestController,
//                 maxLines: 3,
//                 maxLength: 200,
//                 decoration: const InputDecoration(
//                   hintText: "Anything else we need to know?",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     specialRequest = requestController.text;
//                   });
//                   Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                 child:
//                     const Text("Save", style: TextStyle(color: Colors.white)),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double cartTotal = _currentCartItems.fold(
//         0.0, (sum, item) => sum + (item.product.price * item.quantity));
//     double totalAmount = cartTotal + deliveryFee;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text("Cart (${_apiCartCount})",
//             style: const TextStyle(color: Colors.black)),
//       ),
//       body: _isLoadingCart
//           ? const Center(child: CircularProgressIndicator(color: Colors.green))
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _currentCartItems.isEmpty
//                       ? const Center(
//                           child: Padding(
//                             padding: EdgeInsets.all(20.0),
//                             child: Text("Your cart is empty.",
//                                 style: TextStyle(fontSize: 16)),
//                           ),
//                         )
//                       : ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: _currentCartItems.length,
//                           itemBuilder: (context, index) {
//                             final cartItem = _currentCartItems[index];
//                             final product = cartItem.product;
//                             return Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Row(
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                     child: Image.network(
//                                       product.imageUrl,
//                                       width: 80,
//                                       height: 80,
//                                       fit: BoxFit.cover,
//                                       errorBuilder: (context, error,
//                                               stackTrace) =>
//                                           Image.asset(
//                                               'assets/images/placeholder.png',
//                                               width: 80,
//                                               height: 80,
//                                               fit: BoxFit.cover),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           product.name,
//                                           style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),
//                                         ),
//                                         Text(
//                                           "EGP ${product.price.toStringAsFixed(2)}",
//                                           style: const TextStyle(
//                                               color: Colors.grey, fontSize: 14),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                         border: Border.all(color: Colors.green),
//                                         borderRadius: BorderRadius.circular(5)),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           width: 40,
//                                           height: 60,
//                                           alignment: Alignment.center,
//                                           decoration: const BoxDecoration(
//                                             border: Border(
//                                               right: BorderSide(
//                                                   color: Colors.green),
//                                             ),
//                                           ),
//                                           child: Text(
//                                             "${cartItem.quantity}",
//                                             style: const TextStyle(
//                                                 fontSize: 20,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                         Column(
//                                           children: [
//                                             InkWell(
//                                               onTap: () =>
//                                                   _handleUpdateQuantityInCart(
//                                                       cartItem,
//                                                       1), // استدعاء دالة API الحقيقية
//                                               child: Container(
//                                                 width: 40,
//                                                 height: 30,
//                                                 alignment: Alignment.center,
//                                                 decoration: const BoxDecoration(
//                                                   border: Border(
//                                                     bottom: BorderSide(
//                                                         color: Colors.green),
//                                                     left: BorderSide(
//                                                         color: Colors.green),
//                                                   ),
//                                                 ),
//                                                 child: const Text("+",
//                                                     style: TextStyle(
//                                                         fontSize: 18,
//                                                         fontWeight:
//                                                             FontWeight.bold)),
//                                               ),
//                                             ),
//                                             InkWell(
//                                               onTap: () =>
//                                                   _handleUpdateQuantityInCart(
//                                                       cartItem,
//                                                       -1), // استدعاء دالة API الحقيقية
//                                               child: Container(
//                                                 width: 40,
//                                                 height: 30,
//                                                 alignment: Alignment.center,
//                                                 decoration: const BoxDecoration(
//                                                   border: Border(
//                                                       left: BorderSide(
//                                                           color: Colors.green)),
//                                                 ),
//                                                 child: const Text("-",
//                                                     style: TextStyle(
//                                                         fontSize: 18,
//                                                         fontWeight:
//                                                             FontWeight.bold)),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                   const SizedBox(height: 20),
//                   if (showSuggestions) ...[
//                     const Text(
//                       "You might also like ...",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                     ),
//                     const SizedBox(height: 10),
//                     _isLoadingSuggestions
//                         ? const Center(
//                             child:
//                                 CircularProgressIndicator(color: Colors.green))
//                         : suggestedProducts.isEmpty
//                             ? const Center(
//                                 child: Text("No suggestions available."))
//                             : SizedBox(
//                                 height: 220,
//                                 child: ListView.builder(
//                                   scrollDirection: Axis.horizontal,
//                                   itemCount: suggestedProducts.length,
//                                   itemBuilder: (context, index) {
//                                     final product = suggestedProducts[index];
//                                     return Padding(
//                                       padding:
//                                           const EdgeInsets.only(right: 10.0),
//                                       child: SizedBox(
//                                         width: 150,
//                                         child: ProductItem(
//                                           product: product,
//                                           isFavorite: false,
//                                           onFavoriteToggle: (p) {},
//                                           onAddToCart:
//                                               _handleAddToCartFromSuggestion, // استدعاء دالة API الإضافة الحقيقية
//                                           onRemoveFromCart:
//                                               _handleRemoveFromCart, // استدعاء دالة API الحذف الحقيقية
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                     const SizedBox(height: 20),
//                   ],
//                   GestureDetector(
//                     onTap: openSpecialRequestSheet,
//                     child: Row(
//                       children: [
//                         const Icon(Icons.chat_bubble_outline,
//                             color: Colors.black),
//                         const SizedBox(width: 10),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text("Any special requests?",
//                                 style: TextStyle(fontWeight: FontWeight.bold)),
//                             Text(
//                               specialRequest.isEmpty
//                                   ? "Anything else we need to know?"
//                                   : specialRequest,
//                               style: const TextStyle(color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text("Payment summary",
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Colors.green)),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text("Cart total"),
//                       Text("EGP ${cartTotal.toStringAsFixed(2)}"),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text("Delivery"),
//                       Text("EGP ${deliveryFee.toStringAsFixed(2)}"),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text("Total amount",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.green)),
//                       Text("EGP ${totalAmount.toStringAsFixed(2)}",
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: () {
//                             setState(() {
//                               showSuggestions = !showSuggestions;
//                             });
//                           },
//                           style: OutlinedButton.styleFrom(
//                             side: const BorderSide(color: Colors.green),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                           ),
//                           child: Text(
//                               showSuggestions
//                                   ? "Hide suggestions"
//                                   : "Add items",
//                               style: const TextStyle(color: Colors.black)),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             // TODO: Implement checkout logic
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                           ),
//                           child: const Text("Checkout",
//                               style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
// /*// lib/features/dashboard/modelus/CartPage/cartScreen.dart
// import 'package:flutter/material.dart';
// // تأكد أن هذا هو الاستيراد الوحيد لملف الـ models والـ services الجديد
// import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
// import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/product_item.dart';

// class CartScreen extends StatefulWidget {
//   // هذه الخصائص لم تعد تُستخدم لملء السلة مباشرةً من الخارج
//   // ولكن تم الاحتفاظ بها في الـ constructor لتجنب أخطاء الاستدعاءات الحالية
//   final List<Product>
//       cartItems; // ستكون فارغة عند الاستدعاء من ProductDetails/SearchBar
//   final Function(Product) onRemoveFromCart; // دالة وهمية في هذا السياق
//   final Function(Product, {int quantity})
//       onAddToCart; // دالة وهمية في هذا السياق

//   const CartScreen({
//     Key? key,
//     required this.cartItems,
//     required this.onRemoveFromCart,
//     required this.onAddToCart,
//   }) : super(key: key);

//   @override
//   _CartScreenState createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   String specialRequest = "";
//   double deliveryFee = 35.0;
//   bool showSuggestions = false;
//   List<Product> suggestedProducts = [];
//   bool _isLoadingSuggestions = false;
//   final ApiService _apiService = ApiService();
//   int _apiCartCount = 0; // لعرض عدد العناصر في شريط التطبيق
//   List<CartItem> _currentCartItems =
//       []; // قائمة عناصر السلة التي تم جلبها من الـ API
//   bool _isLoadingCart = true; // مؤشر تحميل لعناصر السلة

//   @override
//   void initState() {
//     super.initState();
//     _fetchBasketItems(); // جلب عناصر السلة فور تحميل الشاشة
//     _fetchApiCartCount(); // جلب عدد عناصر السلة من الـ API
//   }

//   // جلب عناصر السلة من الـ API
//   Future<void> _fetchBasketItems() async {
//     setState(() {
//       _isLoadingCart = true;
//     });
//     try {
//       _currentCartItems = await _apiService.fetchBasketItems();
//       // بعد جلب عناصر السلة، قم بتحديث المنتجات المقترحة بناءً عليها
//       await _fetchSuggestedProducts();
//       // تحديث عدد عناصر السلة في الـ AppBar بعد الجلب من الـ API
//       _apiCartCount =
//           _currentCartItems.fold(0, (sum, item) => sum + item.quantity);
//     } catch (e) {
//       print("Failed to fetch current basket items: $e");
//       if (mounted) {
//         // التأكد من أن الـ widget ما زال موجوداً قبل setState
//         setState(() {
//           _currentCartItems = []; // مسح السلة محلياً في حالة الخطأ
//           _apiCartCount = 0; // مسح العدد أيضاً
//         });
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoadingCart = false;
//         });
//       }
//     }
//   }

//   // جلب المنتجات المقترحة (غير الموجودة في السلة حالياً)
//   Future<void> _fetchSuggestedProducts() async {
//     setState(() {
//       _isLoadingSuggestions = true;
//     });
//     try {
//       List<Product> allProducts = await _apiService.fetchProducts();
//       // فلترة المنتجات المقترحة: عرض المنتجات التي ليست موجودة في _currentCartItems
//       suggestedProducts = allProducts
//           .where((p) =>
//               !_currentCartItems.any((cartP) => cartP.product.id == p.id))
//           .toList(); // إزالة .take(4) لعرض كل العناصر المقترحة مع السكرول
//     } catch (e) {
//       print("Failed to fetch suggested products: $e");
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoadingSuggestions = false;
//         });
//       }
//     }
//   }

//   // جلب عدد عناصر السلة من الـ API (للعرض في شريط التطبيق) - يمكن دمجه مع _fetchBasketItems() للحصول على عدد دقيق
//   Future<void> _fetchApiCartCount() async {
//     try {
//       int count = await _apiService
//           .fetchCartItemCount(); // ممكن يرجع رقم مختلف لو السلة مش متزامنة
//       if (mounted) {
//         setState(() {
//           // نستخدم العدد من _currentCartItems لضمان التزامن بين العدد والمعروض.
//           // _apiCartCount = count; // لو عايز العدد اللي جاي من endpoint الـ count
//         });
//       }
//     } catch (e) {
//       print("Failed to fetch API cart count: $e");
//       if (mounted) {
//         setState(() {
//           // _apiCartCount = 0; // لو عايز العدد اللي جاي من endpoint الـ count
//         });
//       }
//     }
//   }

//   // دوال الإضافة/التعديل/الحذف "الوهمية" (Dummy Functions)
//   // هذه الدوال تقوم بمحاكاة السلوك محلياً لغرض عرض الواجهة فقط
//   // في المستقبل، يجب استبدال محتواها باستدعاءات API حقيقية.
//   Future<void> _dummyAddToCartFromSuggestion(Product product,
//       {int quantity = 1}) async {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//           content:
//               Text('Dummy: Added ${product.name} (qty: $quantity) to cart.')),
//     );
//     // محاكاة إضافة المنتج محلياً وتحديث الواجهة
//     setState(() {
//       // البحث عن المنتج إذا كان موجوداً بالفعل لزيادة الكمية
//       CartItem? existingItem;
//       for (var item in _currentCartItems) {
//         if (item.product.id == product.id) {
//           existingItem = item;
//           break;
//         }
//       }

//       if (existingItem != null) {
//         existingItem.quantity += quantity;
//       } else {
//         // إضافة عنصر جديد للسلة إذا لم يكن موجوداً
//         _currentCartItems.add(CartItem(
//             product: product,
//             quantity: quantity,
//             itemId: product.id)); // استخدام product.id كـ itemId مؤقت
//       }
//       _apiCartCount = _currentCartItems.fold(
//           0, (sum, item) => sum + item.quantity); // تحديث العدد الكلي محلياً
//     });
//     // تحديث المنتجات المقترحة لإزالة المنتج الذي تم إضافته
//     await _fetchSuggestedProducts();
//   }

//   Future<void> _dummyUpdateQuantityInCart(CartItem cartItem, int change) async {
//     // محاكاة تحديث الكمية محلياً وتحديث الواجهة
//     setState(() {
//       int newQuantity = cartItem.quantity + change;
//       if (newQuantity <= 0) {
//         // إذا أصبحت الكمية صفر أو أقل، قم بحذف العنصر
//         _currentCartItems.removeWhere((item) => item.itemId == cartItem.itemId);
//       } else {
//         cartItem.quantity = newQuantity;
//       }
//       _apiCartCount = _currentCartItems.fold(
//           0, (sum, item) => sum + item.quantity); // تحديث العدد الكلي محلياً
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//           content:
//               Text('Dummy: Updated quantity for ${cartItem.product.name}.')),
//     );
//   }

//   Future<void> _dummyRemoveFromCartUI(Product product) async {
//     // محاكاة إزالة المنتج محلياً وتحديث الواجهة
//     setState(() {
//       _currentCartItems.removeWhere((item) => item.product.id == product.id);
//       _apiCartCount = _currentCartItems.fold(
//           0, (sum, item) => sum + item.quantity); // تحديث العدد الكلي محلياً
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Dummy: Removed ${product.name} from cart.')),
//     );
//     // تحديث المنتجات المقترحة لإظهار المنتج الذي تم حذفه
//     await _fetchSuggestedProducts();
//   }

//   // فتح BottomSheet لإضافة طلب خاص
//   void openSpecialRequestSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         TextEditingController requestController =
//             TextEditingController(text: specialRequest);
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 16,
//             right: 16,
//             top: 16,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text("Any special requests?",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                   IconButton(
//                     icon: const Icon(Icons.close, color: Colors.green),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//               TextField(
//                 controller: requestController,
//                 maxLines: 3,
//                 maxLength: 200,
//                 decoration: const InputDecoration(
//                   hintText: "Anything else we need to know?",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     specialRequest = requestController.text;
//                   });
//                   Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                 child:
//                     const Text("Save", style: TextStyle(color: Colors.white)),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // حساب إجمالي السلة من _currentCartItems (التي تم جلبها أو محاكاتها محلياً)
//     double cartTotal = _currentCartItems.fold(
//         0.0, (sum, item) => sum + (item.product.price * item.quantity));
//     double totalAmount = cartTotal + deliveryFee;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//             "Cart (${_apiCartCount})", // عرض العدد الكلي للعناصر (من الـ API أو المحلي)
//             style: const TextStyle(color: Colors.black)),
//       ),
//       body: _isLoadingCart // عرض مؤشر تحميل أثناء جلب عناصر السلة
//           ? const Center(child: CircularProgressIndicator(color: Colors.green))
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // قائمة عناصر السلة (تستخدم _currentCartItems)
//                   _currentCartItems.isEmpty
//                       ? const Center(
//                           child: Padding(
//                             padding: EdgeInsets.all(20.0),
//                             child: Text("Your cart is empty.",
//                                 style: TextStyle(fontSize: 16)),
//                           ),
//                         )
//                       : ListView.builder(
//                           shrinkWrap: true,
//                           physics:
//                               const NeverScrollableScrollPhysics(), // لمنع مشاكل التمرير مع SingleChildScrollView
//                           itemCount: _currentCartItems.length,
//                           itemBuilder: (context, index) {
//                             final cartItem = _currentCartItems[index];
//                             final product = cartItem
//                                 .product; // استخراج كائن المنتج من CartItem
//                             return Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Row(
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                     child: Image.network(
//                                       product.imageUrl,
//                                       width: 80,
//                                       height: 80,
//                                       fit: BoxFit.cover,
//                                       errorBuilder: (context, error,
//                                               stackTrace) =>
//                                           Image.asset(
//                                               'assets/images/placeholder.png',
//                                               width: 80,
//                                               height: 80,
//                                               fit: BoxFit.cover),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           product.name,
//                                           style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),
//                                         ),
//                                         Text(
//                                           "EGP ${product.price.toStringAsFixed(2)}",
//                                           style: const TextStyle(
//                                               color: Colors.grey, fontSize: 14),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   // عناصر التحكم في الكمية
//                                   Container(
//                                     decoration: BoxDecoration(
//                                         border: Border.all(color: Colors.green),
//                                         borderRadius: BorderRadius.circular(5)),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           width: 40,
//                                           height: 60,
//                                           alignment: Alignment.center,
//                                           decoration: const BoxDecoration(
//                                             border: Border(
//                                               right: BorderSide(
//                                                   color: Colors.green),
//                                             ),
//                                           ),
//                                           child: Text(
//                                             "${cartItem.quantity}", // عرض الكمية الفعلية من الـ API
//                                             style: const TextStyle(
//                                                 fontSize: 20,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                         Column(
//                                           children: [
//                                             InkWell(
//                                               onTap: () =>
//                                                   _dummyUpdateQuantityInCart(
//                                                       cartItem,
//                                                       1), // دالة وهمية لزيادة الكمية
//                                               child: Container(
//                                                 width: 40,
//                                                 height: 30,
//                                                 alignment: Alignment.center,
//                                                 decoration: const BoxDecoration(
//                                                   border: Border(
//                                                     bottom: BorderSide(
//                                                         color: Colors.green),
//                                                     left: BorderSide(
//                                                         color: Colors.green),
//                                                   ),
//                                                 ),
//                                                 child: const Text("+",
//                                                     style: TextStyle(
//                                                         fontSize: 18,
//                                                         fontWeight:
//                                                             FontWeight.bold)),
//                                               ),
//                                             ),
//                                             InkWell(
//                                               onTap: () =>
//                                                   _dummyUpdateQuantityInCart(
//                                                       cartItem,
//                                                       -1), // دالة وهمية لإنقاص الكمية
//                                               child: Container(
//                                                 width: 40,
//                                                 height: 30,
//                                                 alignment: Alignment.center,
//                                                 decoration: const BoxDecoration(
//                                                   border: Border(
//                                                       left: BorderSide(
//                                                           color: Colors.green)),
//                                                 ),
//                                                 child: const Text("-",
//                                                     style: TextStyle(
//                                                         fontSize: 18,
//                                                         fontWeight:
//                                                             FontWeight.bold)),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                   const SizedBox(height: 20),
//                   // قسم "You might also like..."
//                   if (showSuggestions) ...[
//                     const Text(
//                       "You might also like ...",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                     ),
//                     const SizedBox(height: 10),
//                     _isLoadingSuggestions
//                         ? const Center(
//                             child:
//                                 CircularProgressIndicator(color: Colors.green))
//                         : suggestedProducts.isEmpty
//                             ? const Center(
//                                 child: Text("No suggestions available."))
//                             : SizedBox(
//                                 height: 220, // ارتفاع ثابت لضمان السكرول الأفقي
//                                 child: ListView.builder(
//                                   scrollDirection:
//                                       Axis.horizontal, // سكرول أفقي
//                                   itemCount: suggestedProducts
//                                       .length, // عدد العناصر المقترحة
//                                   itemBuilder: (context, index) {
//                                     final product = suggestedProducts[index];
//                                     return Padding(
//                                       padding:
//                                           const EdgeInsets.only(right: 10.0),
//                                       child: SizedBox(
//                                         width: 150, // عرض ثابت لكل عنصر مقترح
//                                         child: ProductItem(
//                                           product: product,
//                                           isFavorite:
//                                               false, // افتراضياً غير مفضل
//                                           onFavoriteToggle:
//                                               (p) {}, // لا يوجد تفضيل هنا
//                                           onAddToCart:
//                                               _dummyAddToCartFromSuggestion, // دالة وهمية للإضافة
//                                           onRemoveFromCart:
//                                               (p) {}, // دالة وهمية للحذف
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                     const SizedBox(height: 20),
//                   ],
//                   // قسم الطلبات الخاصة وملخص الدفع والأزرار (لا تغييرات جوهرية)
//                   GestureDetector(
//                     onTap: openSpecialRequestSheet,
//                     child: Row(
//                       children: [
//                         const Icon(Icons.chat_bubble_outline,
//                             color: Colors.black),
//                         const SizedBox(width: 10),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text("Any special requests?",
//                                 style: TextStyle(fontWeight: FontWeight.bold)),
//                             Text(
//                               specialRequest.isEmpty
//                                   ? "Anything else we need to know?"
//                                   : specialRequest,
//                               style: const TextStyle(color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text("Payment summary",
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Colors.green)),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text("Cart total"),
//                       Text("EGP ${cartTotal.toStringAsFixed(2)}"),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text("Delivery"),
//                       Text("EGP ${deliveryFee.toStringAsFixed(2)}"),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text("Total amount",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.green)),
//                       Text("EGP ${totalAmount.toStringAsFixed(2)}",
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: () {
//                             setState(() {
//                               showSuggestions = !showSuggestions;
//                             });
//                           },
//                           style: OutlinedButton.styleFrom(
//                             side: const BorderSide(color: Colors.green),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                           ),
//                           child: Text(
//                               showSuggestions
//                                   ? "Hide suggestions"
//                                   : "Add items",
//                               style: const TextStyle(color: Colors.black)),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             // TODO: Implement checkout logic
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                           ),
//                           child: const Text("Checkout",
//                               style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }*/
// // lib/features/dashboard/modelus/CartPage/cartScreen.dart
// /*import 'package:flutter/material.dart';
// import 'package:greanspherproj/features/dashboard/modelus/CartPage/model/product_data.dart';
// import 'package:greanspherproj/features/dashboard/modelus/Component/model/Component_data.dart';
// import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/product_item.dart';

// class CartScreen extends StatefulWidget {
//   // هذه الخصائص لم تعد تُستخدم لملء السلة مباشرةً من الخارج
//   // ولكن تم الاحتفاظ بها في الـ constructor لتجنب أخطاء الاستدعاءات الحالية
//   final List<Product> cartItems;
//   final Function(Product) onRemoveFromCart;
//   final Function(Product, {int quantity}) onAddToCart;

//   const CartScreen({
//     Key? key,
//     required this.cartItems,
//     required this.onRemoveFromCart,
//     required this.onAddToCart,
//   }) : super(key: key);

//   @override
//   _CartScreenState createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   String specialRequest = "";
//   double deliveryFee = 35.0;
//   bool showSuggestions = false;
//   List<Product> suggestedProducts = [];
//   bool _isLoadingSuggestions = false;
//   final ApiService _apiService = ApiService();
//   int _apiCartCount = 0; // لعرض عدد العناصر في شريط التطبيق
//   List<CartItem> _currentCartItems = []; // قائمة عناصر السلة التي تم جلبها من الـ API
//   bool _isLoadingCart = true; // مؤشر تحميل لعناصر السلة

//   @override
//   void initState() {
//     super.initState();
//     _fetchBasketItems(); // جلب عناصر السلة فور تحميل الشاشة
//     _fetchApiCartCount(); // جلب عدد عناصر السلة من الـ API
//     // _fetchSuggestedProducts() سيتم استدعاؤها بعد جلب عناصر السلة لضمان الفلترة الصحيحة.
//   }

//   // جلب عناصر السلة من الـ API
//   Future<void> _fetchBasketItems() async {
//     setState(() {
//       _isLoadingCart = true;
//     });
//     try {
//       _currentCartItems = await _apiService.fetchBasketItems();
//       // بعد جلب عناصر السلة، قم بتحديث المنتجات المقترحة بناءً عليها
//       await _fetchSuggestedProducts();
//     } catch (e) {
//       print("Failed to fetch current basket items: $e");
//       // يمكن عرض رسالة خطأ للمستخدم هنا
//       if (mounted) { // التأكد من أن الـ widget ما زال موجوداً قبل setState
//         setState(() {
//           _currentCartItems = []; // مسح السلة محلياً في حالة الخطأ
//         });
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoadingCart = false;
//         });
//       }
//     }
//   }

//   // جلب المنتجات المقترحة (غير الموجودة في السلة حالياً)
//   Future<void> _fetchSuggestedProducts() async {
//     setState(() {
//       _isLoadingSuggestions = true;
//     });
//     try {
//       List<Product> allProducts = await _apiService.fetchProducts();
//       // فلترة المنتجات المقترحة: عرض المنتجات التي ليست موجودة في _currentCartItems
//       suggestedProducts = allProducts
//           .where((p) => !_currentCartItems.any((cartP) => cartP.product.id == p.id))
//           .toList(); // إزالة .take(4) لعرض كل العناصر المقترحة مع السكرول
//     } catch (e) {
//       print("Failed to fetch suggested products: $e");
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoadingSuggestions = false;
//         });
//       }
//     }
//   }

//   // جلب عدد عناصر السلة من الـ API (للعرض في شريط التطبيق)
//   Future<void> _fetchApiCartCount() async {
//     try {
//       int count = await _apiService.fetchCartItemCount();
//       if (mounted) {
//         setState(() {
//           _apiCartCount = count;
//         });
//       }
//     } catch (e) {
//       print("Failed to fetch API cart count: $e");
//       if (mounted) {
//         setState(() {
//           _apiCartCount = 0;
//         });
//       }
//     }
//   }

//   // دوال الإضافة/التعديل/الحذف "الوهمية" (Dummy Functions)
//   // هذه الدوال تقوم بمحاكاة السلوك محلياً لغرض عرض الواجهة فقط
//   // في المستقبل، يجب استبدال محتواها باستدعاءات API حقيقية.
//   Future<void> _dummyAddToCartFromSuggestion(Product product, {int quantity = 1}) async {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Dummy: Added ${product.name} (qty: $quantity) to cart.')),
//     );
//     // محاكاة إضافة المنتج محلياً وتحديث الواجهة
//     setState(() {
//       // البحث عن المنتج إذا كان موجوداً بالفعل لزيادة الكمية
//       CartItem? existingItem;
//       for (var item in _currentCartItems) {
//         if (item.product.id == product.id) {
//           existingItem = item;
//           break;
//         }
//       }

//       if (existingItem != null) {
//         existingItem.quantity += quantity;
//       } else {
//         // إضافة عنصر جديد للسلة إذا لم يكن موجوداً
//         _currentCartItems.add(CartItem(product: product, quantity: quantity, itemId: product.id)); // استخدام product.id كـ itemId مؤقت
//       }
//       _apiCartCount = _currentCartItems.fold(0, (sum, item) => sum + item.quantity); // تحديث العدد الكلي
//     });
//     // تحديث المنتجات المقترحة لإزالة المنتج الذي تم إضافته
//     await _fetchSuggestedProducts();
//   }

//   Future<void> _dummyUpdateQuantityInCart(CartItem cartItem, int change) async {
//     // محاكاة تحديث الكمية محلياً وتحديث الواجهة
//     setState(() {
//       int newQuantity = cartItem.quantity + change;
//       if (newQuantity <= 0) {
//         // إذا أصبحت الكمية صفر أو أقل، قم بحذف العنصر
//         _currentCartItems.removeWhere((item) => item.itemId == cartItem.itemId);
//       } else {
//         cartItem.quantity = newQuantity;
//       }
//       _apiCartCount = _currentCartItems.fold(0, (sum, item) => sum + item.quantity); // تحديث العدد الكلي
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Dummy: Updated quantity for ${cartItem.product.name}.')),
//     );
//   }

//   Future<void> _dummyRemoveFromCartUI(Product product) async {
//     // محاكاة إزالة المنتج محلياً وتحديث الواجهة
//     setState(() {
//       _currentCartItems.removeWhere((item) => item.product.id == product.id);
//       _apiCartCount = _currentCartItems.fold(0, (sum, item) => sum + item.quantity); // تحديث العدد الكلي
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Dummy: Removed ${product.name} from cart.')),
//     );
//     // تحديث المنتجات المقترحة لإظهار المنتج الذي تم حذفه
//     await _fetchSuggestedProducts();
//   }

//   // فتح BottomSheet لإضافة طلب خاص
//   void openSpecialRequestSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         TextEditingController requestController =
//             TextEditingController(text: specialRequest);
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 16,
//             right: 16,
//             top: 16,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text("Any special requests?",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                   IconButton(
//                     icon: const Icon(Icons.close, color: Colors.green),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//               TextField(
//                 controller: requestController,
//                 maxLines: 3,
//                 maxLength: 200,
//                 decoration: const InputDecoration(
//                   hintText: "Anything else we need to know?",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     specialRequest = requestController.text;
//                   });
//                   Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                 child:
//                     const Text("Save", style: TextStyle(color: Colors.white)),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // حساب إجمالي السلة من _currentCartItems (التي تم جلبها أو محاكاتها محلياً)
//     double cartTotal = _currentCartItems.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
//     double totalAmount = cartTotal + deliveryFee;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text("Cart (${_apiCartCount})", // عرض العدد الكلي للعناصر (من الـ API أو المحلي)
//             style: const TextStyle(color: Colors.black)),
//       ),
//       body: _isLoadingCart // عرض مؤشر تحميل أثناء جلب عناصر السلة
//           ? const Center(child: CircularProgressIndicator(color: Colors.green))
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // قائمة عناصر السلة (تستخدم _currentCartItems)
//                   _currentCartItems.isEmpty
//                       ? const Center(
//                           child: Padding(
//                             padding: EdgeInsets.all(20.0),
//                             child: Text("Your cart is empty.", style: TextStyle(fontSize: 16)),
//                           ),
//                         )
//                       : ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(), // لمنع مشاكل التمرير مع SingleChildScrollView
//                           itemCount: _currentCartItems.length,
//                           itemBuilder: (context, index) {
//                             final cartItem = _currentCartItems[index];
//                             final product = cartItem.product; // استخراج كائن المنتج من CartItem
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Row(
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                     child: Image.network(
//                                       product.imageUrl,
//                                       width: 80,
//                                       height: 80,
//                                       fit: BoxFit.cover,
//                                       errorBuilder: (context, error, stackTrace) =>
//                                           Image.asset('assets/images/placeholder.png',
//                                               width: 80, height: 80, fit: BoxFit.cover),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           product.name,
//                                           style: const TextStyle(
//                                               fontWeight: FontWeight.bold, fontSize: 16),
//                                         ),
//                                         Text(
//                                           "EGP ${product.price.toStringAsFixed(2)}",
//                                           style: const TextStyle(
//                                               color: Colors.grey, fontSize: 14),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   // عناصر التحكم في الكمية
//                                   Container(
//                                     decoration: BoxDecoration(
//                                         border: Border.all(color: Colors.green),
//                                         borderRadius: BorderRadius.circular(5)),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           width: 40,
//                                           height: 60,
//                                           alignment: Alignment.center,
//                                           decoration: const BoxDecoration(
//                                             border: Border(
//                                               right: BorderSide(color: Colors.green),
//                                             ),
//                                           ),
//                                           child: Text(
//                                             "${cartItem.quantity}", // عرض الكمية الفعلية من الـ API
//                                             style: const TextStyle(
//                                                 fontSize: 20, fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                         Column(
//                                           children: [
//                                             InkWell(
//                                               onTap: () => _dummyUpdateQuantityInCart(cartItem, 1), // دالة وهمية لزيادة الكمية
//                                               child: Container(
//                                                 width: 40,
//                                                 height: 30,
//                                                 alignment: Alignment.center,
//                                                 decoration: const BoxDecoration(
//                                                   border: Border(
//                                                     bottom: BorderSide(color: Colors.green),
//                                                     left: BorderSide(color: Colors.green),
//                                                   ),
//                                                 ),
//                                                 child: const Text("+",
//                                                     style: TextStyle(
//                                                         fontSize: 18,
//                                                         fontWeight: FontWeight.bold)),
//                                               ),
//                                             ),
//                                             InkWell(
//                                               onTap: () => _dummyUpdateQuantityInCart(cartItem, -1), // دالة وهمية لإنقاص الكمية
//                                               child: Container(
//                                                 width: 40,
//                                                 height: 30,
//                                                 alignment: Alignment.center,
//                                                 decoration: const BoxDecoration(
//                                                   border: Border(
//                                                       left: BorderSide(color: Colors.green)),
//                                                 ),
//                                                 child: const Text("-",
//                                                     style: TextStyle(
//                                                         fontSize: 18,
//                                                         fontWeight: FontWeight.bold)),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                   const SizedBox(height: 20),
//                   // قسم "You might also like..."
//                   if (showSuggestions) ...[
//                     const Text(
//                       "You might also like ...",
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                     ),
//                     const SizedBox(height: 10),
//                     _isLoadingSuggestions
//                         ? const Center(
//                             child: CircularProgressIndicator(color: Colors.green))
//                         : suggestedProducts.isEmpty
//                             ? const Center(child: Text("No suggestions available."))
//                             : SizedBox(
//                                 height: 220, // ارتفاع ثابت لضمان السكرول الأفقي
//                                 child: ListView.builder(
//                                   scrollDirection: Axis.horizontal, // سكرول أفقي
//                                   itemCount: suggestedProducts.length, // عدد العناصر المقترحة
//                                   itemBuilder: (context, index) {
//                                     final product = suggestedProducts[index];
//                                     return Padding(
//                                       padding: const EdgeInsets.only(right: 10.0),
//                                       child: SizedBox(
//                                         width: 150, // عرض ثابت لكل عنصر مقترح
//                                         child: ProductItem(
//                                           product: product,
//                                           isFavorite: false, // افتراضياً غير مفضل
//                                           onFavoriteToggle: (p) {}, // لا يوجد تفضيل هنا
//                                           onAddToCart: _dummyAddToCartFromSuggestion, // دالة وهمية للإضافة
//                                           onRemoveFromCart: (p) {}, // دالة وهمية للحذف
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                     const SizedBox(height: 20),
//                   ],
//                   // قسم الطلبات الخاصة وملخص الدفع والأزرار (لا تغييرات جوهرية)
//                   GestureDetector(
//                     onTap: openSpecialRequestSheet,
//                     child: Row(
//                       children: [
//                         const Icon(Icons.chat_bubble_outline, color: Colors.black),
//                         const SizedBox(width: 10),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text("Any special requests?",
//                                 style: TextStyle(fontWeight: FontWeight.bold)),
//                             Text(
//                               specialRequest.isEmpty
//                                   ? "Anything else we need to know?"
//                                   : specialRequest,
//                               style: const TextStyle(color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text("Payment summary",
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Colors.green)),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text("Cart total"),
//                       Text("EGP ${cartTotal.toStringAsFixed(2)}"),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text("Delivery"),
//                       Text("EGP ${deliveryFee.toStringAsFixed(2)}"),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text("Total amount",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, color: Colors.green)),
//                       Text("EGP ${totalAmount.toStringAsFixed(2)}",
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: () {
//                             setState(() {
//                               showSuggestions = !showSuggestions;
//                             });
//                           },
//                           style: OutlinedButton.styleFrom(
//                             side: const BorderSide(color: Colors.green),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                           ),
//                           child: Text(
//                               showSuggestions ? "Hide suggestions" : "Add items",
//                               style: const TextStyle(color: Colors.black)),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             // TODO: Implement checkout logic
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                           ),
//                           child: const Text("Checkout",
//                               style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }*/
// // lib/features/dashboard/modelus/CartPage/cartScreen.dart
// /*import 'package:flutter/material.dart';
// import 'package:greanspherproj/features/dashboard/modelus/Component/model/product_data.dart'; // Import Product and ApiService
// import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/product_item.dart'; // To reuse ProductItem for suggestions

// // lib/features/dashboard/modelus/CartPage/cartScreen.dart
// import 'package:flutter/material.dart';
// import 'package:greanspherproj/features/dashboard/modelus/Component/model/product_data.dart';
// import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/product_item.dart';

// class CartScreen extends StatefulWidget {
//   final List<Product> cartItems;
//   final Function(Product) onRemoveFromCart;
//   final Function(Product) onAddToCart;

//   const CartScreen({
//     Key? key,
//     required this.cartItems,
//     required this.onRemoveFromCart,
//     required this.onAddToCart,
//   }) : super(key: key);

//   @override
//   _CartScreenState createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   String specialRequest = "";
//   double deliveryFee = 35.0;
//   bool showSuggestions = false;
//   List<Product> suggestedProducts = [];
//   bool _isLoadingSuggestions = false;
//   final ApiService _apiService = ApiService();
//   int _apiCartCount = 0; // New state to store cart count from API

//   @override
//   void initState() {
//     super.initState();
//     _fetchSuggestedProducts();
//     _fetchApiCartCount(); // Fetch API cart count on initialization
//   }

//   Future<void> _fetchSuggestedProducts() async {
//     setState(() {
//       _isLoadingSuggestions = true;
//     });
//     try {
//       List<Product> allProducts = await _apiService.fetchProducts();
//       suggestedProducts = allProducts
//           .where((p) => !widget.cartItems.any((cartP) => cartP.name == p.name))
//           .take(4)
//           .toList();
//     } catch (e) {
//       print("Failed to fetch suggested products: $e");
//     } finally {
//       setState(() {
//         _isLoadingSuggestions = false;
//       });
//     }
//   }

//   // New: Method to fetch cart count from API
//   Future<void> _fetchApiCartCount() async {
//     try {
//       int count = await _apiService.fetchCartItemCount();
//       setState(() {
//         _apiCartCount = count;
//       });
//     } catch (e) {
//       print("Failed to fetch API cart count: $e");
//       // Optionally, show an error message or set count to 0
//       setState(() {
//         _apiCartCount = 0;
//       });
//     }
//   }

//   void openSpecialRequestSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         TextEditingController requestController =
//             TextEditingController(text: specialRequest);
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 16,
//             right: 16,
//             top: 16,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text("Any special requests?",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                   IconButton(
//                     icon: const Icon(Icons.close, color: Colors.green),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//               TextField(
//                 controller: requestController,
//                 maxLines: 3,
//                 maxLength: 200,
//                 decoration: const InputDecoration(
//                   hintText: "Anything else we need to know?",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     specialRequest = requestController.text;
//                   });
//                   Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                 child:
//                     const Text("Save", style: TextStyle(color: Colors.white)),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double cartTotal =
//         widget.cartItems.fold(0.0, (sum, item) => sum + item.price);
//     double totalAmount = cartTotal + deliveryFee;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text("Cart (${_apiCartCount})",
//             style: const TextStyle(color: Colors.black)), // Display API count
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: widget.cartItems.length,
//               itemBuilder: (context, index) {
//                 final product = widget.cartItems[index];
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Row(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8.0),
//                         child: Image.network(
//                           product.imageUrl,
//                           width: 80,
//                           height: 80,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) =>
//                               Image.asset('assets/images/placeholder.png',
//                                   width: 80, height: 80, fit: BoxFit.cover),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               product.name,
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 16),
//                             ),
//                             Text(
//                               "EGP ${product.price.toStringAsFixed(2)}",
//                               style: const TextStyle(
//                                   color: Colors.grey, fontSize: 14),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.green),
//                             borderRadius: BorderRadius.circular(5)),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 40,
//                               height: 60,
//                               alignment: Alignment.center,
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   right: BorderSide(color: Colors.green),
//                                 ),
//                               ),
//                               child: const Text(
//                                 "1",
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             Column(
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     // Consider adding quantity logic here
//                                   },
//                                   child: Container(
//                                     width: 40,
//                                     height: 30,
//                                     alignment: Alignment.center,
//                                     decoration: const BoxDecoration(
//                                       border: Border(
//                                         bottom: BorderSide(color: Colors.green),
//                                         left: BorderSide(color: Colors.green),
//                                       ),
//                                     ),
//                                     child: const Text("+",
//                                         style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold)),
//                                   ),
//                                 ),
//                                 InkWell(
//                                   onTap: () => widget.onRemoveFromCart(product),
//                                   child: Container(
//                                     width: 40,
//                                     height: 30,
//                                     alignment: Alignment.center,
//                                     decoration: const BoxDecoration(
//                                       border: Border(
//                                           left:
//                                               BorderSide(color: Colors.green)),
//                                     ),
//                                     child: const Text("-",
//                                         style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold)),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 20),
//             if (showSuggestions) ...[
//               const Text(
//                 "You might also like ...",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//               const SizedBox(height: 10),
//               _isLoadingSuggestions
//                   ? const Center(
//                       child: CircularProgressIndicator(color: Colors.green))
//                   : suggestedProducts.isEmpty
//                       ? const Center(child: Text("No suggestions available."))
//                       : SizedBox(
//                           height: 220,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: suggestedProducts.length,
//                             itemBuilder: (context, index) {
//                               final product = suggestedProducts[index];
//                               return Padding(
//                                 padding: const EdgeInsets.only(right: 10.0),
//                                 child: SizedBox(
//                                   width: 150,
//                                   child: ProductItem(
//                                     product: product,
//                                     isFavorite: false,
//                                     onFavoriteToggle: (p) {},
//                                     onAddToCart: widget.onAddToCart,
//                                     onRemoveFromCart: (p) {},
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//               const SizedBox(height: 20),
//             ],
//             GestureDetector(
//               onTap: openSpecialRequestSheet,
//               child: Row(
//                 children: [
//                   const Icon(Icons.chat_bubble_outline, color: Colors.black),
//                   const SizedBox(width: 10),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text("Any special requests?",
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       Text(
//                         specialRequest.isEmpty
//                             ? "Anything else we need to know?"
//                             : specialRequest,
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text("Payment summary",
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Colors.green)),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Cart total"),
//                 Text("EGP ${cartTotal.toStringAsFixed(2)}"),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Delivery"),
//                 Text("EGP ${deliveryFee.toStringAsFixed(2)}"),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Total amount",
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.green)),
//                 Text("EGP ${totalAmount.toStringAsFixed(2)}",
//                     style: const TextStyle(fontWeight: FontWeight.bold)),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () {
//                       setState(() {
//                         showSuggestions = !showSuggestions;
//                       });
//                     },
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: Colors.green),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     child: Text(
//                         showSuggestions ? "Hide suggestions" : "Add items",
//                         style: const TextStyle(color: Colors.black)),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // TODO: Implement checkout logic
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     child: const Text("Checkout",
//                         style: TextStyle(color: Colors.white)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }*/
