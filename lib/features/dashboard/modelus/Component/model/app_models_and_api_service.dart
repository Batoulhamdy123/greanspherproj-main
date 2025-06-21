// lib/features/dashboard/modelus/Component/model/app_models_and_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

// ----------------------------------------------------
// PRODUCT Model
// ----------------------------------------------------
class Product {
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double? oldPrice;
  final int rate;
  final String category;
  bool isInCart; // This will now reflect server state
  final String id; // Add product ID from API

  Product({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.oldPrice,
    required this.rate,
    required this.category,
    this.isInCart = false,
    required this.id, // Make it required
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    double? oldPriceValue;
    // Assuming 'discountPercentage' is the key to determine if there was an old price
    if ((json['discountPercentage'] ?? 0) > 0) {
      oldPriceValue = json['price']?.toDouble(); // The 'price' before discount
    }

    return Product(
      id: json['id'] ?? '', // Extract product ID
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['priceAfterDiscount'] ?? 0)
          .toDouble(), // Use priceAfterDiscount for current price
      oldPrice: oldPriceValue, // The original price if discounted
      rate: (json['rate'] ?? 0).toInt(),
      category: json['category'] != null ? json['category']['name'] ?? '' : '',
    );
  }
}

// ----------------------------------------------------
// CART_ITEM Model (for items within the basket/cart)
// ----------------------------------------------------
class CartItem {
  final Product product;
  int quantity;
  final String itemId; // Represents the unique ID of the item in the basket

  CartItem(
      {required this.product, required this.quantity, required this.itemId});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    // This assumes the API response for /api/v1/basket/me's 'items' array
    // contains an object like: { "id": "basketItemId", "quantity": N, "product": { ...product_details... } }
    return CartItem(
      product: Product.fromJson(
          json['product'] ?? {}), // Access nested 'product' object
      quantity: (json['quantity'] ?? 1).toInt(), // Access 'quantity'
      itemId: json['id'] ?? '', // Access 'id' for the basket item itself
    );
  }
}

// ----------------------------------------------------
// API Service
// ----------------------------------------------------
class ApiService {
  static const String baseUrl = "https://greensphere-api.runasp.net";
  static const String apiKey =
      "5zOBJKQJFQakblcfbrq4GCqStcxxLX6LSQT8j6V6UcavIlTk6pixNw";

  Map<String, String> get _headers => {
        "x-api-key": apiKey, // Assuming "x-api-key" as confirmed by you
        'Content-Type': 'application/json',
      };

  // Fetch Products (Main Product List)
  // endpoint parameter allows flexibility (e.g., /api/Product or /api/v1/products)
  Future<List<Product>> fetchProducts(
      {String? productName, String endpoint = '/api/v1/products'}) async {
    // Default to /api/v1/products based on image
    final Map<String, String> queryParams = {};
    if (productName != null && productName.isNotEmpty) {
      queryParams['productName'] = productName;
    }

    final uri =
        Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['isSuccess']) {
        final List<dynamic> productJson = responseBody['value'];
        return productJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(responseBody['message'] ?? 'Failed to load products');
      }
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  // Fetch Categories
  Future<List<String>> fetchCategories() async {
    try {
      // Assuming categories can be derived from existing product data API.
      // If there's a dedicated /api/Category endpoint, you'd call that.
      final List<Product> products = await fetchProducts(
          endpoint:
              '/api/v1/products'); // Use the correct product endpoint for categories
      final Set<String> categories = products.map((p) => p.category).toSet();
      return categories.toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  // Fetch Cart Item Count
  Future<int> fetchCartItemCount() async {
    final uri = Uri.parse('$baseUrl/api/v1/basket/me/items/count'); //
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['isSuccess']) {
        return (responseBody['value'] ?? 0).toInt();
      } else {
        throw Exception(responseBody['message'] ?? 'Failed to load cart count');
      }
    } else {
      throw Exception('Failed to load cart count: ${response.statusCode}');
    }
  }

  // Fetch all items in the Basket/Cart
  Future<List<CartItem>> fetchBasketItems() async {
    final uri = Uri.parse('$baseUrl/api/v1/basket/me'); //
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['isSuccess']) {
        // Access the 'items' array within the 'value' object
        final List<dynamic> basketItemsJson =
            responseBody['value']['items'] ?? [];
        return basketItemsJson.map((json) => CartItem.fromJson(json)).toList();
      } else {
        throw Exception(
            responseBody['message'] ?? 'Failed to load basket items');
      }
    } else {
      throw Exception('Failed to load basket items: ${response.statusCode}');
    }
  }

  // ----------------------------------------------------
  // BASKET/CART API Operations (POST, PUT, DELETE) - NOW ACTIVE
  // ----------------------------------------------------

  // Add an item to the basket (POST /api/v1/basket/me/items)
  // Assumes backend expects { "productId": "...", "quantity": ... } in the body
  Future<void> addProductToBasket(String productId, int quantity) async {
    final uri = Uri.parse('$baseUrl/api/v1/basket/me/items');
    final response = await http.post(
      uri,
      headers: _headers,
      body: json.encode({
        'productId': productId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      // 200 OK or 201 Created
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw Exception(responseBody['message'] ??
          'Failed to add item to basket: ${response.statusCode}');
    }
    // No return value needed for success
  }

  // Update item quantity in the basket (PUT /api/v1/basket/me/items/{id}/{quantity})
  // 'itemId' here refers to the unique ID of the item *within the basket*, not the product ID.
  // This 'itemId' comes from the CartItem.itemId when you fetch basket items.
  Future<void> updateBasketItemQuantity(String itemId, int quantity) async {
    final uri = Uri.parse('$baseUrl/api/v1/basket/me/items/$itemId/$quantity');
    final response = await http.put(
      uri,
      headers: _headers,
    );

    if (response.statusCode != 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw Exception(responseBody['message'] ??
          'Failed to update item quantity: ${response.statusCode}');
    }
  }

  // Remove an item from the basket (DELETE /api/v1/basket/me/items)
  // This assumes the backend expects { "productId": "..." } in the body to remove.
  // Based on the endpoint `/api/v1/basket/me/items` (plural), it might remove ALL instances of a given productId.
  // If your backend expects 'itemId' (the basket item ID) in the path, it would be:
  // DELETE /api/v1/basket/me/items/{itemId}
  // Please confirm with your backend what it expects for DELETE.
  Future<void> removeProductFromBasket(String productId) async {
    final uri = Uri.parse('$baseUrl/api/v1/basket/me/items');
    final response = await http.delete(
      uri,
      headers: _headers,
      body: json.encode({
        'productId':
            productId, // Assuming backend expects productId in body to remove
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      // 200 OK or 204 No Content
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw Exception(responseBody['message'] ??
          'Failed to remove item from basket: ${response.statusCode}');
    }
  }

  // Clear the entire basket (DELETE /api/v1/basket/me/items/clear)
  Future<void> clearBasket() async {
    final uri = Uri.parse('$baseUrl/api/v1/basket/me/items/clear');
    final response = await http.delete(uri, headers: _headers);

    if (response.statusCode != 200 && response.statusCode != 204) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw Exception(responseBody['message'] ??
          'Failed to clear basket: ${response.statusCode}');
    }
  }
}

// // lib/features/dashboard/modelus/Component/model/app_models_and_api_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// // ----------------------------------------------------
// // PRODUCT Model
// // ----------------------------------------------------
// class Product {
//   final String name;
//   final String description;
//   final String imageUrl;
//   final double price;
//   final double? oldPrice;
//   final int rate;
//   final String category;
//   bool isInCart; // This will now reflect server state
//   final String id; // Add product ID from API

//   Product({
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

//   factory Product.fromJson(Map<String, dynamic> json) {
//     double? oldPriceValue;
//     // Assuming 'discountPercentage' is the key to determine if there was an old price
//     if ((json['discountPercentage'] ?? 0) > 0) {
//       oldPriceValue = json['price']?.toDouble(); // The 'price' before discount
//     }

//     return Product(
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

// // ----------------------------------------------------
// // CART_ITEM Model (for items within the basket/cart)
// // ----------------------------------------------------
// class CartItem {
//   final Product product;
//   int quantity;
//   final String itemId; // Represents the unique ID of the item in the basket

//   CartItem(
//       {required this.product, required this.quantity, required this.itemId});

//   factory CartItem.fromJson(Map<String, dynamic> json) {
//     // ADJUSTED based on your GET /api/v1/basket/me response:
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
//       product:
//           Product.fromJson(json['product'] ?? {}), // Access nested 'product'
//       quantity: (json['quantity'] ?? 1).toInt(), // Access 'quantity'
//       itemId: json['id'] ?? '', // Access 'id' for the basket item itself
//     );
//   }
// }

// // ----------------------------------------------------
// // API Service
// // ----------------------------------------------------
// class ApiService {
//   static const String baseUrl = "https://greensphere-api.runasp.net";
//   static const String apiKey =
//       "5zOBJKQJFQakblcfbrq4GCqStcxxLX6LSQT8j6V6UcavIlTk6pixNw";

//   Map<String, String> get _headers => {
//         "x-api-key": apiKey,
//         'Content-Type': 'application/json',
//       };

//   Future<List<Product>> fetchProducts(
//       {String? productName, String endpoint = '/api/v1/products'}) async {
//     final Map<String, String> queryParams = {};
//     if (productName != null && productName.isNotEmpty) {
//       queryParams['productName'] = productName;
//     }

//     final uri =
//         Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);

//     final response = await http.get(uri, headers: {
//       "x-api-key": apiKey,
//       'Content-Type': 'application/json',
//     });

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseBody = json.decode(response.body);
//       if (responseBody['isSuccess']) {
//         final List<dynamic> productJson = responseBody['value'];
//         return productJson.map((json) => Product.fromJson(json)).toList();
//       } else {
//         throw Exception(responseBody['message'] ?? 'Failed to load products');
//       }
//     } else {
//       throw Exception('Failed to load products: ${response.statusCode}');
//     }
//   }

//   // Fetch Categories
//   Future<List<String>> fetchCategories() async {
//     try {
//       // Assuming categories can be derived from existing product data API.
//       // If there's a dedicated /api/Category endpoint, you'd call that.
//       final List<Product> products = await fetchProducts();
//       final Set<String> categories = products.map((p) => p.category).toSet();
//       return categories.toList();
//     } catch (e) {
//       throw Exception('Failed to load categories: $e');
//     }
//   }

//   // Fetch Cart Item Count
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

//   // Fetch all items in the Basket/Cart
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

//   // NOTE: Functions for POST, PUT, DELETE basket items are NOT included here,
//   // as per your current requirement to only implement GET.
//   // When you decide to implement add/remove/update, you will add them here.
// }
// // // lib/features/dashboard/modelus/Component/model/app_models_and_api_service.dart
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;

// // // ----------------------------------------------------
// // // PRODUCT Model
// // // ----------------------------------------------------
// // class Product {
// //   final String name;
// //   final String description;
// //   final String imageUrl;
// //   final double price;
// //   final double? oldPrice;
// //   final int rate;
// //   final String category;
// //   bool isInCart; // This will now reflect server state
// //   final String id; // Add product ID from API

// //   Product({
// //     required this.name,
// //     required this.description,
// //     required this.imageUrl,
// //     required this.price,
// //     this.oldPrice,
// //     required this.rate,
// //     required this.category,
// //     this.isInCart = false,
// //     required this.id, // Make it required
// //   });

// //   factory Product.fromJson(Map<String, dynamic> json) {
// //     double? oldPriceValue;
// //     // Assuming 'discountPercentage' is the key to determine if there was an old price
// //     if ((json['discountPercentage'] ?? 0) > 0) {
// //       oldPriceValue = json['price']?.toDouble(); // The 'price' before discount
// //     }

// //     return Product(
// //       id: json['id'] ?? '', // Extract product ID
// //       name: json['name'] ?? '',
// //       description: json['description'] ?? '',
// //       imageUrl: json['imageUrl'] ?? '',
// //       price: (json['priceAfterDiscount'] ?? 0).toDouble(), // Use priceAfterDiscount for current price
// //       oldPrice: oldPriceValue, // The original price if discounted
// //       rate: (json['rate'] ?? 0).toInt(),
// //       category: json['category'] != null ? json['category']['name'] ?? '' : '',
// //     );
// //   }
// // }

// // // ----------------------------------------------------
// // // CART_ITEM Model (for items within the basket/cart)
// // // ----------------------------------------------------
// // class CartItem {
// //   final Product product;
// //   int quantity;
// //   final String itemId; // Represents the unique ID of the item in the basket

// //   CartItem(
// //       {required this.product, required this.quantity, required this.itemId});

// //   factory CartItem.fromJson(Map<String, dynamic> json) {
// //     // ADJUSTED based on your GET /api/v1/basket/me response:
// //     // Assuming each item in the "items" array looks like:
// //     // {
// //     //   "id": "basketItemId_unique_to_this_basket_entry",
// //     //   "quantity": 1,
// //     //   "product": {  // Actual product details are nested here
// //     //     "id": "productId",
// //     //     "name": "...",
// //     //     "imageUrl": "...",
// //     //     "price": ...,
// //     //     // ... other product fields
// //     //   }
// //     // }
// //     return CartItem(
// //       product: Product.fromJson(json['product'] ?? {}), // Access nested 'product'
// //       quantity: (json['quantity'] ?? 1).toInt(), // Access 'quantity'
// //       itemId: json['id'] ?? '', // Access 'id' for the basket item itself
// //     );
// //   }
// // }

// // // ----------------------------------------------------
// // // API Service
// // // ----------------------------------------------------
// // class ApiService {
// //   static const String baseUrl = "https://greensphere-api.runasp.net";
// //   static const String apiKey = "5zOBJKQJFQakblcfbrq4GCqStcxxLX6LSQT8j6V6UcavIlTk6pixNw";

// //   Map<String, String> get _headers => {
// //         "x-api-key": apiKey, // Assuming "x-api-key" as confirmed by you
// //         'Content-Type': 'application/json',
// //       };

// //   // Fetch Products (Main Product List)
// //   // endpoint parameter allows flexibility (e.g., /api/Product or /api/v1/products)
// //   Future<List<Product>> fetchProducts({String? productName, String endpoint = '/api/Product'}) async {
// //     final Map<String, String> queryParams = {};
// //     if (productName != null && productName.isNotEmpty) {
// //       queryParams['productName'] = productName;
// //     }

// //     final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);

// //     final response = await http.get(
// //       uri,
// //       headers: _headers,
// //     );

// //     if (response.statusCode == 200) {
// //       final Map<String, dynamic> responseBody = json.decode(response.body);
// //       if (responseBody['isSuccess']) {
// //         final List<dynamic> productJson = responseBody['value'];
// //         return productJson.map((json) => Product.fromJson(json)).toList();
// //       } else {
// //         throw Exception(responseBody['message'] ?? 'Failed to load products');
// //       }
// //     } else {
// //       throw Exception('Failed to load products: ${response.statusCode}');
// //     }
// //   }

// //   // Fetch Categories
// //   Future<List<String>> fetchCategories() async {
// //     try {
// //       // Assuming categories can be derived from existing product data API.
// //       // If there's a dedicated /api/Category endpoint, you'd call that.
// //       final List<Product> products = await fetchProducts();
// //       final Set<String> categories = products.map((p) => p.category).toSet();
// //       return categories.toList();
// //     } catch (e) {
// //       throw Exception('Failed to load categories: $e');
// //     }
// //   }

// //   // Fetch Cart Item Count
// //   Future<int> fetchCartItemCount() async {
// //     final uri = Uri.parse('$baseUrl/api/v1/basket/me/items/count');
// //     final response = await http.get(uri, headers: _headers);

// //     if (response.statusCode == 200) {
// //       final Map<String, dynamic> responseBody = json.decode(response.body);
// //       if (responseBody['isSuccess']) {
// //         return (responseBody['value'] ?? 0).toInt();
// //       } else {
// //         throw Exception(responseBody['message'] ?? 'Failed to load cart count');
// //       }
// //     } else {
// //       throw Exception('Failed to load cart count: ${response.statusCode}');
// //     }
// //   }

// //   // Fetch all items in the Basket/Cart
// //   Future<List<CartItem>> fetchBasketItems() async {
// //     final uri = Uri.parse('$baseUrl/api/v1/basket/me');
// //     final response = await http.get(uri, headers: _headers);

// //     if (response.statusCode == 200) {
// //       final Map<String, dynamic> responseBody = json.decode(response.body);
// //       if (responseBody['isSuccess']) {
// //         // Access the 'items' array within the 'value' object
// //         final List<dynamic> basketItemsJson = responseBody['value']['items'] ?? [];
// //         return basketItemsJson.map((json) => CartItem.fromJson(json)).toList();
// //       } else {
// //         throw Exception(responseBody['message'] ?? 'Failed to load basket items');
// //       }
// //     } else {
// //       throw Exception('Failed to load basket items: ${response.statusCode}');
// //     }
// //   }

// //   // NOTE: Functions for POST, PUT, DELETE basket items are NOT included here,
// //   // as per your current requirement to only implement GET.
// //   // When you decide to implement add/remove/update, you will add them here.
// // }
