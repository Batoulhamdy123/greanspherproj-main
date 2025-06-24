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
//   bool isFavorite; // لتتبع حالة المفضلة (الآن ستكون محلية)
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
//     this.isFavorite = false, // تعيين قيمة افتراضية
//     required this.id, // Make it required
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     double? oldPriceValue;
//     if ((json['discountPercentage'] ?? 0) > 0) {
//       oldPriceValue = json['price']?.toDouble();
//     }

//     return Product(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       description: json['description'] ?? '',
//       imageUrl: json['imageUrl'] ?? '',
//       price: (json['priceAfterDiscount'] ?? 0).toDouble(),
//       oldPrice: oldPriceValue,
//       rate: (json['rate'] ?? 0).toInt(),
//       category: json['category'] != null ? json['category']['name'] ?? '' : '',
//       isFavorite: json['isFavorite'] ?? false, // إذا كان الـ API يرجعها
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
//     return CartItem(
//       product: Product.fromJson(
//           json['product'] ?? {}), // Access nested 'product' object
//       quantity: (json['quantity'] ?? 1).toInt(), // Access 'quantity'
//       itemId: json['id'] ?? '', // Access 'id' for the basket item itself
//     );
//   }
// }

// // ----------------------------------------------------
// // FAVOURITE_ITEM Model (هذا الكلاس لم نعد نستخدمه من API المفضلة الآن، لكنه موجود كـ Model)
// // ----------------------------------------------------
// class FavouriteItem {
//   final String id;
//   final String productId;
//   final String name;
//   final String imageUrl;
//   final double price;
//   final String? customerFavouriteId;
//   final DateTime addedAt;

//   FavouriteItem({
//     required this.id,
//     required this.productId,
//     required this.name,
//     required this.imageUrl,
//     required this.price,
//     this.customerFavouriteId,
//     required this.addedAt,
//   });

//   factory FavouriteItem.fromJson(Map<String, dynamic> json) {
//     return FavouriteItem(
//       id: json['id'] ?? '',
//       productId: json['productId'] ?? '',
//       name: json['name'] ?? '',
//       imageUrl: json['imageUrl'] ?? '',
//       price: (json['price'] ?? 0.0).toDouble(),
//       customerFavouriteId: json['customerFavouriteId'],
//       addedAt: DateTime.tryParse(json['addedAt'] ?? '') ?? DateTime.now(),
//     );
//   }
// }

// // ----------------------------------------------------
// // API Service
// // ----------------------------------------------------
// class ApiService {
//   static const String baseUrl = "https://greensphere-api.runasp.net";
//   static const String fixedApiKey =
//       "5zOBJKQJFQakblcfbrq4GCStcxxLX6LSQT8j6V6UcavIlTk6pixNw"; // API Key الثابت للتطبيق

//   // تم إزالة متغير الـ user token بالكامل
//   // static String currentUserAuthToken = "PUT_YOUR_DAILY_TOKEN_HERE"; // لن نستخدمه

//   // getter للحصول على الـ headers التي تحتوي على الـ API Key الثابت فقط
//   Future<Map<String, String>> get _headers async {
//     final Map<String, String> headers = {
//       "x-api-key": fixedApiKey, // الـ API Key الثابت فقط
//       'Content-Type': 'application/json',
//     };
//     // تم حذف جزء الـ Authorization Header الخاص بالـ Token المتغير بالكامل
//     return headers;
//   }

//   // Fetch Products (Main Product List)
//   Future<List<Product>> fetchProducts(
//       {String? productName, String endpoint = '/api/v1/products'}) async {
//     final Map<String, String> queryParams = {};
//     if (productName != null && productName.isNotEmpty) {
//       queryParams['productName'] = productName;
//     }

//     final uri =
//         Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);

//     final response = await http.get(
//       uri,
//       headers: await _headers,
//     );

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
//       final List<Product> products =
//           await fetchProducts(endpoint: '/api/v1/products');
//       final Set<String> categories = products.map((p) => p.category).toSet();
//       return categories.toList();
//     } catch (e) {
//       throw Exception('Failed to load categories: $e');
//     }
//   }

//   // Fetch Cart Item Count
//   Future<int> fetchCartItemCount() async {
//     final uri = Uri.parse('$baseUrl/api/v1/basket/me/items/count');
//     final response = await http.get(uri, headers: await _headers);

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
//     final response = await http.get(uri, headers: await _headers);

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseBody = json.decode(response.body);
//       if (responseBody['isSuccess']) {
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

//   // Add an item to the basket
//   Future<void> addProductToBasket(String productId, int quantity) async {
//     final uri = Uri.parse('$baseUrl/api/v1/basket/me/items');
//     final response = await http.post(
//       uri,
//       headers: await _headers,
//       body: json.encode({
//         'productId': productId,
//         'quantity': quantity,
//       }),
//     );

//     if (response.statusCode != 200 && response.statusCode != 201) {
//       final Map<String, dynamic> responseBody = json.decode(response.body);
//       throw Exception(responseBody['message'] ??
//           'Failed to add item to basket: ${response.statusCode}');
//     }
//   }

//   // Update item quantity in the basket
//   Future<void> updateBasketItemQuantity(String itemId, int quantity) async {
//     final uri = Uri.parse('$baseUrl/api/v1/basket/me/items/$itemId/$quantity');
//     final response = await http.put(
//       uri,
//       headers: await _headers,
//     );

//     if (response.statusCode != 200) {
//       final Map<String, dynamic> responseBody = json.decode(response.body);
//       throw Exception(responseBody['message'] ??
//           'Failed to update item quantity: ${response.statusCode}');
//     }
//   }

//   // Remove an item from the basket
//   Future<void> removeProductFromBasket(String productId) async {
//     final uri = Uri.parse('$baseUrl/api/v1/basket/me/items');
//     final response = await http.delete(
//       uri,
//       headers: await _headers,
//       body: json.encode({
//         'productId': productId,
//       }),
//     );

//     if (response.statusCode != 200 && response.statusCode != 204) {
//       final Map<String, dynamic> responseBody = json.decode(response.body);
//       throw Exception(responseBody['message'] ??
//           'Failed to remove item from basket: ${response.statusCode}');
//     }
//   }

//   // Clear the entire basket
//   Future<void> clearBasket() async {
//     final uri = Uri.parse('$baseUrl/api/v1/basket/me/items/clear');
//     final response = await http.delete(uri, headers: await _headers);

//     if (response.statusCode != 200 && response.statusCode != 204) {
//       final Map<String, dynamic> responseBody = json.decode(response.body);
//       throw Exception(responseBody['message'] ??
//           'Failed to clear basket: ${response.statusCode}');
//     }
//   }

// ----------------------------------------------------
// FAVOURITE API Operations (تم حذفها)
// ----------------------------------------------------
// Future<List<FavouriteItem>> fetchFavouriteItems() async { ... }
// Future<void> addProductToFavourite(String productId) asyn
//c { ... }
// Future<void> removeProductFromFavourite(String productId) async { ... }
// Future<void> clearFavourite() async { ... }
// Future<void> deleteAllFavourite() async { ... }

// lib/features/dashboard/modelus/Component/model/app_models_and_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isInCart;
  bool isFavorite; // This will now reflect server state
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
    this.isFavorite = false,
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
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}

class CartItem {
  final String itemId; // ID العنصر في السلة (وليس ID المنتج)
  final String productId; // ID المنتج
  int quantity;
  Product? productDetails; // جديد: لتخزين تفاصيل المنتج بعد جلبها بشكل منفصل

  CartItem({
    required this.itemId,
    required this.productId,
    required this.quantity,
    this.productDetails,
  });

  // FromJson لكائن الـ item الواحد داخل "items" array من GET /api/v1/basket/me
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      itemId: json['id'] ?? '', // هذا هو الـ ID لمدخل السلة
      productId: json['productId'] ?? '', // هذا هو الـ ID الخاص بالمنتج
      quantity: (json['quantity'] ?? 1).toInt(), // الكمية
      // productDetails سيكون null مبدئياً وسيتم ملؤه لاحقاً
    );
  }
}

class PointsSummary {
  final int totalPoints;
  final int availablePoints;
  final int spentPoints;
  final int expiringPoints;
  final DateTime? lastEarnedDate;
  final DateTime? nextExpiryDate;

  const PointsSummary({
    this.lastEarnedDate,
    required this.totalPoints,
    required this.availablePoints,
    required this.spentPoints,
    required this.expiringPoints,
    this.nextExpiryDate,
  });

  factory PointsSummary.fromJson(Map<String, dynamic> json) {
    return PointsSummary(
      totalPoints: json['totalPoints'] ?? 0,
      availablePoints: json['availablePoints'] ?? 0,
      spentPoints: json['spentPoints'] ?? 0,
      expiringPoints: json['expiringPoints'] ?? 0,
      nextExpiryDate: json['nextExpiryDate'] != null
          ? DateTime.tryParse(json['nextExpiryDate'])
          : null,
      lastEarnedDate: json['lastEarnedDate'] != null
          ? DateTime.tryParse(json['lastEarnedDate'])
          : null,
    );
  }
}

class PointHistoryItem {
  final String id;
  final int points;
  final bool isSpent;
  final bool isExpired;
  final DateTime earnedDate;
  final DateTime expirationDate;
  final String? description;
  final String activityType;

  const PointHistoryItem({
    required this.id,
    required this.points,
    required this.isSpent,
    required this.isExpired,
    required this.earnedDate,
    required this.expirationDate,
    this.description,
    required this.activityType,
  });

  factory PointHistoryItem.fromJson(Map<String, dynamic> json) {
    return PointHistoryItem(
      id: json['id'] ?? '',
      points: json['points'] ?? 0,
      isSpent: json['isSpent'] ?? false,
      isExpired: json['isExpired'] ?? false,
      earnedDate: DateTime.tryParse(json['earnedDate'] ?? '') ?? DateTime.now(),
      expirationDate:
          DateTime.tryParse(json['expirationDate'] ?? '') ?? DateTime.now(),
      description: json['description'],
      activityType: json['activityType'] ?? '',
    );
  }
}

// في ملف app_api_service.dart، بعد RewardProduct
// ----------------------------------------------------
// SHORTS (Videos) Models
// ----------------------------------------------------
class ShortCategory {
  final String id;
  final String name;
  final String description;

  const ShortCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  factory ShortCategory.fromJson(Map<String, dynamic> json) {
    return ShortCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class ShortItem {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String? thumbnailUrl; // قد تكون null
  final bool isFeatured;
  final DateTime createdAt;
  final String category; // اسم الـ category
  final String creator;

  const ShortItem({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.isFeatured,
    required this.createdAt,
    required this.category,
    required this.creator,
  });

  factory ShortItem.fromJson(Map<String, dynamic> json) {
    return ShortItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'],
      isFeatured: json['isFeatured'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      category: json['category'] ?? '', // اسم الكاتيجوري
      creator: json['creator'] ?? '',
    );
  }
}

class RewardProduct {
  final String id;
  final String name;
  final String description;
  final int pointsCost;
  final String imageUrl;
  final bool isActive;
  final int stockQuantity;

  const RewardProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.pointsCost,
    required this.imageUrl,
    required this.isActive,
    required this.stockQuantity,
  });

  factory RewardProduct.fromJson(Map<String, dynamic> json) {
    return RewardProduct(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      pointsCost: json['pointsCost'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      isActive: json['isActive'] ?? false,
      stockQuantity: json['stockQuantity'] ?? 0,
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
  static String? _currentUserName;
  static String? _userAuthToken; // متغير لحفظ الـ user token
  static DateTime? _tokenExpiryDate; // تاريخ انتهاء صلاحية الـ Token

  // دالة لجلب الـ user token من shared_preferences
  static Future<String?> getUserAuthToken() async {
    if (_userAuthToken != null &&
        _tokenExpiryDate != null &&
        DateTime.now().isBefore(_tokenExpiryDate!)) {
      return _userAuthToken; // لو الـ Token موجود وصالح، استخدمه
    }
    final prefs = await SharedPreferences.getInstance();
    _userAuthToken = prefs.getString('user_auth_token'); // مفتاح حفظ الـ Token
    String? expiryString = prefs.getString('user_token_expiry');
    _tokenExpiryDate =
        expiryString != null ? DateTime.tryParse(expiryString) : null;

    if (_userAuthToken != null &&
        _tokenExpiryDate != null &&
        DateTime.now().isBefore(_tokenExpiryDate!)) {
      return _userAuthToken; // لو تم جلبه من shared_preferences وصالح
    } else {
      // لو الـ token غير صالح أو غير موجود، امسحه
      await clearUserAuthToken();
      return null;
    }
  }

  static Future<String?> getCurrentUserName() async {
    if (_currentUserName != null) return _currentUserName;
    final prefs = await SharedPreferences.getInstance();

    _currentUserName = prefs.getString('user_name');
    return _currentUserName;
  }

  static Future<void> saveUserAuthToken(
      String token, DateTime expiryDate, String userName) async {
    // <--- أضف userName هنا
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_auth_token', token);
    await prefs.setString('user_token_expiry', expiryDate.toIso8601String());
    await prefs.setString(
        'user_name', userName); // <--- سطر جديد لحفظ اسم المستخدم
    _userAuthToken = token;
    _tokenExpiryDate = expiryDate;
    _currentUserName = userName; // <--- تحديث المتغير المحلي لاسم المستخدم
  }
// ...

  // دالة لحذف الـ user token من shared_preferences
  static Future<void> clearUserAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_auth_token');
    await prefs.remove('user_token_expiry');
    _userAuthToken = null;
    _tokenExpiryDate = null;
  }

  Future<Map<String, String>> get _headers async {
    final token = await getUserAuthToken();
    final Map<String, String> headers = {
      "x-api-key": apiKey,
      'Content-Type': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Fetch a single Product by ID
  Future<Product?> fetchProductById(String id) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/products/$id');
      print('API Request: GET Single Product $uri');
      print('Request Headers: ${await _headers}');
      final response = await http.get(uri, headers: await _headers);

      print('API Response Status (Single Product): ${response.statusCode}');
      print('API Response Body (Single Product): ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['isSuccess']) {
          return Product.fromJson(responseBody['value']);
        } else {
          print('Failed to load product $id: ${responseBody['message']}');
          return null;
        }
      } else {
        print('Failed to load product $id: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching product $id: $e');
      return null;
    }
  }

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
      headers: await _headers,
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

  Future<int> fetchCartItemCount() async {
    final uri = Uri.parse('$baseUrl/api/v1/basket/me/items/count');
    print('API Request: GET $uri');
    print('Request Headers: ${await _headers}');
    final response = await http.get(uri, headers: await _headers);

    print('API Response Status (Cart Count): ${response.statusCode}');
    print('API Response Body (Cart Count): ${response.body}');

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

  Future<List<CartItem>> fetchBasketItems() async {
    final uri = Uri.parse('$baseUrl/api/v1/basket/me');
    print('API Request: GET $uri');
    print('Request Headers: ${await _headers}');
    final response = await http.get(uri, headers: await _headers);

    print('API Response Status (Basket): ${response.statusCode}');
    print('API Response Body (Basket): ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['isSuccess']) {
        final List<dynamic> basketItemsJson =
            responseBody['value']['items'] ?? [];
        List<CartItem> cartItems =
            basketItemsJson.map((json) => CartItem.fromJson(json)).toList();

        // الآن بعد جلب الـ CartItem (التي تحتوي على productId فقط)، نجلب تفاصيل المنتج لكل منها
        List<String> productIdsInCart =
            cartItems.map((item) => item.productId).toList();
        List<Product?> productsDetails = await Future.wait(
            productIdsInCart.map((id) => fetchProductById(id)));

        // نربط تفاصيل المنتج بالـ CartItem الصحيح
        for (var i = 0; i < cartItems.length; i++) {
          cartItems[i].productDetails = productsDetails[i];
        }
        return cartItems;
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

  // Add an item to the basket
  Future<void> addProductToBasket(String productId, int quantity) async {
    final uri = Uri.parse('$baseUrl/api/v1/basket/me/items');
    print(
        'API Request: POST $uri, Body: {"productId": "$productId", "quantity": $quantity}');
    print('Request Headers: ${await _headers}');

    final response = await http.post(
      uri,
      headers: await _headers,
      body: json.encode({
        'productId': productId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw Exception(responseBody['message'] ??
          'Failed to add item to basket: ${response.statusCode}');
    }
  }

  // Update item quantity in the basket (PUT /api/v1/basket/me/items/{id}/{quantity})
  // 'itemId' here refers to the unique ID of the item *within the basket*, not the product ID.
  // This 'itemId' comes from the CartItem.itemId when you fetch basket items.
  Future<void> updateBasketItemQuantity(String itemId, int quantity) async {
    final uri = Uri.parse('$baseUrl/api/v1/basket/me/items/$itemId/$quantity');
    print('API Request: PUT $uri');
    print('Request Headers: ${await _headers}');
    final response = await http.put(
      uri,
      headers: await _headers,
    );

    if (response.statusCode != 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw Exception(responseBody['message'] ??
          'Failed to update item quantity: ${response.statusCode}');
    }
  }

  // في ملف app_api_service.dart
// ...
// Remove an item from the basket (DELETE /api/v1/basket/me/items/{basketItemId})
// Based on common REST patterns, deleting a specific item is often done via ID in URL
  Future<void> removeProductFromBasket(String basketItemId) async {
    // <--- غيّر parameter لـ basketItemId
    final uri = Uri.parse(
        '$baseUrl/api/v1/basket/me/items/$basketItemId'); // <--- غيّر الـ URL لإضافة الـ ID
    print('API Request: DELETE $uri'); // لا يوجد body في هذه الحالة
    print('Request Headers: ${await _headers}');
    final response = await http.delete(
      uri,
      headers: await _headers,
      // no body needed here as ID is in URL
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw Exception(responseBody['message'] ??
          'Failed to remove item from basket: ${response.statusCode}');
    }
  }
// ...

  Future<void> clearBasket() async {
    final uri = Uri.parse('$baseUrl/api/v1/basket/me/items/clear');
    print('API Request: DELETE $uri');
    print('Request Headers: ${await _headers}');
    final response = await http.delete(uri, headers: await _headers);

    if (response.statusCode != 200 && response.statusCode != 204) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw Exception(responseBody['message'] ??
          'Failed to clear basket: ${response.statusCode}');
    }
  }

  Future<PointsSummary> fetchPointsSummary() async {
    final uri = Uri.parse('$baseUrl/api/v1/points/summary');
    print('API Request: GET $uri');
    print('Request Headers: $_headers');

    final response = await http.get(uri, headers: await _headers);

    print('API Response Status (Points Summary): ${response.statusCode}');
    print('API Response Body (Points Summary): ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['isSuccess']) {
        return PointsSummary.fromJson(responseBody['value'] ?? {});
      } else {
        throw Exception(
            responseBody['message'] ?? 'Failed to load points summary');
      }
    } else {
      throw Exception('Failed to load points summary: ${response.statusCode}');
    }
  }

  // Fetch Points History (GET /api/v1/points/history)
  Future<List<PointHistoryItem>> fetchPointsHistory() async {
    final uri = Uri.parse('$baseUrl/api/v1/points/history');
    print('API Request: GET $uri');
    print('Request Headers: $_headers');

    final response = await http.get(uri, headers: await _headers);

    print('API Response Status (Points History): ${response.statusCode}');
    print('API Response Body (Points History): ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['isSuccess']) {
        final List<dynamic> historyJson = responseBody['value'] ?? [];
        return historyJson
            .map((json) => PointHistoryItem.fromJson(json))
            .toList();
      } else {
        throw Exception(
            responseBody['message'] ?? 'Failed to load points history');
      }
    } else {
      throw Exception('Failed to load points history: ${response.statusCode}');
    }
  }

  // Fetch Available Points (GET /api/v1/points/available)
  Future<int> fetchAvailablePoints() async {
    final uri = Uri.parse('$baseUrl/api/v1/points/available');
    print('API Request: GET $uri');
    print('Request Headers: $_headers');

    final response = await http.get(uri, headers: await _headers);

    print('API Response Status (Available Points): ${response.statusCode}');
    print('API Response Body (Available Points): ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['isSuccess']) {
        return (responseBody['value'] ?? 0).toInt();
      } else {
        throw Exception(
            responseBody['message'] ?? 'Failed to load available points');
      }
    } else {
      throw Exception(
          'Failed to load available points: ${response.statusCode}');
    }
  }

  // Fetch Rewards Products (GET /api/v1/rewards)
  Future<List<RewardProduct>> fetchRewardsProducts() async {
    final uri = Uri.parse('$baseUrl/api/v1/rewards');
    print('API Request: GET $uri');
    print('Request Headers: ${await _headers}');

    final response = await http.get(uri, headers: await _headers);

    print('API Response Status (Rewards Products): ${response.statusCode}');
    print('API Response Body (Rewards Products): ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['isSuccess']) {
        final List<dynamic> rewardProductsJson = responseBody['value'] ?? [];
        return rewardProductsJson
            .map((json) => RewardProduct.fromJson(json))
            .toList();
      } else {
        throw Exception(
            responseBody['message'] ?? 'Failed to load rewards products');
      }
    } else {
      throw Exception(
          'Failed to load rewards products: ${response.statusCode}');
    }
  }

  static const String _favouriteKey = 'local_favourite_product_ids';

  // دالة لحفظ IDs المنتجات المفضلة
  static Future<void> saveLocalFavouriteIds(List<String> productIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favouriteKey, productIds);
  }

  // دالة لجلب IDs المنتجات المفضلة
  static Future<List<String>> getLocalFavouriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favouriteKey) ?? [];
  }
  // في ملف app_api_service.dart، داخل class ApiService { ... }

// ----------------------------------------------------
// Local Saved Addresses Functions
// ----------------------------------------------------
  static const String _savedAddressesKey = 'local_saved_addresses';

// دالة لحفظ قائمة العناوين (كنصوص)
  static Future<void> saveLocalAddresses(List<String> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_savedAddressesKey, addresses);
  }

// دالة لجلب قائمة العناوين
  static Future<List<String>> getLocalAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_savedAddressesKey) ?? [];
  }
  // في app_api_service.dart، داخل class ApiService { ... }

// ----------------------------------------------------
// SHORTS (Videos) API Operations
// ----------------------------------------------------

// Fetch All Shorts (Videos)
// /api/v1/shorts
  Future<List<ShortItem>> fetchAllShorts() async {
    final uri = Uri.parse('$baseUrl/api/v1/shorts');
    print('API Request: GET $uri');
    print('Request Headers: ${await _headers}');

    final response = await http.get(uri, headers: await _headers);

    print('API Response Status (All Shorts): ${response.statusCode}');
    print('API Response Body (All Shorts): ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['isSuccess']) {
        final List<dynamic> shortsJson = responseBody['value'] ?? [];
        return shortsJson.map((json) => ShortItem.fromJson(json)).toList();
      } else {
        throw Exception(responseBody['message'] ?? 'Failed to load shorts');
      }
    } else {
      throw Exception('Failed to load shorts: ${response.statusCode}');
    }
  }

// Fetch Shorts by Category
// /api/v1/shorts?category={categoryName} (نفترض هذا Endpoint)
// أو قد تحتاج لـ /api/v1/shorts/category/{categoryId} لو الـ Backend يدعم
  Future<List<ShortItem>> fetchShortsByCategory(String categoryName) async {
    final uri = Uri.parse('$baseUrl/api/v1/shorts')
        .replace(queryParameters: {'category': categoryName});
    print('API Request: GET $uri (by category)');
    print('Request Headers: ${await _headers}');

    final response = await http.get(uri, headers: await _headers);

    print('API Response Status (Shorts by Category): ${response.statusCode}');
    print('API Response Body (Shorts by Category): ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['isSuccess']) {
        final List<dynamic> shortsJson = responseBody['value'] ?? [];
        return shortsJson.map((json) => ShortItem.fromJson(json)).toList();
      } else {
        throw Exception(
            responseBody['message'] ?? 'Failed to load shorts by category');
      }
    } else {
      throw Exception(
          'Failed to load shorts by category: ${response.statusCode}');
    }
  }

// Fetch Short Categories (تصنيفات الفيديوهات)
// /api/v1/short-categories
  Future<List<ShortCategory>> fetchShortCategories() async {
    final uri = Uri.parse('$baseUrl/api/v1/short-categories');
    print('API Request: GET $uri');
    print('Request Headers: ${await _headers}');

    final response = await http.get(uri, headers: await _headers);

    print('API Response Status (Short Categories): ${response.statusCode}');
    print('API Response Body (Short Categories): ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['isSuccess']) {
        final List<dynamic> categoriesJson = responseBody['value'] ?? [];
        return categoriesJson
            .map((json) => ShortCategory.fromJson(json))
            .toList();
      } else {
        throw Exception(
            responseBody['message'] ?? 'Failed to load short categories');
      }
    } else {
      throw Exception(
          'Failed to load short categories: ${response.statusCode}');
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
