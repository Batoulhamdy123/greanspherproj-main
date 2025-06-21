// // lib/features/dashboard/modelus/Component/model/product_data.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// // Define a new class for CartItem, as the API might return quantity in cart
// class CartItem {
//   final ProductCart product;
//   int quantity;
//   final String itemId; // Represents the unique ID of the item in the basket

//   CartItem(
//       {required this.product, required this.quantity, required this.itemId});

//   factory CartItem.fromJson(Map<String, dynamic> json) {
//     // ADJUSTED: The provided API response has a nested 'product' object and 'quantity'.
//     // Assuming each item in the "items" array looks like:
//     // {
//     //   "id": "basketItemId_unique_to_this_basket_entry",
//     //   "quantity": 1,
//     //   "product": {  // Actual product details are nested here
//     //     "id": "productId",
//     //     "name": "...",
//     //     "imageUrl": "...",
//     //     "price": ...,
//     //     // ... other product fields
//     //   }
//     // }
//     return CartItem(
//       product: ProductCart.fromJson(json['product'] ??
//           {}), // Assuming 'product' key nests product details
//       quantity: (json['quantity'] ?? 1)
//           .toInt(), // Assuming 'quantity' key for quantity
//       itemId: json['id'] ??
//           '', // This is the unique ID of the item within the basket itself
//     );
//   }
// }

// class ProductCart {
//   final String name;
//   final String description;
//   final String imageUrl;
//   final double price;
//   final double? oldPrice;
//   final int rate;
//   final String category;
//   bool isInCart; // This will now reflect server state
//   final String id; // Add product ID from API

//   ProductCart({
//     required this.name,
//     required this.description,
//     required this.imageUrl,
//     required this.price,
//     this.oldPrice,
//     required this.rate,
//     required this.category,
//     this.isInCart = false,
//     required this.id, // Make it required
//   });

//   factory ProductCart.fromJson(Map<String, dynamic> json) {
//     double? oldPriceValue;
//     // Assuming 'discountPercentage' is the key to determine if there was an old price
//     if ((json['discountPercentage'] ?? 0) > 0) {
//       oldPriceValue = json['price']?.toDouble(); // The 'price' before discount
//     }

//     return ProductCart(
//       id: json['id'] ?? '', // Extract product ID
//       name: json['name'] ?? '',
//       description: json['description'] ?? '',
//       imageUrl: json['imageUrl'] ?? '',
//       price: (json['priceAfterDiscount'] ?? 0)
//           .toDouble(), // Use priceAfterDiscount for current price
//       oldPrice: oldPriceValue, // The original price if discounted
//       rate: (json['rate'] ?? 0).toInt(),
//       category: json['category'] != null ? json['category']['name'] ?? '' : '',
//     );
//   }
// }

// class ApiService {
//   static const String baseUrl = "https://greensphere-api.runasp.net";
//   static const String apiKey =
//       "5zOBJKQJFQakblcfbrq4GCqStcxxLX6LSQT8j6V6UcavIlTk6pixNw";

//   Map<String, String> get _headers => {
//         "x-api-key": apiKey,
//         'Content-Type': 'application/json',
//       };

//   Future<List<ProductCart>> fetchProducts({String? productName}) async {
//     final Map<String, String> queryParams = {};
//     if (productName != null && productName.isNotEmpty) {
//       queryParams['productName'] = productName;
//     }

//     final uri = Uri.parse('$baseUrl/api/v1/basket/me')
//         .replace(queryParameters: queryParams);

//     final response = await http.get(
//       uri,
//       headers: _headers,
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseBody = json.decode(response.body);
//       if (responseBody['isSuccess']) {
//         final List<dynamic> productJson = responseBody['value'];
//         return productJson.map((json) => ProductCart.fromJson(json)).toList();
//       } else {
//         throw Exception(responseBody['message'] ?? 'Failed to load products');
//       }
//     } else {
//       throw Exception('Failed to load products: ${response.statusCode}');
//     }
//   }

//   Future<List<String>> fetchCategories() async {
//     try {
//       final List<ProductCart> products = await fetchProducts();
//       final Set<String> categories = products.map((p) => p.category).toSet();
//       return categories.toList();
//     } catch (e) {
//       throw Exception('Failed to load categories: $e');
//     }
//   }

//   // Fetch cart item count
//   Future<int> fetchCartItemCount() async {
//     final uri = Uri.parse('$baseUrl/api/v1/basket/me/items/count');
//     final response = await http.get(uri, headers: _headers);

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseBody = json.decode(response.body);
//       if (responseBody['isSuccess']) {
//         return (responseBody['value'] ?? 0).toInt();
//       } else {
//         throw Exception(responseBody['message'] ?? 'Failed to load cart count');
//       }
//     } else {
//       throw Exception('Failed to load cart count: ${response.statusCode}');
//     }
//   }

//   // ADJUSTED: Fetch all items in the basket (GET /api/v1/basket/me)
//   Future<List<CartItem>> fetchBasketItems() async {
//     final uri = Uri.parse('$baseUrl/api/v1/basket/me');
//     final response = await http.get(uri, headers: _headers);

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseBody = json.decode(response.body);
//       if (responseBody['isSuccess']) {
//         // Access the 'items' array within the 'value' object
//         final List<dynamic> basketItemsJson =
//             responseBody['value']['items'] ?? [];
//         return basketItemsJson.map((json) => CartItem.fromJson(json)).toList();
//       } else {
//         throw Exception(
//             responseBody['message'] ?? 'Failed to load basket items');
//       }
//     } else {
//       throw Exception('Failed to load basket items: ${response.statusCode}');
//     }
//   }

//   // NOTE: Functions for POST, PUT, DELETE /api/v1/basket/me/items are removed
//   // as per your request not to implement Add/Remove/Update functionality for now.
// }
