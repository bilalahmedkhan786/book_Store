import 'package:bookstore/auth/firebase_auth.dart';
import 'package:bookstore/cores/services/firebase_services.dart';
import 'package:bookstore/cores/services/notification_service.dart';
import 'package:bookstore/screens/add_book.dart';
import 'package:bookstore/screens/productDetail.dart';
import 'package:bookstore/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Auth myauth = Auth();
  MyFirebase db = MyFirebase();
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  int _selectedIndex = 0;
  NotificationServices notificationServices = NotificationServices();

  void getdata() {
    print(db.getCollection());
  }

  @override
  void initState() {
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    // notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then(
      (value) {
        print('device token');
        print(value);
      },
    );
    getdata();
    super.initState();
  }

  bool _isDarkMode = Get.isDarkMode;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('books').snapshots();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Get.to(AddBook());
        break;
      case 2:
        Get.to((ProfileScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            "Home Screen",
            style: TextStyle(
              color: Colors.white,
            ),
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
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black38, blurRadius: 5, spreadRadius: 1)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      hintText: 'Search books',
                      isDense: true,
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 10),
              PopupMenuButton<String>(
                onSelected: (String result) {
                  setState(() {});
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Name',
                    child: Text('Sort by Name'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Price',
                    child: Text('Sort by Price'),
                  ),
                ],
                icon: Icon(Icons.filter_list),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    print('Firestore Error: ${snapshot.error}');
                    return Center(
                        child: Text('Something went wrong: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No data available'));
                  }

                  // Filter books based on search query
                  final filteredDocs = snapshot.data!.docs.where((doc) {
                    final data = doc.data()! as Map<String, dynamic>;
                    final name = data['name'] as String;
                    return name
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase());
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return Center(child: Text('No matching books found'));
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns in the grid
                      crossAxisSpacing:
                          8.0, // Horizontal spacing between grid items
                      mainAxisSpacing:
                          8.0, // Vertical spacing between grid items
                      childAspectRatio: 0.7, // Aspect ratio of each grid item
                    ),
                    itemCount: filteredDocs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = filteredDocs[index];
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      // Check if 'image' field exists and is not empty
                      if (data['image'] == null || data['image'].isEmpty) {
                        return Center(child: Text('Image not available'));
                      }

                      return GestureDetector(
                        onTap: () {
                          Get.to(ProductDetail(productData: data));
                        },
                        child: Card(
                          elevation: 5,
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  data['image'],
                                  width: double.infinity,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Center(
                                        child: Text('Image not available'));
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data[
                                          'name'], // Assuming the data contains a 'name' field
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '\$${data['price']}', // Assuming the data contains a 'price' field
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Book',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
