import 'package:cloud_firestore/cloud_firestore.dart';

class MyFirebase {
  FirebaseFirestore db = FirebaseFirestore.instance;
  // List? data;

  addCollection(Map<String, dynamic> data) {
    db.collection("books").add(data).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  Future getCollection() async {
    var response = await db
        .collection("books")
        .get()
        .then((value) => value.docs.map((e) => {print(e.id)}));

    // return response.docs;
  }
}

///spread operator////
////////single entities (doc)//////
///multiple entities (collection)
