import 'package:flutter/material.dart';
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
