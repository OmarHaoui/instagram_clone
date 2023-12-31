import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omar/models/user.dart';
import 'package:omar/models/user.dart' as model;
import 'package:omar/resources/storage_methods.dart';
import 'package:omar/utils/utils.dart';

/// This class contains methods for user authentication and user details retrieval.
class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// This method retrieves user details from Firestore.
  ///
  /// Returns a [model.User] object.
  Future<model.User> getUserDetails() async {
    var currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  /// This method signs up a user with the provided email, password, username, bio, file, and context.
  ///
  /// Returns a [String] indicating the success or failure of the operation.
  Future<String> signInUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
    required BuildContext context,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        // registe user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        //upload the image to firebase storage
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('ProfilePics', file, false);

        model.User user = model.User(
          username: username,
          email: email,
          uid: cred.user!.uid,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );
        // add user to our firestore database
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = "success";
      } else {
        showSnackBar("All the fields must be filled", context);
      }
    } /*on FirebaseAuthException catch(err){
        if (err.code == 'invalid-email') {
          res = "the email is badly formatted";
        }
        else if (err.code == 'weak-password') {
          res = "Password should be at least 6 characters";
        }}*/

    catch (error) {
      res = error.toString();
    }
    return res;
  }

  /// This method logs in a user with the provided email, password, and context.
  ///
  /// Returns a [String] indicating the success or failure of the operation.it's mine.
  Future<String> logInUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // registe user
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        showSnackBar("All the fields must be filled", context);
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }
}
