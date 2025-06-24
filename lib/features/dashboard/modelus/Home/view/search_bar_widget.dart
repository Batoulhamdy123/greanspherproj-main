// lib/features/dashboard/modelus/Home/view/search_bar_widget.dart
import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/CartPage/view/cartScreen.dart';

import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Favourite/view/Favourite.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Favourite/view/FavouriteScreen.dart'; // FavouriteScreen
import 'package:greanspherproj/features/dashboard/modelus/Component/view/ComponentPage.dart'; // ComponentPageState for static access

class SearchBarWidget extends StatefulWidget {
  // <--- أصبحت StatefulWidget
  final List<Product> cartItems; // قائمة عناصر السلة
  final List<Product> favoriteItems; // قائمة المفضلة
  final VoidCallback onFilterToggle; // for filter dropdown
  final Function(String) onSearchSubmitted; // for search bar submission

  // Callbacks for favorite/cart actions (optional, if this SearchBar triggers them)
  final Function(Product) onFavoriteRemoved;
  final VoidCallback onClearAllFavorites;

  const SearchBarWidget({
    Key? key,
    this.cartItems = const [],
    this.favoriteItems = const [],
    required this.onFilterToggle,
    required this.onSearchSubmitted,
    // هذه الدوال ستأتي من ComponentPage
    this.onFavoriteRemoved = _defaultOnFavoriteRemoved,
    this.onClearAllFavorites = _defaultOnClearAllFavorites,
    required bool isFilterExpanded,
    required Null Function(dynamic filter) onFilterSelected,
  }) : super(key: key);

  // دوال افتراضية لـ callbacks لتجنب الأخطاء إذا لم يتم تمريرها
  static void _defaultOnFavoriteRemoved(Product p) {
    print("Default onFavoriteRemoved called for ${p.name}");
  }

  static void _defaultOnClearAllFavorites() {
    print("Default onClearAllFavorites called");
  }

  // هذه الخصائص لم تعد تستخدم في هذه النسخة من SearchBarWidget
  // final Function(String) onFilterSelected;
  // final bool isFilterExpanded;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  int _apiCartCount = 0; // لعرض عدد العناصر في أيقونة السلة

  @override
  void initState() {
    super.initState();
    _fetchApiCartCount(); // جلب العدد فور تحميل الـ widget
  }

  Future<void> _fetchApiCartCount() async {
    try {
      int count = await _apiService.fetchCartItemCount();
      if (mounted) {
        setState(() {
          _apiCartCount = count;
        });
      }
    } catch (e) {
      print("Failed to fetch API cart count in search bar: $e");
      if (mounted) {
        setState(() {
          _apiCartCount = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          // شعار التطبيق
          "assets/images/logo 1.png",
          width: 85,
          height: 85,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _searchController,
            textAlign: TextAlign.center, // وسط النص
            decoration: InputDecoration(
              hintText: "Hinted search text",
              suffixIcon: const Icon(
                // أيقونة البحث
                Icons.search,
                color: Colors.green,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30)), // حدود دائرية
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onSubmitted: (value) {
              widget.onSearchSubmitted(value);
            },
          ),
        ),
        // الأيقونات على اليمين (السلة والمفضلة)
      ],
    );
  }
}
