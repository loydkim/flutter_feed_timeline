import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id; //내부에서만 활용?
  final String email;
  final String username;
  final String profileImageURL;
  final String bio;

  User({
    this.id,
    this.email,
    this.username,
    this.profileImageURL,
    this.bio,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    Map getDocs = doc.data();
    return User(
      id: doc.id,
      email: getDocs["email"],
      username: getDocs["username"],
      profileImageURL: getDocs["profileImageURL"],
      bio: getDocs["bio"],
    );
  }
}
