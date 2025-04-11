import 'package:flutter/material.dart';

class FeaturedCardWidget extends StatelessWidget {
  final String title;
  final String imagePath;

  const FeaturedCardWidget({
    Key? key,
    required this.title,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
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
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/*import 'package:flutter/material.dart';

class FeaturedCardWidget extends StatelessWidget {
  final String title;
  final String imagePath;

  const FeaturedCardWidget({
    Key? key,
    required this.title,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            padding: EdgeInsets.all(6),
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: Icon(Icons.play_circle_fill, color: Colors.white),
        ),
      ],
    );
  }
}
*/
