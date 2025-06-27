// lib/features/dashboard/modelus/Home/view/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart'; // ApiService, PointsSummary, ShortItem, ShortCategory
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Home/view/AllCategoriesScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Home/view/VideosScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Reward/view/Reward.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Reward/view/RewardsScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/chatbot/chatbotpage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Home/view/featured_card_widget.dart';
import 'package:greanspherproj/features/dashboard/modelus/Home/view/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  PointsSummary? _pointsSummary;
  List<ShortCategory> _shortCategories = [];
  bool _isLoadingPoints = true;
  bool _isLoadingCategories = true;
  String _errorMessage = '';
  String _currentUserName = "User";

  final List<String> horizontalImages = [
    'assets/images/scroll1.png',
    'assets/images/scroll2.png',
    'assets/images/scroll3.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoadingPoints = true;
      _isLoadingCategories = true;
      _errorMessage = '';
    });
    try {
      String? userName = await ApiService.getCurrentUserName();
      if (userName != null) {
        setState(() {
          _currentUserName = userName;
        });
      }

      final summary = await _apiService.fetchPointsSummary();
      setState(() {
        _pointsSummary = summary;
        _isLoadingPoints = false;
      });

      final categories = await _apiService.fetchShortCategories();
      setState(() {
        _shortCategories = categories;
        _isLoadingCategories = false;
      });
    } catch (e) {
      print("Error loading Home screen data: $e");
      setState(() {
        _errorMessage = 'Failed to load data: $e';
        _isLoadingPoints = false;
        _isLoadingCategories = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarWidget(
                    onFilterToggle: () {
                      print('Filter toggle from Home Screen (dummy)');
                    },
                    onFilterSelected: (filter) {
                      print(
                          'Filter selected from Home Screen (dummy): $filter');
                    },
                    onSearchSubmitted: (query) {
                      print(
                          'Search submitted from Home Screen (dummy): $query');
                    },
                    isFilterExpanded: false,
                    cartItems: const [],
                    favoriteItems: const [],
                    onFavoriteRemoved: (p) {},
                    onClearAllFavorites: () {},
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: horizontalImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 145,
                          height: 82,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(horizontalImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: 'Your ',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      children: [
                        const TextSpan(
                            text: 'GreenSphere ',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'Rewards for $_currentUserName',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _isLoadingPoints
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: Colors.green, strokeWidth: 2))
                      : _errorMessage.isNotEmpty
                          ? Center(child: Text(_errorMessage))
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RewardsScreen()),
                                );
                              },
                              child: Center(
                                child: Container(
                                  width: 193,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.green, width: 2),
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: const BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        "${_pointsSummary?.totalPoints ?? 0} points",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Text("Featured Content",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AllCategoriesScreen()),
                          );
                        },
                        child: const Row(
                          children: [
                            Text("View More",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey)),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _isLoadingCategories
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.green))
                      : _shortCategories.isEmpty
                          ? const Center(
                              child: Text("No video categories available."))
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _shortCategories.length > 4
                                  ? 4
                                  : _shortCategories.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 1.2,
                              ),
                              itemBuilder: (context, index) {
                                final category = _shortCategories[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideosScreen(
                                          categoryName: category.name,
                                        ),
                                      ),
                                    );
                                  },
                                  child: FeaturedCardWidget(
                                    title: category.name,
                                    imagePath:
                                        _getCategoryThumbnail(category.name),
                                    categoryName: category.name,
                                  ),
                                );
                              },
                            ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatBotPage()),
                  );
                },
                child: Image.asset(
                  'assets/images/chatbot.png',
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        return 'assets/images/homwpagw11.png';
    }
  }
}
/*// lib/features/dashboard/modelus/Home/view/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart'; // ApiService, PointsSummary, ShortItem, ShortCategory
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Home/view/VideosScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Reward/view/Reward.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Reward/view/RewardsScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/chatbot/chatbotpage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Home/view/featured_card_widget.dart';
import 'package:greanspherproj/features/dashboard/modelus/Home/view/search_bar_widget.dart'; // SearchBarWidget for Home screen
//import 'package:greanspherproj/features/dashboard/modelus/Videos/view/VideosScreen.dart'; // شاشة عرض الفيديوهات

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  PointsSummary? _pointsSummary; // لملخص النقاط
  List<ShortCategory> _shortCategories = []; // تصنيفات الفيديوهات
  bool _isLoadingPoints = true;
  bool _isLoadingCategories = true; // مؤشر تحميل جديد
  String _errorMessage = '';
  String _currentUserName = "User"; // لاسم المستخدم

  final List<String> horizontalImages = [
    'assets/images/scroll1.png',
    'assets/images/scroll2.png',
    'assets/images/scroll3.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadData(); // جلب كل البيانات عند بدء التشغيل
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoadingPoints = true;
      _isLoadingCategories = true; // تفعيل مؤشر التحميل
      _errorMessage = '';
    });
    try {
      // جلب اسم المستخدم
      String? userName = await ApiService.getCurrentUserName();
      if (userName != null) {
        setState(() {
          _currentUserName = userName;
        });
      }

      // جلب ملخص النقاط
      final summary = await _apiService.fetchPointsSummary();
      setState(() {
        _pointsSummary = summary;
        _isLoadingPoints = false;
      });

      // جلب تصنيفات الفيديوهات (هذا سيحل محل featuredTitles/imagePaths الثابتة)
      final categories =
          await _apiService.fetchShortCategories(); // <--- جلب التصنيفات
      setState(() {
        _shortCategories = categories;
        _isLoadingCategories = false;
      });
    } catch (e) {
      print("Error loading Home screen data: $e");
      setState(() {
        _errorMessage = 'Failed to load data: $e';
        _isLoadingPoints = false;
        _isLoadingCategories = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // في ملف home_screen.dart، داخل دالة build
// ...
                  SearchBarWidget(
                    // <--- إزالة const لأننا سنمرر parameters
                    onFilterToggle: () {
                      // بما أن HomeScreen ليس لديها FilterList، هذه وظيفة dummy
                      print('Filter toggle from Home Screen (dummy)');
                    },
                    onFilterSelected: (filter) {
                      print(
                          'Filter selected from Home Screen (dummy): $filter');
                    },
                    onSearchSubmitted: (query) {
                      print(
                          'Search submitted from Home Screen (dummy): $query');
                      // TODO: يمكنك هنا إضافة منطق للبحث في المنتجات أو الفيديوهات من الهوم سكرين
                    },
                    isFilterExpanded:
                        false, // لا يوجد filter expanded في Home screen بهذا الشكل
                    cartItems: const [], // قائمة فارغة حالياً
                    favoriteItems: const [], // قائمة فارغة حالياً
                    onFavoriteRemoved: (p) {}, // دالة dummy
                    onClearAllFavorites: () {}, // دالة dummy
                  ),
// ...// شريط البحث
                  const SizedBox(height: 10),

                  // 🔁 Horizontal Images
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: horizontalImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 145,
                          height: 82,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(horizontalImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🌱 Rewards
                  RichText(
                    text: TextSpan(
                      text: 'Your ',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      children: [
                        const TextSpan(
                            text: 'GreenSphere ',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'Rewards for $_currentUserName',
                            style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold)), // عرض اسم المستخدم
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // نقاط المكافآت (Card)
                  _isLoadingPoints
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: Colors.green, strokeWidth: 2))
                      : _errorMessage.isNotEmpty
                          ? Center(child: Text(_errorMessage))
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RewardsScreen()),
                                );
                              },
                              child: Center(
                                child: Container(
                                  width: 193,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.green, width: 2),
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: const BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        "${_pointsSummary?.totalPoints ?? 0} points",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                  const SizedBox(height: 15),

                  // 🎬 Featured Content (Categories)
                  const Row(
                    children: [
                      Text("Featured Content",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text("View More",
                          style: TextStyle(fontSize: 18, color: Colors.grey)),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                      )
                    ],
                  ),

                  const SizedBox(height: 12),

                  // GridView لتصنيفات الفيديوهات (Short Categories)
                  _isLoadingCategories
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.green))
                      : _shortCategories.isEmpty
                          ? const Center(
                              child: Text("No video categories available."))
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _shortCategories.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 1.2,
                              ),
                              itemBuilder: (context, index) {
                                final category = _shortCategories[index];
                                return GestureDetector(
                                  onTap: () {
                                    // عند الضغط، اذهب إلى شاشة الفيديوهات ومرر اسم الـ category
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideosScreen(
                                          categoryName: category
                                              .name, // تمرير اسم الكاتيجوري
                                        ),
                                      ),
                                    );
                                  },
                                  child: FeaturedCardWidget(
                                    title:
                                        category.name, // اسم الكاتيجوري كعنوان
                                    imagePath: _getCategoryThumbnail(category
                                        .name), // صورة مصغرة للكاتيجوري (وهمية)
                                    categoryName: category
                                        .name, // تمرير اسم الكاتيجوري كـ categoryName
                                  ),
                                );
                              },
                            ),

                  const SizedBox(height: 80),
                ],
              ),
            ),

            // 🤖 زر الشات بوت
            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatBotPage()),
                  );
                },
                child: Image.asset(
                  'assets/images/chatbot.png',
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
      // أضف المزيد من الحالات هنا لبقية Categories
      default:
        return 'assets/images/homwpagw11.png'; // صورة افتراضية
    }
  }
}
*/
