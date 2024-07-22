// import 'package:bookstore/cores/services/firebase_services.dart';
// import 'package:bookstore/models/product.dart';
// import 'package:bookstore/pages/bookDetail.dart';
// import 'package:bookstore/shared/widgets/customButton.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ProductScreen extends StatefulWidget {
//   final Product product;

//   const ProductScreen({Key? key, required this.product}) : super(key: key);

//   @override
//   State<ProductScreen> createState() => _ProductScreenState();
// }

// class _ProductScreenState extends State<ProductScreen> {
//   void onThemeChanged(ThemeMode mode) {
//     // Handle theme change logic here if needed
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.product.name),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Image.asset(
//               widget.product.image,
//               height: 300.0,
//               fit: BoxFit.cover,
//             ),
//             const SizedBox(height: 16.0),
//             Text(
//               widget.product.name,
//               style: const TextStyle(
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8.0),
//             Text(
//               '\$${widget.product.price.toStringAsFixed(2)}',
//               style: const TextStyle(
//                 fontSize: 20.0,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             const Text(
//               'Product Description',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8.0),
//             const Text(
//               'This is a detailed description of the product. It provides all the necessary information that a customer might need to know about the product. You can include features, benefits, and other relevant details here.',
//               style: TextStyle(
//                 fontSize: 16.0,
//               ),
//             ),
//             const Spacer(),
//             MyButton(
//                 text: "Read More",
//                 onPressed: () {
//                   // MyFirebase().initialize();
//                   MyFirebase().getCollection();
//                   Get.to(BookDetail(onThemeChanged: onThemeChanged));
//                 })
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:bookstore/pages/bookDetail.dart';
import 'package:bookstore/shared/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetail extends StatelessWidget {
  final Map<String, dynamic> productData;

  const ProductDetail({super.key, required this.productData});
  void onThemeChanged(ThemeMode mode) {
//     // Handle theme change logic here if needed
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.network(
                  productData['image'],
                  height: 400,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Text('Image not available');
                  },
                ),
              ),
              SizedBox(height: 16),
              Text(
                productData['name'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '\$${productData['price']}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 16),
              Text(
                productData['description'] ?? 'No description available',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              MyButton(
                  text: "Read More",
                  onPressed: () {
                    // MyFirebase().initialize();
                    Get.to(BookDetail(onThemeChanged: onThemeChanged));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
