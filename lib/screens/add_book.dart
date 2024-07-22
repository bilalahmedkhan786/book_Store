import 'dart:io';

import 'package:bookstore/screens/homeScreen.dart';
import 'package:bookstore/shared/widgets/customButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  File? _image;
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  FirebaseFirestore databaseRef = FirebaseFirestore.instance;
  Future getImageGallery() async {
    final PickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      } else {
        print('no image picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            "Add Book",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () {
                getImageGallery();
              },
              child: Container(
                height: 200,
                width: 200,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: _image != null
                    ? Image.file(_image!.absolute)
                    : Center(child: Icon(Icons.image)),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.title),
                hintText: 'Tittle',
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              controller: priceController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.currency_exchange),
                hintText: 'Price',
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.description),
                hintText: 'Description',
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          MyButton(
              text: "Add Book",
              onPressed: () async {
                firebase_storage.Reference ref =
                    firebase_storage.FirebaseStorage.instance.ref('/books' +
                        DateTime.now().millisecondsSinceEpoch.toString());
                firebase_storage.UploadTask uploadTask =
                    ref.putFile(_image!.absolute);
                await Future.value(uploadTask);
                var newUrl = await ref.getDownloadURL();
                Get.to(HomeScreen());
                Get.snackbar("Book", "Data added");
                databaseRef.collection('books').add({
                  'name': titleController.text,
                  'image': newUrl.toString(),
                  'price': priceController.text,
                  'description': descriptionController.text
                });
                titleController.clear();
                priceController.clear();
                descriptionController.clear();
              })
        ],
      ),
    );
  }
}
