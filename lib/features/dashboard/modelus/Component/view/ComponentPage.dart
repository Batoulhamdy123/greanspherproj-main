import 'package:flutter/material.dart';
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
