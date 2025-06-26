import 'package:flutter/material.dart';
import 'package:leez/services/authservice.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Check if the status exists in the product info
    isFavorite = widget.product.containsKey('status');
  }

  void toggleFavorite() async {
    setState(() {
      isLoading = true;
    });

    try {
      final productId =
          widget.product['result']?['_id'] ?? widget.product['_id'];
      final customerId =
          '6858ed546ab8ecdbc9264c2e'; // Replace with dynamic user ID
      final authService = AuthService();

      if (isFavorite) {
        await authService.removeWishList(
          customerId: customerId,
          productId: productId,
        );
      } else {
        await authService.addWishList(
          customerId: customerId,
          productId: productId,
        );
      }

      setState(() {
        isFavorite = !isFavorite;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to toggle favorite')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final productData = widget.product['result'] ?? widget.product;
    final imageUrl =
        "https://res.cloudinary.com/dyigkc2zy/image/upload/${productData['images'][0]}";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + Favorite Icon
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  imageUrl,
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child:
                    isLoading
                        ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : GestureDetector(
                          onTap: toggleFavorite,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.white,
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.black,
                              size: 16,
                            ),
                          ),
                        ),
              ),
            ],
          ),

          // Name
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              productData['name'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              productData['description'] ?? '',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const Spacer(),

          // Price + Rating Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹${productData['price']}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: const [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    SizedBox(width: 2),
                    Text("4.9", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
