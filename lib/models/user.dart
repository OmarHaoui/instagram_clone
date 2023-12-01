import 'package:cloud_firestore/cloud_firestore.dart';

/// A class representing a user in the application.
class User {
  final String username;
  final String email;
  final String uid;
  final String bio;
  final String photoUrl;
  final List followers;
  final List following;

  /// Constructor for the User class.
  User({
    required this.username,
    required this.email,
    required this.uid,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
  });

  /// Converts the User object to a JSON object.
  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'uid': uid,
        'bio': bio,
        'photoUrl': photoUrl,
        'followers': followers,
        'following': following,
      };

  /// Creates a User object from a DocumentSnapshot.
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);

    return User(
        username: snapshot['username'],
        email: snapshot['email'],
        uid: snapshot['uid'],
        bio: snapshot['bio'],
        photoUrl: snapshot['photoUrl'],
        followers: snapshot['followers'],
        following: snapshot['following']);
  }
}
