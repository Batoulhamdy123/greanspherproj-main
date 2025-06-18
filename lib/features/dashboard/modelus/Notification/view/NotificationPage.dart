import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController =
      TextEditingController(); // متحكم في النص داخل البحث

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ✅ إضافة مسافة قبل شريط البحث
          const SizedBox(height: 40),

          // ✅ شريط البحث
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200, // خلفية رمادية فاتحة
                borderRadius: BorderRadius.circular(40),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: _searchController,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    hintText: "Hinted search text",

                    border: InputBorder.none,
                    suffixIcon:
                        Icon(Icons.search, color: Colors.green), // أيقونة البحث
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20), // ✅ إضافة مسافة بعد شريط البحث

          // ✅ عنوان "Notifications"
          Column(
            children: [
              Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Image.asset(
                "assets/images/notificationline.png",
                height: 12,
                width: 99,
              )
            ],
          ),
          const SizedBox(height: 10), // ✅ مسافة بين العنوان و التابات

          // ✅ شريط التصفية (Tabs)
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.green,
            indicatorWeight: 4,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "Updates"),
              Tab(text: "Diseases"),
              Tab(text: "Rewards"),
            ],
          ),

          // 🔽 خط فاصل بين التابات والمحتوى
          Divider(color: Colors.grey.shade300, thickness: 1),

          // 📌 محتوى كل Tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEmptyContent("Updates Section"),
                _buildEmptyContent("Diseases Section"),
                _buildEmptyContent("Rewards Section"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyContent(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
