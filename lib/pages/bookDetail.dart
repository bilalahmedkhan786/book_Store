import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookDetail extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  const BookDetail({super.key, required this.onThemeChanged});

  @override
  State<BookDetail> createState() => _BookDetailState();
}

double _scaleFactor = 1.0;
double _baseFontSize = 20.0;
double _previousScaleFactor = 1.0;

class _BookDetailState extends State<BookDetail> {
  bool _isDarkMode = Get.isDarkMode;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3C7DD9),
        title: const Center(
          child: Text(
            "Read Book",
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              Get.changeThemeMode(
                  _isDarkMode ? ThemeMode.light : ThemeMode.dark);
              _toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: GestureDetector(
          onScaleStart: (details) {
            _previousScaleFactor = _scaleFactor;
          },
          onScaleUpdate: (details) {
            setState(() {
              _scaleFactor =
                  (_previousScaleFactor * details.scale).clamp(0.5, 3.0);
            });
          },
          child: Text(
            "This is a detailed description of the product. It provides all the necessary information that a customer might need to know about the product. You can include features, benefits, and other relevant details here. This is a detailed description of the product. It provides all the necessary information that a customer might need to know about the product. You can include features, benefits, and other relevant details here. This is a detailed description of the product. It provides all the necessary information that a customer might need to know about the product. You can include features, benefits, and other relevant details here.This is a detailed description of the product. It provides all the necessary information that a customer might need to know about the product. You can include features, benefits, and other relevant details here.This is a detailed description of the product. It provides all the necessary information that a customer might need to know about the product. You can include features, benefits, and other relevant details here.This is a detailed description of the product. It provides all the necessary information that a customer might need to know about the product. You can include features, benefits, and other relevant details here.This is a detailed description of the product. It provides all the necessary information that a customer might need to know about the product. You can include features, benefits, and other relevant details here.This is a detailed description of the product. It provides all the necessary information that a customer might need to know about the product. You can include features, benefits, and other relevant details here.This is a detailed description of the product. It provides all the necessary information that a customer might need to know about the product. You can include features, benefits, and other relevant details here.This is a detailed description of the product. It provides all the necessary information that a customer might need to know about the product. You can include features, benefits, and other relevant details here.This is a detailed description of the product. It provides all the necessary information that a customer might need to know about the product. You can include features, benefits, and other relevant details here.",
            style: TextStyle(fontSize: _baseFontSize * _scaleFactor),
          ),
        ),
      ),
    );
  }
}
