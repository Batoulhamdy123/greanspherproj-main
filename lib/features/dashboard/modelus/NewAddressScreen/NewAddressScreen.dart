// lib/features/dashboard/modelus/NewAddressScreen/NewAddressScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // لاستخدام TextInputFormatter
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart'; // ApiService
// لا تحتاج لاستيراد google_maps_flutter, geolocator, geocoding هنا

class NewAddressScreen extends StatefulWidget {
  const NewAddressScreen({Key? key}) : super(key: key);

  @override
  _NewAddressScreenState createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<NewAddressScreen> {
  final _formKey = GlobalKey<FormState>(); // مفتاح للتحقق من صحة الفورم

  final List<String> _egyptianGovernorates = [
    // قائمة المحافظات [cite: image_a0adbb.png]
    'Cairo', 'Giza', 'Alexandria', 'Sharqia', 'Dakahlia', 'Beheira', 'Minufiya',
    'Qalyubia', 'Gharbia', 'Kafr El Sheikh', 'Damietta', 'Port Said',
    'Ismailia',
    'Suez', 'North Sinai', 'South Sinai', 'Fayoum', 'Beni Suef', 'Minya',
    'Asyut', 'Sohag', 'Qena', 'Luxor', 'Aswan', 'Red Sea', 'New Valley',
    'Matruh'
  ];

  String? _selectedGovernorate; // المحافظة المختارة

  final TextEditingController _governorateController =
      TextEditingController(); // سنستخدمه كـ hint
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _townController = TextEditingController();
  final TextEditingController _buildingNameController = TextEditingController();
  final TextEditingController _houseNoController = TextEditingController();
  final TextEditingController _floorNoController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _streetController =
      TextEditingController(); // تأكد أن هذا موجود ومستخدم في الـ UI
  final TextEditingController _addressLabelController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String _currentAddressDisplay =
      "Locating... "; // نص وهمي للخريطة [cite: image_c9f559.png]

  @override
  void dispose() {
    _governorateController.dispose();
    _cityController.dispose();
    _townController.dispose();
    _buildingNameController.dispose();
    _houseNoController.dispose();
    _floorNoController.dispose();
    _landmarkController.dispose();
    _streetController.dispose(); // تأكد من عمل dispose له
    _addressLabelController.dispose();
    _phoneNumberController.dispose();
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
        title: const Text("New address", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            // زر بحث وهمي
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Search feature (dummy) for map area.")),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // إضافة Form للتحقق من صحة المدخلات
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // واجهة الخريطة الوهمية (صورة ثابتة) [cite: image_c9f559.png]
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                  image: const DecorationImage(
                    image: AssetImage(
                        'assets/images/Basemap image.png'), // استخدم صورة الخريطة الوهمية
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.location_on, color: Colors.red, size: 50),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _currentAddressDisplay, // عرض العنوان "المختار" [cite: image_c9f559.png]
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 16),

              // قسم "Area" مع زر "Change" (وهمي أيضاً) [cite: image_c9f559.png]
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _currentAddressDisplay
                          .split(',')
                          .first, // عرض جزء من العنوان الوهمي
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("Change address on map (dummy feature).")),
                      );
                    },
                    child: const Text("Change",
                        style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text("The detailed address",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),

              // حقول إدخال العنوان التفصيلية (بناءً على image_94e6be.png) [cite: image_94e6be.png]
              DropdownButtonFormField<String>(
                // Dropdown للمحافظة [cite: image_a0adbb.png]
                value: _selectedGovernorate,
                hint: const Text('Governorate*'),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: _egyptianGovernorates.map((String governorate) {
                  return DropdownMenuItem<String>(
                    value: governorate,
                    child: Text(governorate),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGovernorate = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a governorate' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      // City [cite: image_a0adbb.png]
                      controller: _cityController,
                      decoration: const InputDecoration(
                          labelText: 'City*', border: OutlineInputBorder()),
                      validator: (value) =>
                          value!.isEmpty ? 'City is required' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      // Town [cite: image_a0adbb.png]
                      controller: _townController,
                      decoration: const InputDecoration(
                          labelText: 'Town', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                // Address in detail [cite: image_a0adbb.png]
                controller:
                    _streetController, // يستخدم هنا كـ "Address in detail"
                decoration: const InputDecoration(
                    labelText: 'Address in detail*',
                    border: OutlineInputBorder()),
                validator: (value) =>
                    value!.isEmpty ? 'Detailed address is required' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      // Building name [cite: image_a0adbb.png]
                      controller: _buildingNameController,
                      decoration: const InputDecoration(
                          labelText: 'Building name*',
                          border: OutlineInputBorder()),
                      validator: (value) =>
                          value!.isEmpty ? 'Building name is required' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      // House.no. [cite: image_a0adbb.png]
                      controller: _houseNoController,
                      decoration: const InputDecoration(
                          labelText: 'House.no.*',
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'House number is required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _floorNoController,
                      decoration: const InputDecoration(
                          labelText: 'Floor (optional)',
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      // Landmark (optional) [cite: image_a0adbb.png]
                      controller: _landmarkController,
                      decoration: const InputDecoration(
                          labelText: 'Landmark (optional)',
                          border: OutlineInputBorder()),
                      maxLines: 1, // سطر واحد للـ landmark
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                // Address label (optional) [cite: image_a0adbb.png]
                controller: _addressLabelController,
                decoration: const InputDecoration(
                    labelText: 'Address label (optional)',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                // Phone number [cite: image_a0adbb.png]
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('+20',
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey)), // رمز الدولة
                  ),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // يقبل أرقام فقط
                  LengthLimitingTextInputFormatter(
                      11), // يحد لـ 11 رقم [cite: image_a0adbb.png]
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Phone number is required';
                  }
                  if (value.length != 11) {
                    return 'Phone number must be 11 digits';
                  }
                  // التحقق من البداية 010, 011, 012, 015 [cite: image_a0adbb.png]
                  if (!value.startsWith('010') &&
                      !value.startsWith('011') &&
                      !value.startsWith('012') &&
                      !value.startsWith('015')) {
                    return 'Phone must start with 010, 011, 012, or 015';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // زر حفظ العنوان [cite: image_a0adbb.png]
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // التحقق من صحة الفورم
                      // جمع بيانات العنوان من الـ controllers وتنسيقها
                      final String streetCity =
                          "${_streetController.text}, ${_cityController.text}"; // Street and City for Checkout [cite: CheckoutScreen.dart]
                      final fullAddressDetails =
                          "Governorate: ${_selectedGovernorate ?? ''}, "
                          "City: ${_cityController.text}, Town: ${_townController.text}, "
                          "Address: ${_streetController.text}, "
                          "Building: ${_buildingNameController.text}, H.No: ${_houseNoController.text}, "
                          "Floor: ${_floorNoController.text}, Landmark: ${_landmarkController.text}, "
                          "Label: ${_addressLabelController.text}, "
                          "Phone: ${_phoneNumberController.text}";

                      Navigator.pop(context,
                          streetCity); // إرجاع العنوان المنسق لـ CheckoutScreen
                      // يمكنك أيضاً حفظ fullAddressDetails هنا في مكان آخر إذا أردت تفاصيل كاملة
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Save address",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
