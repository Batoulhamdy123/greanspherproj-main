// lib/features/dashboard/modelus/Videos/view/AllCategoriesScreen.dart
import 'package:flutter/material.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart'; // ApiService, ShortCategory
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Home/view/VideosScreen.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Videos/view/VideosScreen.dart'; // VideosScreen
import 'package:greanspherproj/features/dashboard/modelus/Home/view/featured_card_widget.dart'; // لإعادة استخدام FeaturedCardWidget

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  final ApiService _apiService = ApiService();
  List<ShortCategory> _allCategories = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAllCategories(); // جلب كل التصنيفات
  }

  Future<void> _fetchAllCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final categories = await _apiService
          .fetchShortCategories(); // <--- جلب كل التصنيفات من API
      setState(() {
        _allCategories = categories;
      });
    } catch (e) {
      print("Error fetching all categories: $e");
      setState(() {
        _errorMessage = 'Failed to load categories: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // دالة مساعدة للحصول على صورة مصغرة لكل Category (يمكن استبدالها بصور من API لاحقاً)
  String _getCategoryThumbnail(String categoryName) {
    switch (categoryName) {
      case "Hydroponic Plant Diseases":
        return 'assets/images/hydropolicplant.png';
      case "Hydroponics Guide":
        return 'assets/images/hydropolicguide.png';
      case "Hydroponic Components":
        return 'assets/images/hydropolicusage.png';
      case "Rewards and Notifications":
        return 'assets/images/hydropolicupdate.png';
      default:
        return 'assets/images/homwpagw11.png'; // صورة افتراضية
    }
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
        title: const Text("All Categories",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _allCategories.isEmpty
                  ? const Center(child: Text("No categories available."))
                  : GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // عرض عمودين
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.2, // نسبة العرض للارتفاع
                      ),
                      itemCount: _allCategories.length, // عرض كل التصنيفات
                      itemBuilder: (context, index) {
                        final category = _allCategories[index];
                        return GestureDetector(
                          onTap: () {
                            // عند الضغط على تصنيف، اذهب إلى شاشة الفيديوهات ومرر اسم الـ category
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideosScreen(
                                  categoryName:
                                      category.name, // تمرير اسم الكاتيجوري
                                ),
                              ),
                            );
                          },
                          child: FeaturedCardWidget(
                            title: category.name, // اسم الكاتيجوري كعنوان
                            imagePath: _getCategoryThumbnail(
                                category.name), // صورة مصغرة للكاتيجوري
                            categoryName: category
                                .name, // تمرير اسم الكاتيجوري كـ categoryName
                          ),
                        );
                      },
                    ),
    );
  }
}
