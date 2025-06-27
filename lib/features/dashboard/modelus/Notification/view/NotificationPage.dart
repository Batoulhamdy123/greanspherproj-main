// lib/features/dashboard/modelus/Notification/view/NotificationPage.dart
import 'package:flutter/material.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart'; // ApiService, DiseaseAlertItem
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // لـ kIsWeb
import 'dart:io'; // <--- استيراد ImagePicker
// لا تحتاج لاستيراد app_models_and_api_service.dart بشكل مباشر، استخدم app_api_service.dart

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  String _errorMessage = ''; // <--- هذا هو المتغير لرسائل الخطأ العامة

  List<DiseaseAlertItem> _diseaseAlerts =
      []; // قائمة الإشعارات [cite: NotificationsPage.dart]

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadDiseaseAlerts(); // جلب الإشعارات المحفوظة عند بدء التشغيل
  }

  // دالة لجلب الإشعارات من shared_preferences
  Future<void> _loadDiseaseAlerts() async {
    try {
      final alerts = await ApiService
          .getLocalDiseaseAlerts(); // جلب الإشعارات [cite: app_api_service.dart]
      setState(() {
        _diseaseAlerts = alerts;
      });
    } catch (e) {
      print("Error loading local disease alerts: $e");
      // لا تعرض SnackBar هنا، فقد يكون التطبيق بدأ لتوه.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // تم إضافة AppBar هنا ليحتوي على زر الرجوع وشريط البحث والـ TabBar
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Padding(
          // وضع شريط البحث في الـ title
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextField(
                controller: _searchController,
                textAlign: TextAlign.left,
                decoration: const InputDecoration(
                  hintText: "Hinted search text",
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search, color: Colors.green),
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
        ),
        bottom: PreferredSize(
          // لإضافة الـ tabs تحت الـ AppBar
          preferredSize: const Size.fromHeight(48.0),
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.green,
            indicatorWeight: 4,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: "Updates"),
              Tab(text: "Diseases"),
              Tab(text: "Rewards"),
            ],
          ),
        ),
      ),
      body: Column(
        // Main column for content after AppBar
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                const Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Image.asset(
                  // تأكد من وجود هذه الصورة
                  "assets/images/notificationline.png",
                  height: 12,
                  width: 99,
                )
              ],
            ),
          ),
          Divider(color: Colors.grey.shade300, thickness: 1), // خط فاصل

          // 📌 محتوى كل Tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationList(
                    "Updates"), // Tab for Updates [cite: image_000461.png]
                _buildNotificationList(
                    "Diseases"), // Tab for Diseases [cite: image_000461.png]
                _buildNotificationList(
                    "Rewards"), // Tab for Rewards [cite: image_000461.png]
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // زر الكاميرا العائم [cite: image_36ffe2.png]
        onPressed: () {
          _showImageSourceDialog(); // <--- استدعاء دالة عرض الخيارات
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // موضع الزر في الأسفل واليمين
    );
  }

  // بناء قوائم الإشعارات لكل Tab [cite: image_000461.png]
  Widget _buildNotificationList(String typeFilter) {
    List<DiseaseAlertItem> filteredAlerts = _diseaseAlerts.where((alert) {
      if (typeFilter == "Updates") {
        // ممكن تعرض هنا الـ "Healthy" و "Reward" alerts بالإضافة لأي "Update" خاص
        return alert.type == "Healthy" ||
            alert.type == "Update" ||
            alert.type == "Reward";
      } else if (typeFilter == "Diseases") {
        return alert.type ==
            "Disease"; // فقط إشعارات الأمراض [cite: image_000461.png]
      } else if (typeFilter == "Rewards") {
        return alert.type == "Reward";
      }
      return false;
    }).toList();

    if (filteredAlerts.isEmpty) {
      return Center(
        child: Text(
          "No $typeFilter notifications yet.",
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredAlerts.length,
      itemBuilder: (context, index) {
        final alert = filteredAlerts[index];
        // تحديد الأيقونة واللون بناءً على نوع الإشعار [cite: image_000461.png]
        IconData icon;
        Color iconColor;
        if (alert.type == "Healthy") {
          icon = Icons.check_circle;
          iconColor = Colors.green;
        } else if (alert.type == "Disease") {
          icon = Icons.error;
          iconColor = Colors.red;
        } else if (alert.type == "Reward") {
          icon = Icons.card_giftcard;
          iconColor = Colors.amber;
        } else {
          // Updates, etc.
          icon = Icons.info;
          iconColor = Colors.blue;
        }

        return Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Icon(icon, color: iconColor, size: 30),
            title: Text(
              alert.message,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "${alert.date.month}/${alert.date.day}, ${alert.date.year} at ${alert.date.hour % 12 == 0 ? 12 : alert.date.hour % 12}:${alert.date.minute.toString().padLeft(2, '0')} ${alert.date.hour < 12 ? 'AM' : 'PM'}", // تنسيق الوقت
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            trailing: alert.isNew
                ? const Icon(Icons.circle, color: Colors.blue, size: 10)
                : null, // نقطة زرقاء للإشعار الجديد
            onTap: () async {
              // TODO: يمكن هنا فتح تفاصيل الإشعار
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Alert tapped: ${alert.message}')),
              );
              // لو الإشعار جديد، ممكن تعلم عليه إنه اتقرا
              setState(() {
                alert.isNew = false; // لا يمكن تغيير final field
                // يجب إنشاء نسخة جديدة من الـ alert
                final updatedAlert = DiseaseAlertItem(
                  id: alert.id,
                  message: alert.message,
                  type: alert.type,
                  date: alert.date,
                  details: alert.details,
                  isNew: false, // تم تحديثها
                );
                final index = _diseaseAlerts
                    .indexWhere((element) => element.id == alert.id);
                if (index != -1) {
                  _diseaseAlerts[index] = updatedAlert;
                }
              });
              await ApiService.saveLocalDiseaseAlerts(
                  _diseaseAlerts); // حفظ التغيير [cite: app_api_service.dart]
            },
          ),
        );
      },
    );
  }

  // ----------------------------------------------------
  // CAMERA / IMAGE PICKER Logic
  // ----------------------------------------------------

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo from Camera'),
                onTap: () {
                  Navigator.pop(context); // إغلاق الـ Bottom Sheet
                  _pickImage(ImageSource.camera); // التقاط صورة بالكاميرا
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context); // إغلاق الـ Bottom Sheet
                  _pickImage(ImageSource.gallery); // اختيار صورة من المعرض
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // في ملف NotificationPage.dart، داخل _NotificationsPageState
// ...
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: source); // التقاط أو اختيار الصورة

    if (image != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Image selected: ${image.name}')), // عرض اسم الملف
      );
      String predictionResult = '';
      String alertType = '';
      String alertMessage = '';

      try {
        predictionResult = await _apiService
            .uploadPlantImageForPrediction(image); // <--- استدعاء الـ AI
        alertMessage = "Your plant is disease free";
        alertType = "Healthy";

        if (predictionResult.toLowerCase().contains('disease') ||
            predictionResult.toLowerCase().contains('mildew') ||
            predictionResult.toLowerCase().contains('rust')) {
          alertMessage = "Your plant has: $predictionResult";
          alertType = "Disease";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('AI Prediction: $predictionResult')),
        );
        print('AI Prediction Result: $predictionResult');
      } catch (e) {
        alertMessage = 'Error getting AI prediction: ${e.toString()}';
        alertType = "Error"; // نوع جديد للخطأ
        predictionResult = 'Error'; // لتمرير شيء في PredictionResult

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(alertMessage)),
        );
        print('AI Prediction Error: ${e.toString()}');
      }

      // إنشاء DiseaseAlertItem جديد وحفظه في القائمة
      final newAlert = DiseaseAlertItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // ID فريد للإشعار
        message: alertMessage,
        type: alertType,
        date: DateTime.now(),
        details:
            predictionResult, // حفظ الـ prediction الأصلية أو الخطأ كتفاصيل
        isNew: true, // إشعار جديد
      );

      setState(() {
        _diseaseAlerts.insert(0, newAlert); // إضافة الإشعار الجديد في البداية
      });
      await ApiService.saveLocalDiseaseAlerts(
          _diseaseAlerts); // حفظ القائمة المحدثة

      // عرض الـ Dialog مع الصورة الفعلية التي تم التقاطها
      _showPredictionResultDialog(
          alertMessage, image.path, alertType); // <--- تمرير رسالة وصورة ونوع
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected.')),
      );
    }
  }

  // ... (بقية الدوال في NotificationPage) ...

  // دالة لعرض نتيجة الـ Prediction في Dialog [cite: image_ff053c.png]
  // في ملف NotificationPage.dart
// ...
  // في ملف NotificationPage.dart، داخل class _NotificationsPageState
// ...
// دالة لعرض نتيجة الـ Prediction في Dialog
  void _showPredictionResultDialog(
      String message, String imagePath, String type) {
    // <--- توقيع الدالة الجديد
    String displayMessage = message; // الرسالة اللي هتظهر في الـ Dialog
    String defaultAssetImage; // الصورة اللي هتظهر لو الصورة اللي التقطت محملتش

    // تحديد الصورة الافتراضية بناءً على نوع النتيجة
    if (type == "Healthy") {
      defaultAssetImage = 'assets/images/saveplant.png'; // صورة للنبات السليم
    } else if (type == "Disease") {
      defaultAssetImage =
          'assets/images/diseaseplant.png'; // صورة للنبات المريض
    } else {
      // لو فيه خطأ أو نوع غير معروف
      defaultAssetImage = 'assets/images/placeholder.png'; // صورة عامة للخطأ
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // عرض الصورة الملتقطة من الفون أو استخدام صورة الـ default لو فيه مشكلة
              kIsWeb // لو التطبيق شغال ويب
                  ? Image.network(
                      imagePath, height: 100, width: 100, fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                          defaultAssetImage,
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain), // Fallback لصورة الـ asset
                    )
                  : Image.file(
                      File(imagePath), height: 100, width: 100,
                      fit: BoxFit.contain, // للموبايل، نستخدم Image.file
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                          defaultAssetImage,
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain), // Fallback لصورة الـ asset
                    ),
              const SizedBox(height: 16),
              Text(
                displayMessage, // عرض الرسالة اللي تم تجهيزها
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // إغلاق الـ Dialog
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
