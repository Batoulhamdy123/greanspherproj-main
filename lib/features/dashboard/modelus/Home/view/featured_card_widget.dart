// lib/features/dashboard/modelus/Home/view/featured_card_widget.dart
import 'package:flutter/material.dart';

class FeaturedCardWidget extends StatelessWidget {
  final String title;
  final String imagePath;
  final String? categoryName; // جديد: لعرض اسم الكاتيجوري

  const FeaturedCardWidget({
    super.key,
    required this.title,
    required this.imagePath,
    this.categoryName, // ليس مطلوباً دائماً
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  // استخدام Image.network لصور الـ API
                  imagePath,
                  width: double.infinity,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/placeholder_video.png',
                      width: double.infinity,
                      height: 80,
                      fit: BoxFit.cover), // صورة بديلة
                ),
              ),
              const Positioned(
                // زر تشغيل الفيديو (وهمي)
                top: 50,
                right: 6,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.play_circle_fill,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              // استخدام Column لعرض الـ title والـ category
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (categoryName != null) // عرض اسم الكاتيجوري لو موجود
                  Text(
                    categoryName!,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
