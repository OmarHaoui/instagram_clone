import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omar/models/post.dart';
import 'package:omar/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = 'Something went wrong';
    try {
      // upload post image to storage
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      // generate post id through uuid package
      String postId = const Uuid().v1();
      // create post model
      Post post = Post(
        description: description,
        username: username,
        uid: uid,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      // add post to firestore
      await _firestore.collection('posts').doc(postId).set(post.toJson());

      res = 'Post uploaded successfully';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // like post
  Future<void> likePost(String postId, String uid, List Likes) async {
    try {
      if (Likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profImage) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profImage,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now()
        });
      } else {
        print('text is empty ');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
