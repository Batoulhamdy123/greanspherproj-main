// lib/features/dashboard/modelus/Checkout/view/CheckoutScreen.dart
import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/AddNewCardScreen/AddNewCardScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/NewAddressScreen/NewAddressScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Order/view/OrderPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/SavedAddress/view/SavedAddressPage.dart';

class CheckoutScreen extends StatefulWidget {
  final double cartTotal;
  final double deliveryFee;
  final double totalAmount;

  const CheckoutScreen({
    Key? key,
    required this.cartTotal,
    required this.deliveryFee,
    required this.totalAmount,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? selectedAddress; // العنوان المختار
  String?
      selectedPaymentMethod; // طريقة الدفع المختارة (e.g., "Cash", "Visa ending in 1234")

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Checkout", style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        // هذا الـ Column الخارجي لتحديد مساحة المحتوى القابل للتمرير والزر الثابت
        children: [
          Expanded(
            // هذا الـ Expanded يجعل SingleChildScrollView يأخذ المساحة المتبقية
            child: SingleChildScrollView(
              // لا نحتاج padding هنا أيضاً إذا كان الـ Column الرئيسي لديه بالفعل padding 16.0
              // ولكن سنتركه ليتطابق مع تصميمك السابق
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Map/Address Section ---
                  Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          // Placeholder for the map area
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              image: const DecorationImage(
                                // ضع هنا مسار صورة تحاكي الخريطة
                                image:
                                    AssetImage('assets/images/mappimage.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: const Center(
                              child: Icon(Icons.location_on,
                                  color: Colors.green, size: 50),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  selectedAddress ??
                                      "No address selected. Tap Change to add.",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              // في ملف CheckoutScreen.dart
// ...
                              TextButton(
                                onPressed: () async {
                                  // الذهاب إلى SavedAddressPage لاستقبال عنوان محفوظ أو جديد
                                  final selectedOrNewAddress =
                                      await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SavedAddressPage()),
                                  );
                                  if (selectedOrNewAddress != null &&
                                      selectedOrNewAddress is String) {
                                    setState(() {
                                      // هنا يتم تقسيم العنوان لاستخراج الشارع والمدينة
                                      // نفترض أن العنوان يعود بصيغة: "Street: ..., City: ..." أو ما شابه
                                      // سنأخذ أول جزئين أو جزء الشارع والمدينة لو كانت مفصولة بعلامات معينة
                                      String displayString =
                                          selectedOrNewAddress;
                                      if (selectedOrNewAddress
                                              .contains("Street:") &&
                                          selectedOrNewAddress
                                              .contains("City:")) {
                                        final streetPart = selectedOrNewAddress
                                            .substring(
                                                selectedOrNewAddress
                                                        .indexOf("Street:") +
                                                    "Street: ".length,
                                                selectedOrNewAddress.indexOf(
                                                            ", Landmark:") !=
                                                        -1
                                                    ? selectedOrNewAddress
                                                        .indexOf(", Landmark:")
                                                    : selectedOrNewAddress
                                                                .indexOf(
                                                                    ", Phone:") !=
                                                            -1
                                                        ? selectedOrNewAddress
                                                            .indexOf(", Phone:")
                                                        : selectedOrNewAddress
                                                            .length)
                                            .trim();
                                        final cityPart = selectedOrNewAddress
                                            .substring(
                                                selectedOrNewAddress
                                                        .indexOf("City:") +
                                                    "City: ".length,
                                                selectedOrNewAddress.indexOf(
                                                            ", Town:") !=
                                                        -1
                                                    ? selectedOrNewAddress
                                                        .indexOf(", Town:")
                                                    : selectedOrNewAddress.indexOf(
                                                                ", Governorate:") !=
                                                            -1
                                                        ? selectedOrNewAddress
                                                            .indexOf(
                                                                ", Governorate:")
                                                        : selectedOrNewAddress
                                                            .length)
                                            .trim();
                                        displayString =
                                            "$streetPart, $cityPart";
                                      } else if (selectedOrNewAddress
                                          .contains(',')) {
                                        // إذا كان فيه commas، ناخد الجزء الأول والثاني كـ Street, City
                                        final parts =
                                            selectedOrNewAddress.split(',');
                                        if (parts.length >= 2) {
                                          displayString =
                                              "${parts[0].trim()}, ${parts[1].trim()}";
                                        } else {
                                          displayString = parts[0].trim();
                                        }
                                      }
                                      selectedAddress = displayString;
                                    });
                                  }
                                },
                                child: const Text("Change",
                                    style: TextStyle(color: Colors.green)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Delivery Time Section ---
                  Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          const Icon(Icons.delivery_dining,
                              color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Delivery",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    "Arriving in approx. ${widget.deliveryFee > 0 ? '20 mins' : 'N/A'}",
                                    style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Payment Method Section ---
                  const Text("Pay with",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            // بدلاً من leading، نضع الأيقونة داخل الـ title في Row
                            title: Row(
                              children: [
                                const Icon(Icons.add_circle_outline,
                                    color: Colors.black),
                                const SizedBox(width: 8),
                                const Text("Add new card",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                            value: "Add new card",
                            groupValue: selectedPaymentMethod,
                            onChanged: (value) async {
                              setState(() {
                                selectedPaymentMethod = value;
                              });
                              final newCardDetails = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddNewCardScreen()),
                              );
                              if (newCardDetails != null &&
                                  newCardDetails is String) {
                                setState(() {
                                  selectedPaymentMethod = newCardDetails;
                                });
                              }
                            },
                            controlAffinity: ListTileControlAffinity
                                .trailing, // <--- هذا هو التعديل
                          ),
                          const Divider(height: 1, indent: 15, endIndent: 15),
                          RadioListTile<String>(
                            title: Row(
                              children: [
                                const Icon(Icons.money, color: Colors.black),
                                const SizedBox(width: 8),
                                const Text("Cash"),
                              ],
                            ),
                            value: "Cash",
                            groupValue: selectedPaymentMethod,
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentMethod = value;
                              });
                            },
                            controlAffinity: ListTileControlAffinity
                                .trailing, // <--- وهذا هو التعديل
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Payment Summary ---
                  const Text("Payment summary",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Cart total"),
                      Text("EGP ${widget.cartTotal.toStringAsFixed(2)}"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Delivery"),
                      Text("EGP ${widget.deliveryFee.toStringAsFixed(2)}"),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total amount",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("EGP ${widget.totalAmount.toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(
                      height:
                          20), // هذا SizedBox (أو قد يكون Spacer) هو الذي كان يسبب المشكلة

                  // هنا يجب أن لا يكون هناك Spacer. زر Place Order هو التالي مباشرة
                  // أو بعد SizedBox بسيط
                ],
              ),
            ),
          ),
          // --- Place Order Button (خارج SingleChildScrollView) ---
          Padding(
            padding: const EdgeInsets.all(16.0), // إضافة padding للزر
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrdersScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Place order",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
