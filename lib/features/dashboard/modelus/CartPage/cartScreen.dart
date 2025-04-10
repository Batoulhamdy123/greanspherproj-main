import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/product_data.dart';

class CartPage extends StatelessWidget {
  final List<Product> cartItems;
  final Function(Product) onRemoveFromCart;

  const CartPage({
    Key? key,
    required this.cartItems,
    required this.onRemoveFromCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: cartItems.isEmpty
          ? Center(child: Text("Your cart is empty."))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.asset(product.imageUrl, width: 50),
                    title: Text(product.name),
                    subtitle: Text("EGP ${product.price}"),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => onRemoveFromCart(product),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
/*import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/product_data.dart';

class CartScreen extends StatefulWidget {
  final Product product;
  final int initialQuantity; // العدد الذي تم اختياره في ProductDetailsScreen

  const CartScreen(
      {Key? key, required this.product, required this.initialQuantity})
      : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int quantity = 1;
  double deliveryFee = 35.0; // تكلفة التوصيل
  String specialRequest = ""; // نص الطلب الخاص

  @override
  void initState() {
    super.initState();
    quantity =
        widget.initialQuantity; // تحديث العدد المبدئي من ProductDetailsScreen
  }

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  // فتح BottomSheet لإضافة طلب خاص
  void openSpecialRequestSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
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
                  Text("Any special requests?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.green),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              TextField(
                controller: requestController,
                maxLines: 3,
                maxLength: 200,
                decoration: InputDecoration(
                  hintText: "Anything else we need to know?",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    specialRequest = requestController.text;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text("Save"),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double cartTotal = widget.product.price * quantity;
    double totalAmount = cartTotal + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Cart", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ صورة المنتج + الاسم + مربع العدد
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(widget.product.imageUrl, height: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.product.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                  ],
                ),
                // ✅ مربع زيادة ونقصان الكمية
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, color: Colors.green),
                            onPressed: decreaseQuantity,
                          ),
                          Text("$quantity",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: Icon(Icons.add, color: Colors.green),
                            onPressed: increaseQuantity,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            // ✅ Special Request
            GestureDetector(
              onTap: openSpecialRequestSheet,
              child: Row(
                children: [
                  Icon(Icons.chat_bubble_outline, color: Colors.black),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Any special requests?",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        specialRequest.isEmpty
                            ? "Anything else we need to know?"
                            : specialRequest,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // ✅ Payment Summary
            Text("Payment summary",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Cart total"),
                Text("EGP ${cartTotal.toStringAsFixed(2)}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Delivery"),
                Text("EGP ${deliveryFee.toStringAsFixed(2)}"),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total amount",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
                Text("EGP ${totalAmount.toStringAsFixed(2)}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),

            // ✅ الأزرار
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // كود إضافة المزيد من المنتجات
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.green),
                    ),
                    child: Text("Add items",
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // كود الدفع
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text("Checkout"),
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
*/
