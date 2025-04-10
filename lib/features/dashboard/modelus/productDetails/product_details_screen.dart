import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/product_data.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1; // لحفظ العدد الحالي

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: "Hinted search text",
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              suffixIcon: const Icon(Icons.search, color: Colors.green),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ المفضلة + صورة المنتج
            IconButton(
              icon: const Icon(
                Icons.favorite_border,
                color: Colors.green,
                size: 30,
              ),
              onPressed: () {
                // كود إضافة إلى المفضلة
              },
            ),
            Center(
              child: Image.asset(
                widget.product.imageUrl,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),

            // ✅ اسم المنتج
            Text(
              widget.product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 5),

            // ✅ السعر + مربع العدد
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ✅ السعر
                Column(
                  children: [
                    Text(
                      "EGP ${widget.product.price}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    if (widget.product.oldPrice != null) ...[
                      const SizedBox(width: 7),
                      Text(
                        "EGP ${widget.product.oldPrice}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ],
                ),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      // ✅ العدد في مربع مستقل
                      Container(
                        width: 40,
                        height: 66,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.green),
                          ),
                        ),
                        child: Text(
                          "$quantity",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),

                      // ✅ العمود اللي فيه + و -
                      Column(
                        children: [
                          // زر +
                          InkWell(
                            onTap: increaseQuantity,
                            child: Container(
                              width: 40,
                              height: 33,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.green),
                                  left: BorderSide(color: Colors.green),
                                ),
                              ),
                              child: const Text(
                                "+",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // زر -
                          InkWell(
                            onTap: decreaseQuantity,
                            child: Container(
                              width: 40,
                              height: 33,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(color: Colors.green)),
                              ),
                              child: const Text(
                                "-",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            buildStars(4),
            const SizedBox(height: 5),
            // ✅ الأزرار
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // كود إضافة المنتج إلى السلة
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text(
                      "Add to cart",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // كود الشراء الآن
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Buy now",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ✅ الوصف
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
                "Designed for storing and mixing solid fertilizers before dissolving them in hydroponic systems. It ensures a steady nutrient supply for optimal plant growth."),
          ],
        ),
      ),
    );
  }

  Widget buildStars(int rating) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.green,
          size: 24,
        ),
      ),
    );
  }
}
