// // lib/features/dashboard/modelus/Component/model/product_data.dart
// // lib/features/dashboard/modelus/Component/model/product_data.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class Product {
//   final String name;
//   final String description;
//   final String imageUrl;
//   final double price;
//   final double? oldPrice;
//   final int rate;
//   final String category;
//   bool isInCart;

//   Product({
//     required this.name,
//     required this.description,
//     required this.imageUrl,
//     required this.price,
//     this.oldPrice,
//     required this.rate,
//     required this.category,
//     this.isInCart = false,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     double? oldPriceValue;
//     if ((json['discountPercentage'] ?? 0) > 0) {
//       oldPriceValue = json['price']?.toDouble();
//     }

//     return Product(
//       name: json['name'] ?? '',
//       description: json['description'] ?? '',
//       imageUrl: json['imageUrl'] ?? '',
//       price: (json['priceAfterDiscount'] ?? 0).toDouble(),
//       oldPrice: oldPriceValue,
//       rate: (json['rate'] ?? 0).toInt(),
//       category: json['category'] != null ? json['category']['name'] ?? '' : '',
//     );
//   }

// }

// class ApiServiceComponent {
//   static const String baseUrl = "https://greensphere-api.runasp.net";
//   static const String apiKey =
//       "5zOBJKQJFQakblcfbrq4GCqStcxxLX6LSQT8j6V6UcavIlTk6pixNw";

//   Future<List<Product>> fetchProducts({String? productName}) async {
//     final Map<String, String> queryParams = {};
//     if (productName != null && productName.isNotEmpty) {
//       queryParams['productName'] = productName;
//     }

//     final uri = Uri.parse('$baseUrl/api/v1/products')
//         .replace(queryParameters: queryParams);

//     final response = await http.get(
//       uri,
//       headers: {
//         "x-api-key": apiKey,
//         'Content-Type': 'application/json',
//       },
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

//   // Corrected Function to fetch product categories by extracting them from product data
//   Future<List<String>> fetchCategories() async {
//     try {
//       // Fetch all products
//       final List<Product> products = await fetchProducts();
//       // Extract unique categories
//       final Set<String> categories = products.map((p) => p.category).toSet();
//       return categories.toList();
//     } catch (e) {
//       throw Exception('Failed to load categories: $e');
//     }
//   }

//   Future<int> fetchCartItemCount() async {
//     final uri = Uri.parse('$baseUrl/api/v1/basket/me/items/count');

//     final response = await http.get(
//       uri,
//       headers: {
//         "x-api-key": apiKey,
//         'Content-Type': 'application/json',
//       },
//     );

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
// }
