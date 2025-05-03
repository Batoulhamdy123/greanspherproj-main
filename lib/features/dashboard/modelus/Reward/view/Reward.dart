import 'package:flutter/material.dart';
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
