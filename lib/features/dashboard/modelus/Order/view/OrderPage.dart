// lib/features/dashboard/modelus/Order/view/OrderPage.dart
import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/orderdetails/orderdetails.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart'; // ApiService, OrderItem, OrderSummaryItem

class OrdersScreen extends StatefulWidget {
  // <--- تم تغييرها إلى StatefulWidget
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final ApiService _apiService = ApiService();
  List<OrderItem> _userOrders = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserOrders(); // جلب الطلبات عند بدء تشغيل الشاشة
  }

  Future<void> _fetchUserOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final orders =
          await _apiService.fetchUserOrders(); // <--- استدعاء API جلب الطلبات
      setState(() {
        _userOrders = orders;
      });
    } catch (e) {
      print("Error fetching user orders: $e");
      setState(() {
        _errorMessage = 'Failed to load orders: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Orders",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _userOrders.isEmpty
                  ? const Center(
                      child: Text("No orders found.",
                          style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _userOrders.length,
                      itemBuilder: (context, index) {
                        final order = _userOrders[index];
                        // استخدام بيانات الطلب الحقيقية
                        return _buildOrderItem(
                          context,
                          date:
                              '${order.orderDate.month}/${order.orderDate.day} . ${order.orderDate.hour}:${order.orderDate.minute}pm',
                          orderId: order.id, // استخدام order.id كـ Order ID
                          itemsCount: order.orderItems.length,
                          // نأخذ صورة أول منتج في الطلب كمثال
                          image: order.orderItems.isNotEmpty
                              ? order.orderItems.first.pictureUrl
                              : 'assets/images/placeholder.png',
                          price:
                              "EGP ${order.totalOrderPrice.toStringAsFixed(2)}",
                          isRated: order.isRated,
                          rating: order.rating,
                          orderItems:
                              order.orderItems, // تمرير قائمة المنتجات في الطلب
                        );
                      },
                    ),
    );
  }

  Widget _buildOrderItem(
    BuildContext context, {
    required String date,
    required String orderId,
    required int itemsCount,
    required String image,
    required String price,
    required bool isRated,
    required int rating,
    required List<OrderSummaryItem> orderItems, // إضافة هذا البارامتر
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date, style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // في ملف OrdersScreen.dart، داخل _buildOrderItem
// ...
              Center(
                  child: Row(
                children: [
                  Expanded(
                    // <--- هنا Expanded للـ Order ID
                    child: Text("Order ID: $orderId",
                        style: TextStyle(color: Colors.grey[600])),
                  ),
                  const SizedBox(width: 8), // مسافة بين الـ ID وعدد الـ items
                  Text("$itemsCount items",
                      style: TextStyle(color: Colors.grey[600])),
                ],
              )),
// ...
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      // استخدام Column لعرض الصورة والسعر
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          image, // استخدام Image.network للصورة
                          width: 100, height: 100, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/images/placeholder.png',
                                  width: 100, height: 100, fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 7),
                        Text(price,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to Order Details screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetailsScreen(
                                    orderId: orderId,
                                    orderDate: date,
                                    orderItems:
                                        orderItems), // يمكن إنشاء شاشة تفاصيل الطلب لاحقاً
                              ),
                            );
                          },
                          child: const Text("View details",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                        )
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // TODO: Implement "Order again" logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order again (Dummy)!')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black),
                    ),
                    child: const Text("Order again",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(12)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  isRated ? "You rated $rating/5" : "Rate",
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    size: 16,
                    color: index < rating ? Colors.amber : Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// شاشة وهمية لتفاصيل الطلب (يمكن تطويرها لاحقاً)
