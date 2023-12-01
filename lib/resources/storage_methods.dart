import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // adding image to firebase storage
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    // this is a pointer to the file in the childName folder and the uidnamed image
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
    // if the image is a post image, update the pointer to the post id
    String id = const Uuid().v1();
    if (isPost) {
      ref = ref.child(id);
    }

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;

    // get the download Url of the image
    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }
}
