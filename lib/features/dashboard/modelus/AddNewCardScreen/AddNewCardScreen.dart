// lib/features/dashboard/modelus/Checkout/view/AddNewCardScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For TextInputFormatter
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // Ensure you added this package

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({Key? key}) : super(key: key);

  @override
  _AddNewCardScreenState createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  bool _saveCardForLater = false;

  final MaskTextInputFormatter _cardNumberFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ####', // Card number mask
    filter: {"#": RegExp(r'[0-9]')},
  );

  final MaskTextInputFormatter _expiryFormatter = MaskTextInputFormatter(
    mask: '##/##', // Expiry date mask (MM/YY)
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    // تأكد أنك لا تقوم بعمل dispose لـ controllers غير موجودة هنا
    super.dispose();
  }

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
        title:
            const Text("Add new card", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter card details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            // Card Number
            TextField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [_cardNumberFormatter], // Apply card number mask
              decoration: InputDecoration(
                labelText: 'Card number',
                hintText: 'xxxx xxxx xxxx xxxx',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.credit_card, color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Expiry and CVV
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [_expiryFormatter], // Apply expiry mask
                    decoration: InputDecoration(
                      labelText: 'Expiry',
                      hintText: 'MM/YY',
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4)
                    ], // CVV max 4 digits
                    decoration: InputDecoration(
                      labelText: 'CVV code',
                      hintText: 'xxx or xxxx',
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Save card for later toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Save card for later",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                        "For faster and more secure checkout,\n save your card details",
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
                Switch(
                  value: _saveCardForLater,
                  onChanged: (value) {
                    setState(() {
                      _saveCardForLater = value;
                    });
                  },
                  activeColor: Colors.green,
                ),
              ],
            ),
            const Spacer(), // Pushes content to top, button to bottom

            // Pay Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement card payment logic (dummy for now)
                  final cardNumber =
                      _cardNumberController.text.replaceAll(' ', '');
                  final expiry = _expiryController.text;
                  final cvv = _cvvController.text;

                  if (cardNumber.length < 13 ||
                      expiry.length != 5 ||
                      cvv.length < 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter valid card details.')),
                    );
                    return;
                  }

                  // Simulate a successful card add for now
                  Navigator.pop(context,
                      "Card ending in ${cardNumber.substring(cardNumber.length - 4)}");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Pay now  EGP 313", // Hardcoded price for now
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
