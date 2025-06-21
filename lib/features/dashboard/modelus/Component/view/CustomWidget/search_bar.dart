// lib/features/dashboard/modelus/Component/view/CustomWidget/search_bar.dart
import 'package:flutter/material.dart';
//import 'package:greanspherproj/features/dashboard/modelus/CartPage/cartScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/CartPage/view/cartScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Favourite/view/Favourite.dart';
// تأكد أن هذا هو الاستيراد الوحيد لملف الـ models والـ services الجديد
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';

class SearchBarWidget extends StatefulWidget {
  // تم تحويلها إلى StatefulWidget
  final VoidCallback onFilterToggle;
  final Function(String) onFilterSelected;
  final Function(String) onSearchSubmitted;
  final bool isFilterExpanded;
  final List<Product>
      cartItems; // هذه القائمة لن تُستخدم، الـ SearchBar الآن ستجلب العدد من الـ API
  final List<Product> favoriteItems;

  const SearchBarWidget({
    Key? key,
    required this.onFilterToggle,
    required this.onFilterSelected,
    required this.onSearchSubmitted,
    required this.isFilterExpanded,
    required this.cartItems, //
    required this.favoriteItems,
  }) : super(key: key);

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

  // جلب عدد عناصر السلة من الـ API
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
        Stack(
          children: [
            IconButton(
              icon: const ImageIcon(
                AssetImage("assets/images/markerbasket.png"),
                size: 35,
                color: Colors.green,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(
                      // نمرر قوائم فارغة ودوال وهمية هنا
                      cartItems: [],
                      onRemoveFromCart: (product) {},
                      onAddToCart: (product, {quantity = 1}) {},
                    ),
                  ),
                ).then((_) {
                  // تحديث عدد السلة بعد العودة من شاشة السلة
                  _fetchApiCartCount();
                });
              },
            ),
            if (_apiCartCount > 0) // استخدام العدد من الـ API للعرض
              Positioned(
                right: 5,
                top: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 10,
                  child: Text(
                    '$_apiCartCount',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.green),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavouriteScreen(),
                  ),
                );
              },
            ),
            if (widget.favoriteItems.isNotEmpty)
              Positioned(
                right: 5,
                top: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 10,
                  child: Text(
                    '${widget.favoriteItems.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: Icon(
                  widget.isFilterExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 35,
                ),
                onPressed: widget.onFilterToggle,
              ),
              hintText: 'Search products...',
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.green,
                ),
                onPressed: () {
                  widget.onSearchSubmitted(_searchController.text);
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onSubmitted: (value) {
              widget.onSearchSubmitted(value);
            },
          ),
        ),
      ],
    );
  }
}
/*// lib/features/dashboard/modelus/Component/view/CustomWidget/search_bar.dart
import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/CartPage/view/cartScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Favourite/view/Favourite.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/Component_data.dart';

// lib/features/dashboard/modelus/Component/view/CustomWidget/search_bar.dart
import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/CartPage/view/cartScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Favourite/view/Favourite.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/Component_data.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback onFilterToggle;
  final Function(String) onFilterSelected;
  final Function(String) onSearchSubmitted;
  final bool isFilterExpanded;
  final List<Product> cartItems;
  final List<Product> favoriteItems;

  SearchBarWidget({
    Key? key,
    required this.onFilterToggle,
    required this.onFilterSelected,
    required this.onSearchSubmitted,
    required this.isFilterExpanded,
    required this.cartItems,
    required this.favoriteItems,
  }) : super(key: key);

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            IconButton(
              icon: const ImageIcon(
                AssetImage("assets/images/markerbasket.png"),
                size: 35,
                color: Colors.green,
              ),
              onPressed: () {
                // Navigate to CartScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(
                      cartItems: cartItems,
                      onRemoveFromCart: (product) {
                        // This callback needs to be handled by ComponentPage
                        // You might need to pass a context or a direct function from ComponentPage
                        // For now, it's a placeholder. The remove logic is in ComponentPage.
                      }, onAddToCart: (Product , int quantity) {  },
                     
                    ),
                  ),
                );
              },
            ),
            if (cartItems.isNotEmpty)
              Positioned(
                right: 5,
                top: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 10,
                  child: Text(
                    '${cartItems.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.green),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavouriteScreen(),
                  ),
                );
              },
            ),
            if (favoriteItems.isNotEmpty)
              Positioned(
                right: 5,
                top: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 10,
                  child: Text(
                    '${favoriteItems.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: Icon(
                  isFilterExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 35,
                ),
                onPressed: onFilterToggle,
              ),
              hintText: 'Search products...',
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.green,
                ),
                onPressed: () {
                  onSearchSubmitted(_searchController.text);
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onSubmitted: (value) {
              onSearchSubmitted(value);
            },
          ),
        ),
      ],
    );
  }
}*/
/*class SearchBarWidget extends StatelessWidget {
  final VoidCallback onFilterToggle;
  final Function(String) onFilterSelected;
  final Function(String) onSearchSubmitted; // New callback for search
  final bool isFilterExpanded;
  final List<Product> cartItems;
  final List<Product> favoriteItems;

  SearchBarWidget({
    Key? key, // Added Key parameter
    required this.onFilterToggle,
    required this.onFilterSelected,
    required this.onSearchSubmitted, // Initialize new callback
    required this.isFilterExpanded,
    required this.cartItems,
    required this.favoriteItems,
  }) : super(key: key); // Pass key to super

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            IconButton(
              icon: const ImageIcon(
                AssetImage("assets/images/markerbasket.png"),
                size: 35,
                color: Colors.green,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(
                      cartItems: cartItems,
                      onRemoveFromCart: (product) {
                        // This callback needs to be handled by ComponentPage
                        // You'll need a way to pass this back up if CartPage allows removing items.
                        // For simplicity in this context, it's a placeholder.
                      },
                    ),
                  ),
                );
              },
            ),
            if (cartItems.isNotEmpty)
              Positioned(
                right: 5,
                top: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 10,
                  child: Text(
                    '${cartItems.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.green),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FavouriteScreen(), // Pass favorite items to FavouriteScreen
                  ),
                );
              },
            ),
            if (favoriteItems.isNotEmpty)
              Positioned(
                right: 5,
                top: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 10,
                  child: Text(
                    '${favoriteItems.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: Icon(
                  isFilterExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 35,
                ),
                onPressed: onFilterToggle,
              ),
              hintText: 'Search products...', // Updated hint text
              suffixIcon: IconButton(
                // Made search icon an IconButton
                icon: const Icon(
                  Icons.search,
                  color: Colors.green,
                ),
                onPressed: () {
                  onSearchSubmitted(_searchController.text);
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onSubmitted: (value) {
              onSearchSubmitted(value); // Use the new callback for submission
            },
          ),
        ),
      ],
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/CartPage/cartScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Favourite/view/Favourite.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/product_data.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback onFilterToggle;
  final Function(String) onFilterSelected;
  final bool isFilterExpanded;
  final List<Product> cartItems;
  final List<Product> favoriteItems;

  SearchBarWidget({
    required this.onFilterToggle,
    required this.onFilterSelected,
    required this.isFilterExpanded,
    required this.cartItems,
    required this.favoriteItems,
  });

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            IconButton(
              icon: const ImageIcon(
                AssetImage("assets/images/markerbasket.png"),
                size: 35,
                color: Colors.green,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(
                      cartItems: cartItems,
                      onRemoveFromCart: (Product) {},
                    ),
                  ),
                );
              },
            ),
            if (cartItems.isNotEmpty)
              Positioned(
                right: 5,
                top: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 10,
                  child: Text(
                    '${cartItems.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.green),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavouriteScreen(),
                  ),
                );
              },
            ),
            if (favoriteItems.isNotEmpty)
              Positioned(
                right: 5,
                top: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 10,
                  child: Text(
                    '${favoriteItems.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: Icon(
                  isFilterExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 35,
                ),
                onPressed: onFilterToggle,
              ),
              hintText: 'Hinted search text',
              suffixIcon: const Icon(
                Icons.search,
                color: Colors.green,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                onFilterSelected(value);
              }
            },
          ),
        ),
      ],
    );
  }
}
*/
