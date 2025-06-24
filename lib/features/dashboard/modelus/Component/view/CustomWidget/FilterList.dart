// lib/features/dashboard/modelus/Component/view/CustomWidget/FilterList.dart
import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart'; // Import ApiService

class FilterList extends StatefulWidget {
  final Function(String) onFilterSelected;

  FilterList({required this.onFilterSelected});

  @override
  _FilterListState createState() => _FilterListState();
}

class _FilterListState extends State<FilterList> {
  final ApiService _apiService = ApiService();
  List<String> categories = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      List<String> fetchedCategories = await _apiService.fetchCategories();
      setState(() {
        categories = ['All', ...fetchedCategories]; // Add 'All' option
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load categories: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.green));
    }
    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hydroponic component ",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categories.map((filter) {
            return ListTile(
              title: Text(filter,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              onTap: () => widget.onFilterSelected(filter),
            );
          }).toList(),
        ),
      ],
    );
  }
}
/*import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart'; // Import ApiService

class FilterList extends StatefulWidget {
  final Function(String) onFilterSelected;

  FilterList({required this.onFilterSelected});

  @override
  _FilterListState createState() => _FilterListState();
}

class _FilterListState extends State<FilterList> {
  final ApiService _apiService = ApiService();
  List<String> categories = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      List<String> fetchedCategories = await _apiService.fetchCategories();
      setState(() {
        categories = ['All', ...fetchedCategories];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load categories: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.green));
    }
    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hydroponic component ",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categories.map((filter) {
            return ListTile(
              title: Text(filter,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              onTap: () => widget.onFilterSelected(filter),
            );
          }).toList(),
        ),
      ],
    );
  }
}*/
/*import 'package:flutter/material.dart';

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
}*/
