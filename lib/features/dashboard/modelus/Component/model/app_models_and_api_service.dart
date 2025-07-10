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
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:uuid/uuid.dart'; // <--- أضف هذا

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

// في ملف app_api_service.dart
class CartItem {
  final String itemId;
  final String productId; // <--- هذا هو الـ productId الحقيقي
  int quantity;
  Product? productDetails;

  CartItem({
    required this.itemId,
    required this.productId, // <--- يجب أن يكون هنا
    required this.quantity,
    this.productDetails,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      itemId: json['id'] ?? '',
      productId:
          (json['productId'] ?? '').toString(), // <--- تأكد من .toString() هنا
      quantity: (json['quantity'] ?? 1).toInt(),
      // ...
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

// في ملف app_api_service.dart، بعد RewardProduct
// ----------------------------------------------------
// ORDER Models
// ----------------------------------------------------
class OrderSummaryItem {
  final String id;
  final String productId;
  final String productName;
  final String pictureUrl; // تأكد من أن الـ API يرجعها بهذا الاسم
  final int quantity;
  final double unitPrice; // سعر الوحدة
  final double totalPrice; // سعر الوحدة * الكمية

  OrderSummaryItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.pictureUrl,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderSummaryItem.fromJson(Map<String, dynamic> json) {
    return OrderSummaryItem(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      pictureUrl: json['pictureUrl'] ?? '', // من الـ Response
      quantity: (json['quantity'] ?? 0).toInt(),
      unitPrice: (json['unitPrice'] ?? 0.0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
    );
  }
}

class OrderItem {
  final String id;
  final double totalOrderPrice; // ID الطلب نفسه (Order ID)
  final String createdBy;
  final String customerEmail;
  final DateTime orderDate;
  final String orderStatus;
  final String paymentStatus;
  final String phoneNumber;
  final double totalAmount;
  final double deliveryFee;
  final String buildingName;
  final String floor;
  final String street;
  final String additionalDirections;
  final String addressLabel;
  final String paymentMethod;
  final String? paymentIntentId;
  final List<OrderSummaryItem> orderItems; // تفاصيل المنتجات في الطلب

  final bool isRated; // هل تم تقييم الطلب (إذا الـ API يرجعها)
  final int rating; // تقييم الطلب (إذا الـ API يرجعها)

  OrderItem({
    required this.totalOrderPrice,
    required this.id,
    required this.createdBy,
    required this.customerEmail,
    required this.orderDate,
    required this.orderStatus,
    required this.paymentStatus,
    required this.phoneNumber,
    required this.totalAmount,
    required this.deliveryFee,
    required this.buildingName,
    required this.floor,
    required this.street,
    required this.additionalDirections,
    required this.addressLabel,
    required this.paymentMethod,
    this.paymentIntentId,
    required this.orderItems,
    this.isRated = false,
    this.rating = 0,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
        id: json['id'] ?? '',
        createdBy: json['createdBy'] ?? '',
        customerEmail: json['customerEmail'] ?? '',
        orderDate: DateTime.tryParse(json['orderDate'] ?? '') ?? DateTime.now(),
        orderStatus: json['orderStatus'] ?? '',
        paymentStatus: json['paymentStatus'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
        deliveryFee: (json['deliveryFee'] ?? 0.0).toDouble(),
        buildingName: json['buildingName'] ?? '',
        floor: json['floor'] ?? '',
        street: json['street'] ?? '',
        additionalDirections: json['additionalDirections'] ?? '',
        addressLabel: json['addressLabel'] ?? '',
        paymentMethod: json['paymentMethod'] ?? '',
        paymentIntentId: json['paymentIntentId'],
        orderItems: (json['orderItems'] as List?)
                ?.map((itemJson) => OrderSummaryItem.fromJson(itemJson))
                .toList() ??
            [],
        isRated: json['isRated'] ?? false, // إذا الـ API يرجعها
        rating: (json['rating'] ?? 0).toInt(),
        totalOrderPrice: (json['totalAmount'] ?? 0.0).toDouble()
        // إذا الـ API يرجعها
        );
  }
}
// في ملف app_api_service.dart

// ... (بعد PointsSummary أو في مكان مناسب للموديلز) ...

// ----------------------------------------------------
// NOTIFICATION / DISEASE ALERT Model
// ----------------------------------------------------
class DiseaseAlertItem {
  final String id;
  final String message;
  final String type; // "Disease", "Healthy", "Update", "Reward"
  final DateTime date;
  final String? details; // تفاصيل إضافية أو اسم المرض
  late final bool isNew; // هل هو إشعار جديد لم يقرأ بعد

  DiseaseAlertItem({
    required this.id,
    required this.message,
    required this.type,
    required this.date,
    this.details,
    this.isNew = true,
  });

  factory DiseaseAlertItem.fromJson(Map<String, dynamic> json) {
    return DiseaseAlertItem(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      details: json['details'],
      isNew: json['isNew'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'type': type,
      'date': date.toIso8601String(),
      'details': details,
      'isNew': isNew,
    };
  }
}

// في ملف app_api_service.dart، بعد CreditTransaction
// ----------------------------------------------------
// USER PROFILE Models
// ----------------------------------------------------
class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? profilePictureUrl;

  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.gender,
    this.dateOfBirth,
    this.profilePictureUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      profilePictureUrl: json['profilePictureUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'profilePictureUrl': profilePictureUrl,
    };
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
  static String? _userAuthToken;
  static DateTime? _tokenExpiryDate;
// في ملف app_api_service.dart، داخل class ApiService { ... }

// ----------------------------------------------------
// USER PROFILE API Operations
// ----------------------------------------------------

// Fetch User Profile (GET /api/v1/users/profile)
  Future<UserProfile> fetchUserProfile() async {
    final uri = Uri.parse('$baseUrl/api/v1/users/profile');
    print('API Request: GET User Profile $uri');
    print('Request Headers: ${await _headers}');

    final response = await http.get(uri, headers: await _headers);

    print('API Response Status (User Profile): ${response.statusCode}');
    print('API Response Body (User Profile): ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['isSuccess']) {
        return UserProfile.fromJson(responseBody['value'] ?? {});
      } else {
        throw Exception(
            responseBody['message'] ?? 'Failed to load user profile');
      }
    } else {
      throw Exception('Failed to load user profile: ${response.statusCode}');
    }
  }

// Edit User Profile (POST /api/v1/users/edit-profile)
  Future<UserProfile> editUserProfile({
    required String firstName,
    required String lastName,
    required String email,
    String? gender,
    DateTime? dateOfBirth,
    String? profilePictureUrl,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/users/edit-profile');
    final Map<String, dynamic> body = {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "gender": gender,
      "dateOfBirth": dateOfBirth?.toIso8601String(),
      "profilePictureUrl": profilePictureUrl,
    };
    // إزالة القيم الـ null من الـ body
    body.removeWhere((key, value) => value == null);

    print('API Request: POST Edit Profile $uri, Body: ${json.encode(body)}');
    print('Request Headers: ${await _headers}');

    final response = await http.post(
      uri,
      headers: await _headers,
      body: json.encode(body),
    );

    print('API Response Status (Edit Profile): ${response.statusCode}');
    print('API Response Body (Edit Profile): ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['isSuccess']) {
        return UserProfile.fromJson(responseBody['value']);
      } else {
        throw Exception(responseBody['message'] ?? 'Failed to edit profile');
      }
    } else {
      throw Exception('Failed to edit profile: ${response.statusCode}');
    }
  }

// Delete User Account (DELETE /api/v1/users/me/delete-account)
  Future<void> deleteUserAccount() async {
    final uri = Uri.parse('$baseUrl/api/v1/users/me/delete-account');
    print('API Request: DELETE User Account $uri');
    print('Request Headers: ${await _headers}');

    final response = await http.delete(uri, headers: await _headers);

    print('API Response Status (Delete Account): ${response.statusCode}');
    print('API Response Body (Delete Account): ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('User account deleted successfully.');
      await clearUserAuthToken(); // مسح التوكن بعد حذف الحساب
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw Exception(responseBody['message'] ??
          'Failed to delete account: ${response.statusCode}');
    }
  }

  static Future<String?> getUserAuthToken() async {
    if (_userAuthToken != null &&
        _tokenExpiryDate != null &&
        DateTime.now().isBefore(_tokenExpiryDate!)) {
      return _userAuthToken;
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
          print(
              'CartItem ${cartItems[i].itemId} linked to Product ID: ${cartItems[i].productId}, Details: ${productsDetails[i]?.name ?? "Not Found"}');
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
// Remove an item from the basket (DELETE /api/v1/basket/me/items)
// هذا هو الـ Endpoint الذي يتوقع productId في الـ Body
// في ملف app_api_service.dart
// ...
  Future<void> removeProductFromBasket(String productId) async {
    final uri = Uri.parse('$baseUrl/api/v1/basket/me/items');
    print('API Request: DELETE $uri, Body: {"productId": "$productId"}');
    print('Request Headers: ${await _headers}');
    final response = await http.delete(
      uri,
      headers: await _headers,
      body: json.encode({
        'productId': productId,
      }),
    );

    // تأكد أن الكود لا يرمي Exception لو الـ Status Code كان 200 أو 204
    if (response.statusCode == 200 || response.statusCode == 204) {
      // النجاح، لا تفعل شيئاً (أو يمكنك طباعة رسالة نجاح)
      print('Item removed successfully from basket on backend.');
    } else {
      // لو الـ Status Code كان أي حاجة تانية غير 200 أو 204، يبقى فيه خطأ
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw Exception(responseBody['message'] ??
          'Failed to remove item from basket: ${response.statusCode}');
    }
  }
// ...
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
  // في ملف app_api_service.dart، داخل class ApiService { ... }

// ----------------------------------------------------
// ORDER API Operations
// ----------------------------------------------------

// Fetch User Orders (GET /api/v1/orders/me)
  Future<List<OrderItem>> fetchUserOrders() async {
    final uri = Uri.parse('$baseUrl/api/v1/orders/me');
    print('API Request: GET User Orders $uri');
    print('Request Headers: ${await _headers}');

    final response = await http.get(uri, headers: await _headers);

    print('API Response Status (User Orders): ${response.statusCode}');
    print('API Response Body (User Orders): ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['isSuccess']) {
        final List<dynamic> ordersJson = responseBody['value'] ?? [];
        return ordersJson.map((json) => OrderItem.fromJson(json)).toList();
      } else {
        throw Exception(
            responseBody['message'] ?? 'Failed to load user orders');
      }
    } else {
      throw Exception('Failed to load user orders: ${response.statusCode}');
    }
  }

// Create Cash Order (POST /api/v1/orders/me/create-cash-order)
  Future<void> createCashOrder({
    required String phoneNumber,
    required double latitude,
    required double longitude,
    required String buildingName,
    required String floor,
    required String street,
    required String additionalDirections,
    required String addressLabel,
    required double totalAmount,
    required double deliveryFee,
    required List<Map<String, dynamic>> orderItems,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/orders/me/create-cash-order');
    final Map<String, dynamic> body = {
      "phoneNumber": phoneNumber,
      "latitude":
          latitude, // يجب أن تحصل على Latitude/Longitude من تحديد الموقع
      "longitude": longitude,
      "buildingName": buildingName,
      "floor": floor,
      "street": street,
      "additionalDirections": additionalDirections,
      "addressLabel": addressLabel,
    };

    print('API Request: POST Cash Order $uri, Body: ${json.encode(body)}');
    print('Request Headers: ${await _headers}');

    final response = await http.post(
      uri,
      headers: await _headers,
      body: json.encode(body),
    );

    print('API Response Status (Create Cash Order): ${response.statusCode}');
    print('API Response Body (Create Cash Order): ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw Exception(responseBody['message'] ??
          'Failed to create cash order: ${response.statusCode}');
    }
  }
// في ملف app_api_service.dart، داخل class ApiService { ... }

// ... (بعد دالة createCashOrder) ...

// Create Online Order (POST /api/v1/orders/me/create-online-order)
  Future<OrderItem> createOnlineOrder({
    required String phoneNumber,
    required double latitude,
    required double longitude,
    required String buildingName,
    required String floor,
    required String street,
    required String additionalDirections,
    required String addressLabel,
    required double totalAmount,
    required double deliveryFee,
    required List<Map<String, dynamic>> orderItems, // تفاصيل المنتجات
    required String cardNumber, // بيانات البطاقة
    required String expiryDate,
    required String cvv,
  }) async {
    final uri = Uri.parse(
        '$baseUrl/api/v1/orders/me/create-online-order'); // Endpoint المتوقع
    final Map<String, dynamic> body = {
      "phoneNumber": phoneNumber,
      "latitude": latitude,
      "longitude": longitude,
      "buildingName": buildingName,
      "floor": floor,
      "street": street,
      "additionalDirections": additionalDirections,
      "addressLabel": addressLabel,
      "totalAmount": totalAmount,
      "deliveryFee": deliveryFee,
      "orderItems": orderItems, // قائمة المنتجات
      "cardNumber": cardNumber, // بيانات البطاقة
      "expiryDate": expiryDate,
      "cvv": cvv,
    };

    print('API Request: POST Online Order $uri, Body: ${json.encode(body)}');
    print('Request Headers: ${await _headers}');

    final response = await http.post(
      uri,
      headers: await _headers,
      body: json.encode(body),
    );

    print('API Response Status (Create Online Order): ${response.statusCode}');
    print('API Response Body (Create Online Order): ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['isSuccess']) {
        return OrderItem.fromJson(
            responseBody['value']); // إرجاع OrderItem كامل
      } else {
        throw Exception(
            responseBody['message'] ?? 'Failed to create online order');
      }
    } else {
      throw Exception('Failed to create online order: ${response.statusCode}');
    }
  }

  // في ملف app_api_service.dart، داخل class ApiService { ... }

// ----------------------------------------------------
// AI Model Prediction API Operations
// ----------------------------------------------------
// هذا الـ Endpoint مختلف عن الـ BaseUrl
  static const String aiModelBaseUrl =
      "https://kh-emad-plant-diseases-v2.hf.space/predict"; // <--- Endpoint الـ AI Model

  // في ملف app_api_service.dart

// تأكد من عدم وجود import 'dart:io';
// ...

  Future<String> uploadPlantImageForPrediction(XFile imageFile) async {
    // <--- تغير الـ parameter إلى XFile
    final uri = Uri.parse(aiModelBaseUrl);

    var request = http.MultipartRequest('POST', uri);

    request.headers['Accept-Language'] = 'en-US';
    request.headers['accept'] = 'application/json; ver=1.0';

    // قراءة الـ bytes من XFile مباشرة
    List<int> imageBytes =
        await imageFile.readAsBytes(); // <--- قراءة الـ bytes من XFile

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      imageBytes,
      filename: imageFile.name, // استخدام filename من XFile
      contentType: MediaType(
          'image', 'jpeg'), // تحديد النوع هنا (يمكنك تغييره حسب نوع الصورة)
    ));

    print('AI Model Request: POST $uri');
    print('AI Model Request Files: ${request.files.first.filename}');

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print('AI Model Response Status: ${response.statusCode}');
    print('AI Model Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('label')) {
        return responseBody['label'];
      } else {
        throw Exception(
            'Prediction label not found in response: ${response.body}');
      }
    } else {
      throw Exception(
          'Failed to get AI prediction: ${response.statusCode}, Body: ${response.body}');
    }
  }
  // في ملف app_api_service.dart، داخل class ApiService { ... }

// ... (بعد Local Favourites Persistence Functions) ...

// ----------------------------------------------------
// Local Disease Alerts / Notifications Persistence Functions
// ----------------------------------------------------
  static const String _diseaseAlertsKey = 'local_disease_alerts';

// دالة لحفظ قائمة إشعارات الأمراض/التحديثات
  static Future<void> saveLocalDiseaseAlerts(
      List<DiseaseAlertItem> alerts) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
        alerts.map((alert) => json.encode(alert.toJson())).toList();
    await prefs.setStringList(_diseaseAlertsKey, jsonList);
  }

// دالة لجلب قائمة إشعارات الأمراض/التحديثات
  static Future<List<DiseaseAlertItem>> getLocalDiseaseAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = prefs.getStringList(_diseaseAlertsKey) ?? [];
    return jsonList
        .map((jsonString) => DiseaseAlertItem.fromJson(json.decode(jsonString)))
        .toList();
  }
  // في ملف app_api_service.dart، داخل class ApiService { ... }

// ... (بعد دالة editUserProfile) ...

// Change User Email (POST /api/v1/users/change-email)
  Future<void> changeUserEmail({
    required String newEmail,
    required String currentPassword,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/users/change-email');
    final Map<String, dynamic> body = {
      "newEmail": newEmail,
      "currentPassword": currentPassword,
    };

    print('API Request: POST Change Email $uri, Body: ${json.encode(body)}');
    print('Request Headers: ${await _headers}');

    final response = await http.post(
      uri,
      headers: await _headers,
      body: json.encode(body),
    );

    print('API Response Status (Change Email): ${response.statusCode}');
    print('API Response Body (Change Email): ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw Exception(responseBody['message'] ??
          'Failed to change email: ${response.statusCode}');
    }
  }

// Verify Change Email (POST /api/v1/users/verify-change-email)
  Future<String> verifyChangeEmail({
    // ترجع الـ newEmail لو نجح
    required String code,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/users/verify-change-email');
    final Map<String, dynamic> body = {
      "code": code,
    };

    print(
        'API Request: POST Verify Change Email $uri, Body: ${json.encode(body)}');
    print('Request Headers: ${await _headers}');

    final response = await http.post(
      uri,
      headers: await _headers,
      body: json.encode(body),
    );

    print('API Response Status (Verify Change Email): ${response.statusCode}');
    print('API Response Body (Verify Change Email): ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['isSuccess']) {
        return responseBody['value']['newEmail'] ??
            'Verification successful'; // ترجع الـ newEmail لو موجود
      } else {
        throw Exception(responseBody['message'] ??
            'Failed to verify email: ${response.statusCode}');
      }
    } else {
      throw Exception('Failed to verify email: ${response.statusCode}');
    }
  }

// Change User Password (POST /api/v1/users/change-password)
  Future<void> changeUserPassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/users/change-password');
    final Map<String, dynamic> body = {
      "currentPassword": currentPassword,
      "newPassword": newPassword,
      "confirmNewPassword": confirmNewPassword,
    };

    print('API Request: POST Change Password $uri, Body: ${json.encode(body)}');
    print('Request Headers: ${await _headers}');

    final response = await http.post(
      uri,
      headers: await _headers,
      body: json.encode(body),
    );

    print('API Response Status (Change Password): ${response.statusCode}');
    print('API Response Body (Change Password): ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw Exception(responseBody['message'] ??
          'Failed to change password: ${response.statusCode}');
    }
  }

// ...
// ...
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
