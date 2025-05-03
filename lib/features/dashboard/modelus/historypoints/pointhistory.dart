import 'package:flutter/material.dart';

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
