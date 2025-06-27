// lib/features/dashboard/modelus/Checkout/view/CheckoutScreen.dart
import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/AddNewCardScreen/AddNewCardScreen.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart'; // <--- تأكد من صحة هذا الاستيراد
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/NewAddressScreen/NewAddressScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Order/view/OrderPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/SavedAddress/view/SavedAddressPage.dart';
//import 'package:greanspherproj/features/dashboard/modelus/SavedAddressScreen/SavedAddressPage.dart'; // <--- استيراد SavedAddressPage

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
  final ApiService _apiService = ApiService(); // <--- تأكد أن هذا السطر موجود
  Map<String, String>? _cardDetails;
  // في ملف CheckoutScreen.dart، بعد نهاية دالة build، وقبل نهاية class _CheckoutScreenState
// ...
  // دالة مساعدة لاستخراج رقم الهاتف من العنوان
  String _extractPhoneNumberFromAddress(String address) {
    // هذا تحليل بسيط. الأفضل أن يتم حفظ العنوان كـ Map أو Object
    // مثال: "Governorate: ..., City: ..., ..., Phone: 01012345678"
    final phoneMatch = RegExp(r'Phone: (\d+)').firstMatch(address);
    return phoneMatch?.group(1) ??
        "00000000000"; // ارجع رقم وهمي لو لم يتم العثور عليه
  }

  // دالة مساعدة لاستخراج اسم المبنى
  String _extractBuildingNameFromAddress(String address) {
    // مثال: "Building: Alkoraty, H.No: 123, Street: ..."
    final match = RegExp(r'Building: ([^,]+)').firstMatch(address);
    return match?.group(1)?.trim() ?? "N/A Building";
  }

  // دالة مساعدة لاستخراج رقم الطابق
  String _extractFloorFromAddress(String address) {
    final match = RegExp(r'Floor: ([^,]+)').firstMatch(address);
    return match?.group(1)?.trim() ?? "N/A Floor";
  }

  // دالة مساعدة لاستخراج اسم الشارع (الـ detailed address)
  String _extractStreetFromAddress(String address) {
    // بما أننا سميناها "Address in detail" في NewAddressScreen
    final match = RegExp(r'Address: ([^,]+)').firstMatch(address);
    return match?.group(1)?.trim() ?? "N/A Street";
  }

  // دالة مساعدة لاستخراج اتجاهات إضافية
  String _extractAdditionalDirectionsFromAddress(String address) {
    final match =
        RegExp(r'Additional: ([^,]+)').firstMatch(address); // أو "Landmark"
    return match?.group(1)?.trim() ?? ""; // فارغة لو لا توجد
  }

  // دالة مساعدة لاستخراج addressLabel
  String _extractAddressLabelFromAddress(String address) {
    final match = RegExp(r'Label: ([^,]+)').firstMatch(address);
    return match?.group(1)?.trim() ?? "Default Label";
  }
// <--- هذا المتغير لحفظ تفاصيل البطاقة

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
                                image: AssetImage(
                                    'assets/images/mappimage.png'), // <--- تأكد من وجود هذه الصورة
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
                                      selectedAddress = selectedOrNewAddress;
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
                              final Map<String, String>? newCardDetails =
                                  await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddNewCardScreen()),
                              );
                              if (newCardDetails != null &&
                                  newCardDetails['displayText'] != null) {
                                setState(() {
                                  selectedPaymentMethod =
                                      newCardDetails['displayText'];
                                  _cardDetails = newCardDetails;
                                });
                              }
                            },
                            controlAffinity: ListTileControlAffinity.trailing,
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
                            controlAffinity: ListTileControlAffinity.trailing,
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // --- Place Order Button (خارج SingleChildScrollView) ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // التحقق من أن العنوان وطريقة الدفع مختارين
                  if (selectedAddress == null || selectedAddress!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please select a delivery address.")),
                    );
                    return;
                  }
                  if (selectedPaymentMethod == null ||
                      selectedPaymentMethod!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please select a payment method.")),
                    );
                    return;
                  }
                  if (selectedPaymentMethod == "Add new card") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text("Please add card details or select Cash.")),
                    );
                    return;
                  }

                  List<CartItem> cartItemsForOrder = [];
                  try {
                    cartItemsForOrder = await _apiService
                        .fetchBasketItems(); // جلب عناصر السلة مرة أخرى
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Failed to get cart items for order: $e')),
                    );
                    print("Error getting cart items for order: $e");
                    return;
                  }

                  if (cartItemsForOrder.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text("Your cart is empty. Cannot place order.")),
                    );
                    return;
                  }

                  // تحويل CartItem إلى الفورمات المتوقع من API الطلبات (OrderSummaryItem)
                  List<Map<String, dynamic>> orderItems = cartItemsForOrder
                      .map((item) => {
                            "productId": item.productId,
                            "productName":
                                item.productDetails?.name ?? "Unknown",
                            "pictureUrl":
                                item.productDetails?.imageUrl ?? "placeholder",
                            "quantity": item.quantity,
                            "unitPrice": item.productDetails?.price ?? 0.0,
                            "totalPrice": (item.productDetails?.price ?? 0.0) *
                                item.quantity,
                          })
                      .toList();

                  // تفاصيل العنوان (سنقوم باستخراجها باستخدام الدوال التي سنعرفها الآن)
                  String phoneNumber =
                      _extractPhoneNumberFromAddress(selectedAddress!) ??
                          "00000000000";
                  String buildingName =
                      _extractBuildingNameFromAddress(selectedAddress!) ??
                          "Building";
                  String floor =
                      _extractFloorFromAddress(selectedAddress!) ?? "0";
                  String street =
                      _extractStreetFromAddress(selectedAddress!) ?? "Street";
                  String additionalDirections =
                      _extractAdditionalDirectionsFromAddress(
                              selectedAddress!) ??
                          "";
                  String addressLabel =
                      _extractAddressLabelFromAddress(selectedAddress!) ??
                          "Home";
                  double latitude = 0.0; // تحتاج للحصول عليها من مكان ما
                  double longitude = 0.0; // تحتاج للحصول عليها من مكان ما

                  try {
                    if (selectedPaymentMethod == "Cash") {
                      await _apiService.createCashOrder(
                        phoneNumber: phoneNumber,
                        latitude: latitude,
                        longitude: longitude,
                        buildingName: buildingName,
                        floor: floor,
                        street: street,
                        additionalDirections: additionalDirections,
                        addressLabel: addressLabel,
                        totalAmount: widget.totalAmount,
                        deliveryFee: widget.deliveryFee,
                        orderItems: orderItems,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Cash order placed successfully!")));
                    } else if (selectedPaymentMethod!.startsWith("Card")) {
                      // "Card ending in XXXX"
                      if (_cardDetails == null ||
                          _cardDetails!['cardNumber'] == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Card details not provided.")),
                        );
                        return;
                      }
                      await _apiService.createOnlineOrder(
                        phoneNumber: phoneNumber,
                        latitude: latitude,
                        longitude: longitude,
                        buildingName: buildingName,
                        floor: floor,
                        street: street,
                        additionalDirections: additionalDirections,
                        addressLabel: addressLabel,
                        totalAmount: widget.totalAmount,
                        deliveryFee: widget.deliveryFee,
                        orderItems: orderItems,
                        cardNumber: _cardDetails!['cardNumber']!,
                        expiryDate: _cardDetails!['expiryDate']!,
                        cvv: _cardDetails!['cvv']!,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Online order placed successfully!")));
                    }

                    // مسح السلة بعد نجاح الطلب
                    await _apiService.clearBasket();

                    // التوجيه إلى صفحة الطلبات
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrdersScreen()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to place order: $e')),
                    );
                    print("Error placing order: $e");
                  }
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
