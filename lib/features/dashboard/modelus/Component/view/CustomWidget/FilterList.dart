import 'package:flutter/material.dart';

class FilterList extends StatelessWidget {
  final Function(String) onFilterSelected;

  FilterList({required this.onFilterSelected});

  // خريطة تحتوي على الصور المخصصة لكل عنصر
  final Map<String, String> filterIcons = {
    'Best seller': 'assets/images/bestseller.png',
    'Nutrients': 'assets/images/nuitrines.png',
    'Cameras': 'assets/images/camera.png',
    'Air pump': 'assets/images/air_pump.png',
    'Water pump': 'assets/images/water_pump.png',
    'Water tank': 'assets/images/water_tank.png',
    'Tools': 'assets/images/tools.png',
  };

  @override
  Widget build(BuildContext context) {
    List<String> filters = filterIcons.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hydroponic component ",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: filters.map((filter) {
            return ListTile(
              leading: Image.asset(
                filterIcons[filter]!,
                width: 20, // ضبط حجم الصورة
                height: 20,
              ),
              title:
                  Text(filter, style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () => onFilterSelected(filter),
            );
          }).toList(),
        ),
      ],
    );
  }
}
