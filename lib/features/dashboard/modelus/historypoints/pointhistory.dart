// lib/features/dashboard/modelus/Reward/view/HistoryScreen.dart
import 'package:flutter/material.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart'; // استيراد ApiService
// تأكد من أن هذا هو الاستيراد الصحيح لـ models النقاط من app_api_service.dart
// لا تحتاج لاستيراد reward_models.dart بشكل منفصل إذا كانت موجودة في app_api_service.dart

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();
  PointsSummary? _pointsSummary; // لملخص النقاط في الأعلى
  List<PointHistoryItem> _allHistory = []; // لكل السجلات
  bool _isLoadingSummary = true;
  bool _isLoadingHistory = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchData(); // جلب البيانات عند بدء تشغيل الشاشة
  }

  // دالة لجلب ملخص النقاط وتاريخها من الـ API
  Future<void> _fetchData() async {
    setState(() {
      _isLoadingSummary = true;
      _isLoadingHistory = true;
      _errorMessage = '';
    });
    try {
      // جلب ملخص النقاط
      final summary =
          await _apiService.fetchPointsSummary(); // <--- استدعاء API جلب الملخص
      // جلب تاريخ النقاط
      final history = await _apiService
          .fetchPointsHistory(); // <--- استدعاء API جلب التاريخ

      setState(() {
        _pointsSummary = summary;
        _allHistory = history;
      });
    } catch (e) {
      print("Error fetching history data: $e"); // طباعة الخطأ في الـ Console
      setState(() {
        _errorMessage = 'Failed to load history: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingSummary = false;
          _isLoadingHistory = false;
        });
      }
    }
  }

  // دالة لفلترة سجل النقاط بناءً على التاب المختار
  List<PointHistoryItem> _getFilteredHistory(String filterType) {
    switch (filterType) {
      case 'All':
        return _allHistory;
      case 'Earned':
        return _allHistory
            .where((item) => !item.isSpent && !item.isExpired)
            .toList(); // "Earned" means not spent and not expired
      case 'Spent':
        return _allHistory
            .where((item) => item.isSpent)
            .toList(); // "Spent" means isSpent is true
      default:
        return [];
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // استخدام SafeArea لتجنب التداخل مع شريط الحالة
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row for back button and title
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'History',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Points area (Total Points, Expiring Points)
            Padding(
              padding: const EdgeInsets.only(left: 39, right: 16.0),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _isLoadingSummary // مؤشر تحميل لملخص النقاط
                            ? const CircularProgressIndicator(
                                color: Colors.green, strokeWidth: 2)
                            : Text(
                                '${_pointsSummary?.totalPoints ?? 0} points', // عرض totalPoints من الـ API
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                        if (_pointsSummary != null &&
                            _pointsSummary!.expiringPoints > 0)
                          Text(
                            '${_pointsSummary!.expiringPoints} points are expiring on ${_pointsSummary!.nextExpiryDate != null ? '${_pointsSummary!.nextExpiryDate!.day} ${_getMonthName(_pointsSummary!.nextExpiryDate!.month)} ${_pointsSummary!.nextExpiryDate!.year}' : ''}', // عرض النقاط المنتهية الصلاحية
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // TabBar
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.black,
              labelStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Earned'),
                Tab(text: 'Spent'),
              ],
            ),

            // TabBarView
            Expanded(
              child: _isLoadingHistory // مؤشر تحميل لتاريخ النقاط
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.green))
                  : _errorMessage.isNotEmpty
                      ? Center(child: Text(_errorMessage))
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            _buildHistoryList(_getFilteredHistory('All')),
                            _buildHistoryList(_getFilteredHistory('Earned')),
                            _buildHistoryList(_getFilteredHistory('Spent')),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  // بناء قائمة سجل النقاط
  Widget _buildHistoryList(List<PointHistoryItem> items) {
    if (items.isEmpty) {
      return const Center(
          child: Text('No activity yet', style: TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.activityType, // نوع النشاط (Gift, Spend)
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      item.description ?? '', // وصف النشاط
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Text(
                      '${item.earnedDate.day} ${_getMonthName(item.earnedDate.month)} ${item.earnedDate.year}', // تاريخ النشاط
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                Text(
                  '${item.isSpent ? '-' : '+'}${item.points}', // +/- النقاط
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: item.isSpent ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
/*import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row for back button and title
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.green),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 8),
                    Text(
                      'History',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Points area
              Padding(
                padding: const EdgeInsets.only(left: 39),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '807 points',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '298 points are expiring on 3 may 2025',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // TabBar
              TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.black,
                labelStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'Earned'),
                  Tab(text: 'Spent'),
                ],
              ),

              // TabBarView
              Expanded(
                child: TabBarView(
                  children: [
                    Center(child: Text('No activity yet')), // All
                    Center(child: Text('Earned Points List Here')), // Earned
                    Center(child: Text('Spent Points List Here')), // Spent
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
