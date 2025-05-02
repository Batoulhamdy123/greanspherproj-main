import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Profile/view/ProfilePage.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Orders",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                        userName: 'batoul',
                      )),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildOrderItem(
            context,
            date: "Mar 4 . 8:09pm",
            orderId: "456009",
            itemsCount: 2,
            image: "assets/images/componentexamle.png",
            price: "EGP 367",
            isRated: true,
            rating: 5,
          ),
          const SizedBox(height: 20),
          _buildOrderItem(
            context,
            date: "Jan 17 . 1:34pm",
            orderId: "454670",
            itemsCount: 3,
            image: "assets/images/componentexamle.png",
            price: "EGP 1004",
            isRated: false,
            rating: 0,
          ),
        ],
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
              Center(
                  child: Row(
                children: [
                  Text("Order ID: $orderId",
                      style: TextStyle(color: Colors.grey[600])),
                  Spacer(),
                  Text("2 item", style: TextStyle(color: Colors.grey[600])),
                ],
              )),
              SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(image,
                            width: 100, height: 100, fit: BoxFit.cover),
                        const SizedBox(width: 7),
                        Text(price,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        TextButton(
                          onPressed: () {},
                          child: Text("View details",
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
                    onPressed: () {},
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
