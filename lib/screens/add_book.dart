import 'dart:io';
import 'package:bookstore/screens/homeScreen.dart';
import 'package:bookstore/shared/widgets/customButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart'; // Import the file_picker package

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  File? _image;
  File? _pdfFile; // To store the picked PDF file
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

  // Function to pick a PDF file
  Future pickPDFFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdfFile = File(result.files.single.path!);
      });
    } else {
      print('No file selected');
    }
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
      body: SingleChildScrollView( // Use SingleChildScrollView to avoid overflow
        child: Column(
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
            SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.title),
                  hintText: 'Title',
                ),
              ),
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 40),
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
            SizedBox(height: 20),
            MyButton(
              text: "Pick PDF",
              onPressed: () {
                pickPDFFile();
              },
            ),
            if (_pdfFile != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Selected PDF: ${_pdfFile!.path.split('/').last}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            SizedBox(height: 40),
            MyButton(
              text: "Add Book",
              onPressed: () async {
                firebase_storage.Reference imageRef = firebase_storage
                    .FirebaseStorage.instance
                    .ref('/books/images/' +
                        DateTime.now().millisecondsSinceEpoch.toString());

                firebase_storage.UploadTask imageUploadTask =
                    imageRef.putFile(_image!.absolute);
                await Future.value(imageUploadTask);
                var imageUrl = await imageRef.getDownloadURL();

                firebase_storage.Reference pdfRef = firebase_storage
                    .FirebaseStorage.instance
                    .ref('/books/pdf/' +
                        DateTime.now().millisecondsSinceEpoch.toString());

                firebase_storage.UploadTask pdfUploadTask =
                    pdfRef.putFile(_pdfFile!);
                await Future.value(pdfUploadTask);
                var pdfUrl = await pdfRef.getDownloadURL();

                Get.to(HomeScreen());
                Get.snackbar("Book", "Data added");

                databaseRef.collection('books').add({
                  'name': titleController.text,
                  'image': imageUrl.toString(),
                  'price': priceController.text,
                  'description': descriptionController.text,
                  'pdf': pdfUrl.toString(), // Storing PDF URL in Firestore
                });

                titleController.clear();
                priceController.clear();
                descriptionController.clear();
                setState(() {
                  _image = null;
                  _pdfFile = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
