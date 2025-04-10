/*import 'dart:convert';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/product_data.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = "https://your-api-url.com/api/v1/products";
  static const String apiKey = "YOUR_API_KEY";

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> productsJson = data["value"];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}
*/