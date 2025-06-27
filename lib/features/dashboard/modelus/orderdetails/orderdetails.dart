import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Order/view/OrderPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Profile/view/ProfilePage.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  final String orderDate;
  final List<OrderSummaryItem> orderItems;

  const OrderDetailsScreen(
      {Key? key,
      required this.orderId,
      required this.orderDate,
      required this.orderItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            const Text("Order details", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: $orderDate', style: const TextStyle(fontSize: 16)),
            Text('Order ID: $orderId', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Items:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: orderItems.length,
                itemBuilder: (context, index) {
                  final item = orderItems[index];
                  return ListTile(
                    leading: Image.network(item.pictureUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/images/placeholder.png',
                                width: 50, height: 50, fit: BoxFit.cover)),
                    title: Text('${item.productName} x${item.quantity}'),
                    subtitle: Text('EGP ${item.totalPrice.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
