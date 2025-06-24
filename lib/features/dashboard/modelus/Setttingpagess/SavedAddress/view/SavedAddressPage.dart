// lib/features/dashboard/modelus/SavedAddressScreen/SavedAddressPage.dart
import 'package:flutter/material.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart'; // ApiService for local storage
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/NewAddressScreen/NewAddressScreen.dart'; // استيراد NewAddressScreen

class SavedAddressPage extends StatefulWidget {
  const SavedAddressPage({super.key});

  @override
  State<SavedAddressPage> createState() => _SavedAddressPageState();
}

class _SavedAddressPageState extends State<SavedAddressPage> {
  List<String> _savedAddresses = []; // قائمة العناوين المحفوظة
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAddresses(); // جلب العناوين عند بدء تشغيل الشاشة
  }

  // دالة لجلب العناوين المحفوظة من shared_preferences
  Future<void> _loadAddresses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final addresses = await ApiService
          .getLocalAddresses(); // جلب العناوين [cite: app_api_service.dart]
      setState(() {
        _savedAddresses = addresses;
      });
    } catch (e) {
      print("Error loading saved addresses: $e");
      setState(() {
        _errorMessage = 'Failed to load saved addresses: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // دالة لحفظ عنوان جديد في shared_preferences
  Future<void> _saveAddress(String address) async {
    setState(() {
      _savedAddresses.add(address); // إضافة العنوان للقائمة المحلية
    });
    await ApiService.saveLocalAddresses(
        _savedAddresses); // حفظ القائمة المحدثة [cite: app_api_service.dart]
  }

  // دالة لحذف عنوان من shared_preferences
  Future<void> _deleteAddress(int index) async {
    setState(() {
      _savedAddresses.removeAt(index); // حذف العنوان من القائمة المحلية
    });
    await ApiService.saveLocalAddresses(
        _savedAddresses); // حفظ القائمة المحدثة [cite: app_api_service.dart]
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          // زر رجوع قياسي
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Addresses",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // الانتقال إلى NewAddressScreen لجلب عنوان جديد
              final newAddress = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NewAddressScreen()),
              );
              if (newAddress != null && newAddress is String) {
                await _saveAddress(
                    newAddress); // حفظ العنوان الجديد بعد العودة [cite: app_api_service.dart]
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Address saved: $newAddress')),
                );
                // إذا تم حفظ عنوان جديد، وتريد إرجاعه لـ CheckoutScreen:
                Navigator.pop(context, newAddress);
              }
            },
            child: const Text(
              "Add",
              style: TextStyle(color: Colors.green, fontSize: 20),
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _savedAddresses.isEmpty
                  ? const Center(
                      child: Text("No saved addresses yet.",
                          style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _savedAddresses.length,
                      itemBuilder: (context, index) {
                        final address = _savedAddresses[index];
                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: const Icon(Icons.location_on,
                                color: Colors.green),
                            title: Text(address),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _deleteAddress(index), // حذف العنوان
                            ),
                            onTap: () {
                              // عند اختيار عنوان، نرجع النص لـ CheckoutScreen
                              Navigator.pop(context, address);
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
