// lib/features/dashboard/modelus/Reward/view/RewardsScreen.dart
import 'package:flutter/material.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart'; // ApiService, PointsSummary, RewardProduct
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Reward/view/HistoryScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/historypoints/pointhistory.dart'; // HistoryScreen

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  final ApiService _apiService = ApiService();
  PointsSummary? _pointsSummary;
  List<RewardProduct> _redeemableProducts =
      []; // قائمة المنتجات القابلة للاستبدال
  bool _isLoadingSummary = true;
  bool _isLoadingRedeemableProducts = true;
  String _errorMessage = '';
  String _currentUserName = "User"; // لاسم المستخدم، يمكن تحديثه من ApiService

  @override
  void initState() {
    super.initState();
    _loadUserName(); // جلب اسم المستخدم عند بدء التشغيل
    _fetchPointsData(); // جلب ملخص النقاط والمنتجات القابلة للاستبدال
  }

  Future<void> _loadUserName() async {
    String? userName =
        await ApiService.getCurrentUserName(); // جلب اسم المستخدم من ApiService
    if (userName != null) {
      setState(() {
        _currentUserName = userName;
      });
    }
  }

  Future<void> _fetchPointsData() async {
    setState(() {
      _isLoadingSummary = true;
      _isLoadingRedeemableProducts = true;
      _errorMessage = '';
    });
    try {
      final summary =
          await _apiService.fetchPointsSummary(); // <--- استدعاء API جلب الملخص
      final redeemable = await _apiService
          .fetchRewardsProducts(); // <--- استدعاء API جلب المنتجات القابلة للاستبدال
      setState(() {
        _pointsSummary = summary;
        _redeemableProducts = redeemable;
      });
    } catch (e) {
      print("Error fetching rewards data: $e");
      setState(() {
        _errorMessage = 'Failed to load rewards data: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingSummary = false;
          _isLoadingRedeemableProducts = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green[700], // لون الـ AppBar أخضر غامق
        elevation: 0,
        leading: const BackButton(color: Colors.white), // زر رجوع أبيض
        title: Text(
          "Welcome to your\nrewards $_currentUserName", // عرض اسم المستخدم
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage("assets/images/logo 2.png"), // صورة الشعار
              width: 96,
              height: 69,
            ),
          )
        ],
      ),
      body: _isLoadingSummary || _isLoadingRedeemableProducts // مؤشر تحميل
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Total Points Card
                    GestureDetector(
                      // جعل الكارت قابل للضغط للذهاب للتاريخ
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const HistoryScreen()), // الانتقال لـ HistoryScreen
                        );
                      },
                      child: Center(
                        child: Container(
                          width: 193, // العرض كما في الصورة
                          height: 80, // الارتفاع كما في الصورة
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
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
                                  border:
                                      Border.all(color: Colors.green, width: 2),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${_pointsSummary?.totalPoints ?? 0} points', // عرض totalPoints من الـ API
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // مسافة أقل بين الكارت والتنبيه

                    // Expiring Points Alert
                    if (_pointsSummary != null &&
                        _pointsSummary!.expiringPoints > 0)
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20), // إزالة vertical margin
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.warning,
                                color: Colors.black), // أيقونة تحذير
                            const SizedBox(width: 10),
                            Expanded(
                              // Added Expanded to prevent overflow
                              child: Text(
                                '${_pointsSummary!.expiringPoints} points are expiring on ${_pointsSummary!.nextExpiryDate != null ? '${_pointsSummary!.nextExpiryDate!.day} ${_getMonthName(_pointsSummary!.nextExpiryDate!.month)} ${_pointsSummary!.nextExpiryDate!.year}' : ''}', //
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20), // مسافة بعد التنبيه

                    // Products you can redeem
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Products you can redeem",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // في ملف RewardsScreen.dart، داخل دالة build
// ...
                    Expanded(
                      child: _redeemableProducts.isEmpty
                          ? const Center(
                              child: Text("No redeemable products available."))
                          : GridView.builder(
                              // أضف هذه السطور:
                              shrinkWrap: true, // <--- هام جداً للـ overflow
                              physics:
                                  const ClampingScrollPhysics(), // <--- هام جداً لتحديد نوع السكرول

                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: _redeemableProducts
                                  .length, // عرض كل المنتجات القابلة للاستبدال من API
                              itemBuilder: (context, index) {
                                final rewardProduct =
                                    _redeemableProducts[index];
                                return RewardItem(
                                    imagePath: rewardProduct.imageUrl,
                                    title: rewardProduct.name,
                                    points: rewardProduct.pointsCost,
                                    onRedeem: (p) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text('Redeem $p (Dummy)')),
                                      );
                                    });
                              },
                            ),
                    ),
                  ],
                ),
    );
  }

  // Helper method to get month name
  String _getMonthName(int month) {
    const List<String> monthNames = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return monthNames[month];
  }
}

// كلاس مساعد لتمثيل عنصر المنتج القابل للاستبدال
class RewardItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final int points;
  final Function(String) onRedeem;

  const RewardItem({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.points,
    required this.onRedeem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Image.network(
            imagePath, height: 100, fit: BoxFit.cover, // استخدام Image.network
            errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/placeholder.png',
                height: 100,
                fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('$points points',
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 5),
                /* ElevatedButton(
                  onPressed: () => onRedeem(title),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Redeem',
                      style: TextStyle(color: Colors.white)),
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}
/*// lib/features/dashboard/modelus/Reward/view/RewardsScreen.dart
import 'package:flutter/material.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart'; // ApiService, PointsSummary, RewardProduct
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Reward/view/HistoryScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/historypoints/pointhistory.dart'; // HistoryScreen

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  final ApiService _apiService = ApiService();
  PointsSummary? _pointsSummary;
  List<RewardProduct> _redeemableProducts =
      []; // قائمة المنتجات القابلة للاستبدال
  bool _isLoadingSummary = true;
  bool _isLoadingRedeemableProducts = true;
  String _errorMessage = '';
  String _currentUserName = "User"; // لاسم المستخدم، يمكن تحديثه من ApiService

  @override
  void initState() {
    super.initState();
    _loadUserName(); // جلب اسم المستخدم عند بدء التشغيل
    _fetchPointsData(); // جلب ملخص النقاط والمنتجات القابلة للاستبدال
  }

  Future<void> _loadUserName() async {
    String? userName =
        await ApiService.getCurrentUserName(); // جلب اسم المستخدم من ApiService
    if (userName != null) {
      setState(() {
        _currentUserName = userName;
      });
    }
  }

  Future<void> _fetchPointsData() async {
    setState(() {
      _isLoadingSummary = true;
      _isLoadingRedeemableProducts = true;
      _errorMessage = '';
    });
    try {
      final summary =
          await _apiService.fetchPointsSummary(); // <--- استدعاء API جلب الملخص
      final redeemable = await _apiService
          .fetchRewardsProducts(); // <--- استدعاء API جلب المنتجات القابلة للاستبدال
      setState(() {
        _pointsSummary = summary;
        _redeemableProducts = redeemable;
      });
    } catch (e) {
      print("Error fetching rewards data: $e");
      setState(() {
        _errorMessage = 'Failed to load rewards data: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingSummary = false;
          _isLoadingRedeemableProducts = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green[700], // لون الـ AppBar أخضر غامق
        elevation: 0,
        leading: const BackButton(color: Colors.white), // زر رجوع أبيض
        title: Text(
          "Welcome to your\nrewards $_currentUserName", // عرض اسم المستخدم
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage("assets/images/logo 2.png"), // صورة الشعار
              width: 96,
              height: 69,
            ),
          )
        ],
      ),
      body: _isLoadingSummary || _isLoadingRedeemableProducts // مؤشر تحميل
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Total Points Card
                    GestureDetector(
                      // جعل الكارت قابل للضغط للذهاب للتاريخ
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const HistoryScreen()), // الانتقال لـ HistoryScreen
                        );
                      },
                      child: Center(
                        child: Container(
                          width: 193, // العرض كما في الصورة
                          height: 80, // الارتفاع كما في الصورة
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
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
                                  border:
                                      Border.all(color: Colors.green, width: 2),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${_pointsSummary?.totalPoints ?? 0} points', // عرض totalPoints من الـ API
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // مسافة أقل بين الكارت والتنبيه

                    // Expiring Points Alert
                    if (_pointsSummary != null &&
                        _pointsSummary!.expiringPoints > 0)
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20), // إزالة vertical margin
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.warning,
                                color: Colors.black), // أيقونة تحذير
                            const SizedBox(width: 10),
                            Expanded(
                              // Added Expanded to prevent overflow
                              child: Text(
                                '${_pointsSummary!.expiringPoints} points are expiring on ${_pointsSummary!.nextExpiryDate != null ? '${_pointsSummary!.nextExpiryDate!.day} ${_getMonthName(_pointsSummary!.nextExpiryDate!.month)} ${_pointsSummary!.nextExpiryDate!.year}' : ''}', //
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20), // مسافة بعد التنبيه

                    // Products you can redeem
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Products you can redeem",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: _redeemableProducts.isEmpty
                          ? const Center(
                              child: Text("No redeemable products available."))
                          : GridView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: _redeemableProducts
                                  .length, // عرض كل المنتجات القابلة للاستبدال من API
                              itemBuilder: (context, index) {
                                final rewardProduct =
                                    _redeemableProducts[index];
                                return RewardItem(
                                    imagePath: rewardProduct
                                        .imageUrl, // استخدام الصورة من API المنتج
                                    title: rewardProduct
                                        .name, // الاسم من API المنتج
                                    points: rewardProduct
                                        .pointsCost, // النقاط من API المنتج
                                    onRedeem: (p) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text('Redeem $p (Dummy)')),
                                      );
                                    });
                              },
                            ),
                    ),
                  ],
                ),
    );
  }

  // Helper method to get month name
  String _getMonthName(int month) {
    const List<String> monthNames = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return monthNames[month];
  }
}

// كلاس مساعد لتمثيل عنصر المنتج القابل للاستبدال
class RewardItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final int points;
  final Function(String) onRedeem;

  const RewardItem({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.points,
    required this.onRedeem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Image.network(
            imagePath, height: 100, fit: BoxFit.cover, // استخدام Image.network
            errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/placeholder.png',
                height: 100,
                fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('$points points',
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () => onRedeem(title),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Redeem',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/historypoints/pointhistory.dart';
import 'package:greanspherproj/features/dashboard/view/dashboardpage.dart';

class RewardsScreen extends StatelessWidget {
  final int totalPoints = 807;
  final int expiringPoints = 298;
  final String expiringDate = '3 May 2025';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Welcome to your\n rewards Batoul Hamdy',
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage("assets/images/logo 2.png"),
              width: 96,
              height: 69,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            },
            child: Center(
              child: Container(
                width: 193,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
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
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "807 points",
                      style: TextStyle(
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
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning, color: Colors.black),
                const SizedBox(width: 10),
                Text('$expiringPoints points are expiring on $expiringDate'),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: const [
                RewardItem(
                  imagePath: "assets/images/logo 2.png",
                  title: 'Logitech Brio 500 Full HD Webcam',
                  points: 680,
                ),
                RewardItem(
                  imagePath: "assets/images/logo 2.png",
                  title: 'Digital TDS Salinity Meter Pen',
                  points: 300,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RewardItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final int points;

  const RewardItem({
    required this.imagePath,
    required this.title,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(child: Image.asset(imagePath, fit: BoxFit.contain)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              '$points points',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
*/
