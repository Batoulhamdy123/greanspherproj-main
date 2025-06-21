// lib/features/dashboard/modelus/Component/ComponentPage.dart
import 'package:flutter/material.dart';
//import 'package:greanspherproj/features/dashboard/modelus/CartPage/cartScreen.dart'; // تأكد من صحة هذا الاستيراد
// تأكد أن هذا هو الاستيراد الوحيد لملف الـ models والـ services الجديد
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/FilterList.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/ProductGrid.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/search_bar.dart';

class ComponentPage extends StatefulWidget {
  @override
  ComponentPageState createState() => ComponentPageState();
}

class ComponentPageState extends State<ComponentPage> {
  String selectedFilter = '';
  bool isFilterExpanded = false;
  List<Product> favoriteProducts = []; // المفضلة ستظل محلية هنا
  // لا نحتاج لـ cartProducts هنا لأن CartScreen ستجلب بياناتها من الـ API مباشرة
  // والـ ProductGrid ستستخدم بيانات المنتجات العامة لتحديد isInCart

  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String _errorMessage = '';
  List<Product> allProducts = []; // قائمة المنتجات الرئيسية التي يتم جلبها
  List<Product> displayedProducts = []; // المنتجات المعروضة بعد الفلترة
  List<CartItem> _currentBasketItems =
      []; // لتتبع عناصر السلة من الـ API (لضبط isInCart)

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchBasketItemsForStatus(); // جلب عناصر السلة لضبط حالة isInCart
  }

  // جلب المنتجات الرئيسية من الـ API
  Future<void> _fetchProducts(
      {String? productName, String endpoint = '/api/v1/products'}) async {
    // تم تحديد القيمة الافتراضية هنا
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      List<Product> fetchedProducts = await _apiService.fetchProducts(
          productName: productName,
          endpoint: endpoint); // استخدام البارامتر endpoint
      setState(() {
        allProducts = fetchedProducts;
        _applyFilter();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load products: $e';
        _isLoading = false;
      });
    }
  }

  // جلب عناصر السلة لتحديث حالة isInCart للمنتجات في Grid
  Future<void> _fetchBasketItemsForStatus() async {
    try {
      List<CartItem> fetchedItems = await _apiService.fetchBasketItems();
      setState(() {
        _currentBasketItems = fetchedItems;
        // تحديث حالة isInCart للمنتجات في قائمة allProducts
        for (var product in allProducts) {
          product.isInCart =
              _currentBasketItems.any((item) => item.product.id == product.id);
        }
      });
    } catch (e) {
      print("Failed to fetch basket items for status update: $e");
      // لا تعرض SnackBar هنا لتجنب تكرار الرسائل في الشاشة الرئيسية.
    }
  }

  // فلترة المنتجات المعروضة
  void _applyFilter() {
    setState(() {
      if (selectedFilter.isEmpty || selectedFilter == 'All') {
        displayedProducts = allProducts;
      } else {
        displayedProducts =
            allProducts.where((p) => p.category == selectedFilter).toList();
      }
    });
  }

  // وظيفة التبديل بين المفضلة
  void toggleFavorite(Product product) {
    setState(() {
      if (favoriteProducts.contains(product)) {
        favoriteProducts.remove(product);
      } else {
        favoriteProducts.add(product);
      }
    });
  }

  // دوال الإضافة/الحذف التي ستتفاعل مع الـ API مباشرة
  Future<void> _handleAddToCart(Product product, {int quantity = 1}) async {
    try {
      await _apiService.addProductToBasket(
          product.id, quantity); // استدعاء API الإضافة الحقيقية
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} added to cart successfully!')),
      );
      await _fetchBasketItemsForStatus(); // تحديث حالة isInCart بعد الإضافة
      // يمكن أيضاً تحديث badge السلة في الـ SearchBar (لو تم تحويلها إلى StatefulWidget)
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add ${product.name} to cart: $e')),
      );
      print("Error adding to cart from ComponentPage: $e");
    }
  }

  Future<void> _handleRemoveFromCart(Product product) async {
    try {
      await _apiService
          .removeProductFromBasket(product.id); // استدعاء API الحذف الحقيقي
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} removed from cart.')),
      );
      await _fetchBasketItemsForStatus(); // تحديث حالة isInCart بعد الحذف
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to remove ${product.name} from cart: $e')),
      );
      print("Error removing from cart from ComponentPage: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: SearchBarWidget(
          onFilterToggle: () {
            setState(() {
              isFilterExpanded = !isFilterExpanded;
            });
          },
          onFilterSelected: (filter) {
            setState(() {
              selectedFilter = filter;
              isFilterExpanded = false;
            });
            _applyFilter();
          },
          onSearchSubmitted: (query) {
            _fetchProducts(productName: query);
          },
          isFilterExpanded: isFilterExpanded,
          // نمرر هنا قائمة المنتجات العامة الموجودة في السلة لتحديد isInCart في ProductItem
          // SearchBarWidget سيجلب العدد الخاص به من الـ API مباشرة.
          cartItems: _currentBasketItems
              .map((ci) => ci.product)
              .toList(), // لتحديد isInCart في ProductItem
          favoriteItems: favoriteProducts,
        ),
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.green))
              : _errorMessage.isNotEmpty
                  ? Center(child: Text(_errorMessage))
                  : ProductGrid(
                      products: displayedProducts,
                      onFavoriteToggle: toggleFavorite,
                      onAddToCart:
                          _handleAddToCart, // استخدام دالة الـ API الحقيقية
                      onRemoveFromCart:
                          _handleRemoveFromCart, // استخدام دالة الـ API الحقيقية
                      favoriteProducts: favoriteProducts,
                      cartProducts: _currentBasketItems
                          .map((ci) => ci.product)
                          .toList(), // لتحديد isInCart في ProductItem
                    ),
          if (isFilterExpanded)
            Positioned(
              top: kToolbarHeight,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 5),
                  ],
                ),
                child: FilterList(onFilterSelected: (filter) {
                  setState(() {
                    selectedFilter = filter;
                    isFilterExpanded = false;
                  });
                  _applyFilter();
                }),
              ),
            ),
        ],
      ),
    );
  }
}
/*// lib/features/dashboard/modelus/Component/ComponentPage.dart
import 'package:flutter/material.dart';
//import 'package:greanspherproj/features/dashboard/modelus/CartPage/cartScreen.dart';
// تأكد أن هذا هو الاستيراد الوحيد لملف الـ models والـ services الجديد
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/FilterList.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/ProductGrid.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/search_bar.dart';

class ComponentPage extends StatefulWidget {
  @override
  ComponentPageState createState() => ComponentPageState();
}

class ComponentPageState extends State<ComponentPage> {
  String selectedFilter = '';
  bool isFilterExpanded = false;
  List<Product> favoriteProducts = []; // المفضلة ستظل محلية هنا
  // لا نحتاج لـ cartProducts هنا لأن CartScreen ستجلب بياناتها من الـ API مباشرة
  // والـ ProductGrid ستستخدم بيانات المنتجات العامة لتحديد isInCart

  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String _errorMessage = '';
  List<Product> allProducts = []; // قائمة المنتجات الرئيسية التي يتم جلبها
  List<Product> displayedProducts = []; // المنتجات المعروضة بعد الفلترة

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    // لا نحتاج لاستدعاء _fetchBasketItems هنا لأن CartScreen ستجلبها بنفسها.
  }

  // جلب المنتجات الرئيسية من الـ API
  Future<void> _fetchProducts(
      {String? productName, String endpoint = '/api/v1/products'}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      // استخدام البارامتر endpoint لمرونة جلب المنتجات من /api/Product أو /api/v1/products
      List<Product> fetchedProducts = await _apiService.fetchProducts(
          productName: productName, endpoint: endpoint);
      setState(() {
        allProducts = fetchedProducts;
        _applyFilter();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load products: $e';
        _isLoading = false;
      });
    }
  }

  // فلترة المنتجات المعروضة
  void _applyFilter() {
    setState(() {
      if (selectedFilter.isEmpty || selectedFilter == 'All') {
        displayedProducts = allProducts;
      } else {
        displayedProducts =
            allProducts.where((p) => p.category == selectedFilter).toList();
      }
    });
  }

  // وظيفة التبديل بين المفضلة
  void toggleFavorite(Product product) {
    setState(() {
      if (favoriteProducts.contains(product)) {
        favoriteProducts.remove(product);
      } else {
        favoriteProducts.add(product);
      }
    });
  }

  // دوال الإضافة/الحذف "الوهمية" لـ ProductGrid
  // هذه الدوال تقوم بمحاكاة السلوك محلياً لغرض عرض الواجهة فقط
  // في المستقبل، يجب استبدال محتواها باستدعاءات API حقيقية.
  void _dummyAddToCart(Product product, {int quantity = 1}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Dummy: Added ${product.name} (qty: $quantity) to cart. (Not real API call)')),
    );
    // في حالة تفعيل API الإضافة، هنا ستكون دالة apiService.addProductToBasket
    // ثم يجب عليك تحديث الـ badge في الـ SearchBar (عبر استدعاء fetchCartItemCount)
  }

  void _dummyRemoveFromCart(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Dummy: Removed ${product.name} from cart. (Not real API call)')),
    );
    // في حالة تفعيل API الحذف، هنا ستكون دالة apiService.removeProductFromBasket
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: SearchBarWidget(
          onFilterToggle: () {
            setState(() {
              isFilterExpanded = !isFilterExpanded;
            });
          },
          onFilterSelected: (filter) {
            setState(() {
              selectedFilter = filter;
              isFilterExpanded = false;
            });
            _applyFilter();
          },
          onSearchSubmitted: (query) {
            _fetchProducts(productName: query);
          },
          isFilterExpanded: isFilterExpanded,
          // هنا نمرر قائمة المنتجات من الـ API مباشرة (لإظهار Badge الكمية من الـ API)
          cartItems: [], // هذه القائمة لن تُستخدم، الـ SearchBar الآن ستجلب العدد من الـ API
          favoriteItems: favoriteProducts,
        ),
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.green))
              : _errorMessage.isNotEmpty
                  ? Center(child: Text(_errorMessage))
                  : ProductGrid(
                      products: displayedProducts,
                      onFavoriteToggle: toggleFavorite,
                      onAddToCart: _dummyAddToCart, // استخدام الدوال الوهمية
                      onRemoveFromCart:
                          _dummyRemoveFromCart, // استخدام الدوال الوهمية
                      favoriteProducts: favoriteProducts,
                      // نمرر قائمة المنتجات العامة هنا، الـ ProductItem سيحدد isInCart بناءً عليها
                      cartProducts: [], // لا نحتاج لـ cartProducts هنا بعد الآن، لأن ProductItem سيعتمد علىIsInCart الخاص به
                    ),
          if (isFilterExpanded)
            Positioned(
              top: kToolbarHeight,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 5),
                  ],
                ),
                child: FilterList(onFilterSelected: (filter) {
                  setState(() {
                    selectedFilter = filter;
                    isFilterExpanded = false;
                  });
                  _applyFilter();
                }),
              ),
            ),
        ],
      ),
    );
  }
}*/
/*// lib/features/dashboard/modelus/Component/ComponentPage.dart
import 'package:flutter/material.dart';
//import 'package:greanspherproj/features/dashboard/modelus/CartPage/cartScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/Component_data.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/FilterList.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/ProductGrid.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/search_bar.dart';

import '../../CartPage/model/product_data.dart';

class ComponentPage extends StatefulWidget {
  @override
  ComponentPageState createState() => ComponentPageState();
}

class ComponentPageState extends State<ComponentPage> {
  String selectedFilter = '';
  bool isFilterExpanded = false;
  List<Product> favoriteProducts = []; // Favorites still local for now
  List<CartItem> cartItems = []; // Stores CartItem objects from API (initially)
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String _errorMessage = '';
  List<Product> allProducts = [];
  List<Product> displayedProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchBasketItems(); // Fetch basket items on app start
  }

  // --- API Interaction Methods (Only Get for now) ---

  Future<void> _fetchProducts({String? productName}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      List<Product> fetchedProducts = await _apiService.fetchProducts(productName: productName);
      setState(() {
        allProducts = fetchedProducts;
        _applyFilter();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load products: $e';
        _isLoading = false;
      });
    }
  }

  // Fetch basket items to set isInCart for main grid
  Future<void> _fetchBasketItems() async {
    try {
      List<CartItem> fetchedCartItems = await _apiService.fetchBasketItems();
      setState(() {
        cartItems = fetchedCartItems; // Update the cartItems list
        // Update isInCart status for products displayed in ProductGrid
        for (var product in allProducts) {
          product.isInCart = cartItems.any((item) => item.product.id == product.id);
        }
      });
    } catch (e) {
      print("Failed to fetch basket items: $e");
      // Handle error, e.g., show a toast
    }
  }

  // --- Dummy Add/Remove for ProductGrid/ProductDetails (as POST/DELETE not implemented yet) ---
  // When you implement POST/DELETE APIs, these methods would call the API
  void _dummyAddToCart(Product product, {int quantity = 1}) {
    // This function now only prints a message.
    // In a real app, this would call _apiService.addProductToBasket(product.id, quantity);
    print('Dummy: Added ${product.name} (qty: $quantity) to cart.');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dummy: Added ${product.name} to cart. (Not real API call)')),
    );
    // After a real API call, you would call _fetchBasketItems();
  }

  void _dummyRemoveFromCart(Product product) {
    // This function now only prints a message.
    // In a real app, this would call _apiService.removeProductFromBasket(product.id);
    print('Dummy: Removed ${product.name} from cart.');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dummy: Removed ${product.name} from cart. (Not real API call)')),
    );
    // After a real API call, you would call _fetchBasketItems();
  }


  // --- Local UI Management Methods ---

  void _applyFilter() {
    setState(() {
      if (selectedFilter.isEmpty || selectedFilter == 'All') {
        displayedProducts = allProducts;
      } else {
        displayedProducts = allProducts.where((p) => p.category == selectedFilter).toList();
      }
    });
  }

  void toggleFavorite(Product product) {
    setState(() {
      if (favoriteProducts.contains(product)) {
        favoriteProducts.remove(product);
      } else {
        favoriteProducts.add(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: SearchBarWidget(
          onFilterToggle: () {
            setState(() {
              isFilterExpanded = !isFilterExpanded;
            });
          },
          onFilterSelected: (filter) {
            setState(() {
              selectedFilter = filter;
              isFilterExpanded = false;
            });
            _applyFilter();
          },
          onSearchSubmitted: (query) {
            _fetchProducts(productName: query);
          },
          isFilterExpanded: isFilterExpanded,
          // Pass the list of Products (extracted from CartItem) for the badge count
          cartItems: cartItems.map((ci) => ci.product).toList(), // Still needs Product for SearchBar badge
          favoriteItems: favoriteProducts,
        ),
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.green))
              : _errorMessage.isNotEmpty
                  ? Center(child: Text(_errorMessage))
                  : ProductGrid(
                      products: displayedProducts,
                      onFavoriteToggle: toggleFavorite,
                      onAddToCart: _dummyAddToCart, // Use the dummy method
                      onRemoveFromCart: _dummyRemoveFromCart, // Use the dummy method
                      favoriteProducts: favoriteProducts,
                      // Pass the list of Products (extracted from CartItem) for isInCart status
                      cartProducts: cartItems.map((ci) => ci.product).toList(),
                    ),
          if (isFilterExpanded)
            Positioned(
              top: kToolbarHeight,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 5),
                  ],
                ),
                child: FilterList(onFilterSelected: (filter) {
                  setState(() {
                    selectedFilter = filter;
                    isFilterExpanded = false;
                  });
                  _applyFilter();
                }),
              ),
            ),
        ],
      ),
    );
  }
}*/
// lib/features/dashboard/modelus/Component/ComponentPage.dart
/*import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/CartPage/view/cartScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/product_data.dart'; // Make sure this import is correct
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/FilterList.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/ProductGrid.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/search_bar.dart';
// lib/features/dashboard/modelus/Component/ComponentPage.dart
// ... existing imports ...
import 'package:greanspherproj/features/dashboard/modelus/CartPage/view/cartScreen.dart'; // Ensure this is imported

class ComponentPage extends StatefulWidget {
  @override
  ComponentPageState createState() => ComponentPageState();
}

class ComponentPageState extends State<ComponentPage> {
  String selectedFilter = '';
  bool isFilterExpanded = false;
  List<Product> favoriteProducts = [];
  List<Product> cartProducts =
      []; // This list will hold the unique products in cart
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String _errorMessage = '';
  List<Product> allProducts = [];
  List<Product> displayedProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts({String? productName, String? category}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      List<Product> fetchedProducts =
          await _apiService.fetchProducts(productName: productName);
      setState(() {
        allProducts = fetchedProducts;
        _applyFilter();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load products: $e';
        _isLoading = false;
      });
    }
  }

  void _applyFilter() {
    setState(() {
      if (selectedFilter.isEmpty || selectedFilter == 'All') {
        displayedProducts = allProducts;
      } else {
        displayedProducts =
            allProducts.where((p) => p.category == selectedFilter).toList();
      }
    });
  }

  void toggleFavorite(Product product) {
    setState(() {
      if (favoriteProducts.contains(product)) {
        favoriteProducts.remove(product);
      } else {
        favoriteProducts.add(product);
      }
    });
  }

  // Modified addToCart to handle quantity and directly add
  void addToCart(Product product) {
    setState(() {
      // Check if product is already in cart. If your cart manages quantity,
      // you'd increment here instead of just adding if not present.
      if (!cartProducts.contains(product)) {
        cartProducts.add(product);
        product.isInCart = true; // Update product's cart status
      }
    });
  }

  void removeFromCart(Product product) {
    setState(() {
      cartProducts.remove(product);
      product.isInCart = false; // Update product's cart status
    });
  }

  // --- New method to handle navigation to CartScreen ---
  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(
          cartItems: cartProducts,
          onRemoveFromCart: removeFromCart, onAddToCart: (Product) {},
          // onAddToCart: addToCart, // Pass onAddToCart for suggestions
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: SearchBarWidget(
          onFilterToggle: () {
            setState(() {
              isFilterExpanded = !isFilterExpanded;
            });
          },
          onFilterSelected: (filter) {
            setState(() {
              selectedFilter = filter;
              isFilterExpanded = false;
            });
            _applyFilter();
          },
          onSearchSubmitted: (query) {
            _fetchProducts(productName: query);
          },
          isFilterExpanded: isFilterExpanded,
          cartItems: cartProducts,
          favoriteItems: favoriteProducts,
        ),
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.green))
              : _errorMessage.isNotEmpty
                  ? Center(child: Text(_errorMessage))
                  : ProductGrid(
                      products: displayedProducts,
                      onFavoriteToggle: toggleFavorite,
                      onAddToCart: addToCart,
                      onRemoveFromCart: removeFromCart,
                      favoriteProducts: favoriteProducts,
                      cartProducts: cartProducts,
                    ),
          if (isFilterExpanded)
            Positioned(
              top: kToolbarHeight,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 5),
                  ],
                ),
                child: FilterList(onFilterSelected: (filter) {
                  setState(() {
                    selectedFilter = filter;
                    isFilterExpanded = false;
                  });
                  _applyFilter();
                }),
              ),
            ),
        ],
      ),
    );
  }
}*/
/*class ComponentPage extends StatefulWidget {
  @override
  ComponentPageState createState() => ComponentPageState();
}*/

/*class ComponentPageState extends State<ComponentPage> {
  String selectedFilter = '';
  bool isFilterExpanded = false;
  List<Product> favoriteProducts = [];
  List<Product> cartProducts = [];
  List<Product> allProducts = []; // To store all products fetched from API
  List<Product> displayedProducts = []; // Products to display based on filter
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts({String? productName, String? category}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      List<Product> fetchedProducts =
          await _apiService.fetchProducts(productName: productName);
      setState(() {
        allProducts = fetchedProducts;
        _applyFilter(); // Apply initial filter or display all
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load products: $e';
        _isLoading = false;
      });
    }
  }

  void _applyFilter() {
    setState(() {
      if (selectedFilter.isEmpty || selectedFilter == 'All') {
        // 'All' to show all products
        displayedProducts = allProducts;
      } else {
        displayedProducts =
            allProducts.where((p) => p.category == selectedFilter).toList();
      }
    });
  }

  void toggleFavorite(Product product) {
    setState(() {
      if (favoriteProducts.contains(product)) {
        favoriteProducts.remove(product);
      } else {
        favoriteProducts.add(product);
      }
    });
  }

  void addToCart(Product product) {
    setState(() {
      if (!cartProducts.contains(product)) {
        cartProducts.add(product);
        product.isInCart = true; // Update product's cart status
      }
    });
  }

  void removeFromCart(Product product) {
    setState(() {
      cartProducts.remove(product);
      product.isInCart = false; // Update product's cart status
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: SearchBarWidget(
          onFilterToggle: () {
            setState(() {
              isFilterExpanded = !isFilterExpanded;
            });
          },
          onFilterSelected: (filter) {
            setState(() {
              selectedFilter = filter;
              isFilterExpanded = false;
            });
            _applyFilter();
          },
          onSearchSubmitted: (query) {
            _fetchProducts(productName: query);
          },
          isFilterExpanded: isFilterExpanded,
          cartItems: cartProducts,
          favoriteItems: favoriteProducts,
        ),
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.green))
              : _errorMessage.isNotEmpty
                  ? Center(child: Text(_errorMessage))
                  : ProductGrid(
                      products: displayedProducts, // Pass filtered products
                      onFavoriteToggle: toggleFavorite,
                      onAddToCart: addToCart,
                      onRemoveFromCart: removeFromCart,
                      favoriteProducts: favoriteProducts,
                      cartProducts: cartProducts,
                    ),
          if (isFilterExpanded)
            Positioned(
              top: kToolbarHeight,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 5),
                  ],
                ),
                child: FilterList(onFilterSelected: (filter) {
                  setState(() {
                    selectedFilter = filter;
                    isFilterExpanded = false;
                  });
                  _applyFilter();
                }),
              ),
            ),
        ],
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/CartPage/cartScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/product_data.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/FilterList.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/ProductGrid.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/CustomWidget/search_bar.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Component/view/cart_page.dart';

class ComponentPage extends StatefulWidget {
  @override
  ComponentPageState createState() => ComponentPageState();
}

class ComponentPageState extends State<ComponentPage> {
  String selectedFilter = '';
  bool isFilterExpanded = false;
  List<Product> favoriteProducts = [];
  List<Product> cartProducts = [];

  void toggleFavorite(Product product) {
    setState(() {
      if (favoriteProducts.contains(product)) {
        favoriteProducts.remove(product);
      } else {
        favoriteProducts.add(product);
      }
    });
  }

  void addToCart(Product product) {
    setState(() {
      if (!cartProducts.contains(product)) {
        cartProducts.add(product);
      }
    });
  }

  void removeFromCart(Product product) {
    setState(() {
      cartProducts.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: SearchBarWidget(
          onFilterToggle: () {
            setState(() {
              isFilterExpanded = !isFilterExpanded;
            });
          },
          onFilterSelected: (filter) {
            setState(() {
              selectedFilter = filter;
              isFilterExpanded = false;
            });
          },
          isFilterExpanded: isFilterExpanded,
          cartItems: cartProducts, // ✅ تمرير العناصر الموجودة في السلة
          favoriteItems: favoriteProducts, // ✅ تمرير العناصر المفضلة
        ),

        /* actions: [
          _buildIconWithBadge(
            icon: Icons.shopping_cart,
            count: cartProducts.length,
            color: Colors.green,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(
                    cartItems: cartProducts,
                    onRemoveFromCart: removeFromCart,
                  ),
                ),
              );
            },
          ),
          _buildIconWithBadge(
            icon: Icons.favorite,
            count: favoriteProducts.length,
            color: Colors.green,
            onPressed: () {
              // TODO: فتح صفحة المفضلة
            },
          ),
        ],*/
      ),
      body: Stack(
        children: [
          ProductGrid(
            selectedFilter: selectedFilter,
            onFavoriteToggle: toggleFavorite,
            onAddToCart: addToCart,
            onRemoveFromCart: removeFromCart, // ✅ أضف هذه السطر لتجنب الخطأ
            favoriteProducts: favoriteProducts,
            cartProducts: cartProducts, // ✅ تمرير قائمة المنتجات في السلة
          ),
          if (isFilterExpanded)
            Positioned(
              top: kToolbarHeight,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 5),
                  ],
                ),
                child: FilterList(onFilterSelected: (filter) {
                  setState(() {
                    selectedFilter = filter;
                    isFilterExpanded = false;
                  });
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIconWithBadge({
    required IconData icon,
    required int count,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(icon, color: color),
          onPressed: onPressed,
        ),
        if (count > 0)
          Positioned(
            right: 5,
            top: 5,
            child: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 10,
              child: Text(
                '$count',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}
*/
