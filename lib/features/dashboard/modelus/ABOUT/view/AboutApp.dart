import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(),
        title: const Text(
          "About app",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/logo 1.png',
                    height: 85,
                    width: 85,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Hydroponics made simple, Growth made smart.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "GreenSphere isn’t just a gardening app — "
              "it’s your smart companion for growing fresh plants without soil.\n"
              "Whether you’re a beginner or a pro, we’re with you from seed to harvest.\n",
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              "What you’ll find inside:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "• Step-by-step video tutorials:\n"
              "  - Learn how to grow using hydroponics, even if you're just starting out.\n\n"
              "• AI-powered plant diagnosis:\n"
              "  - Snap a photo, and we’ll detect any disease and tell you how to treat it.\n\n"
              "• Growth tracking & smart notifications:\n"
              "  - Get reminders when it’s time to water, feed, or harvest your plant.\n\n"
              "• In-app store:\n"
              "  - Buy all your hydroponic components and tools right from the app.\n\n"
              "• Points system:\n"
              "  - Earn points every time you buy components, and unlock special offers and rewards!\n\n"
              "• Smart chatbot (Sprouty):\n"
              "  - Ask anything at any time — we’re always here to help.\n",
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                text: 'From the first sprout to full harvest, ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'GreenSphere grows with you.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  "Let’s grow the future, together. ",
                  style: TextStyle(fontSize: 16),
                ),
                Image.asset(
                  'assets/images/greenlogo.png',
                  height: 24,
                  width: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
