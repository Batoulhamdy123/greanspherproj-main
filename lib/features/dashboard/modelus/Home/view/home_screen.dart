import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/chatbot/chatbotpage.dart';
import 'search_bar_widget.dart';
import 'featured_card_widget.dart';

class HomeScreen extends StatelessWidget {
  final List<String> featuredTitles = [
    "Hydroponic Plant Diseases",
    "Hydroponics Guide",
    "Hydroponic Components&Usage",
    "Hydroponic Updates&Rewards Notifications"
  ];

  final List<String> imagePaths = [
    'assets/images/hydropolicplant.png',
    'assets/images/hydropolicguide.png',
    'assets/images/hydropolicusage.png',
    'assets/images/hydropolicupdate.png',
  ];
  final List<String> horizontalImages = [
    'assets/images/scroll1.png',
    'assets/images/scroll2.png',
    'assets/images/scroll3.png',
  ];

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarWidget(),

                  SizedBox(height: 10),

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
                          margin: EdgeInsets.only(right: 8),
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

                  SizedBox(height: 20),

                  // 🌱 Rewards
                  RichText(
                    text: TextSpan(
                      text: 'Your ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: 'GreenSphere ',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text: 'Rewards',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
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

                  SizedBox(height: 15),

                  // 🎬 Featured Content
                  Row(
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
                  SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: featuredTitles.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      return FeaturedCardWidget(
                        title: featuredTitles[index],
                        imagePath: imagePaths[index],
                      );
                    },
                  ),
                  SizedBox(height: 80), // عشان نسيب مساحة للزر
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
}
