import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User with ChangeNotifier {
  final String id; //내부에서만 활용?
  final Timestamp createdTime;
  final String userFCMToken;
  String email;
  String userName;
  String profileImageURL;
  String descript;

  //feed
  List<String> likeFeeds;
  List<String> likeCommnets;
  //group
  List<DocumentReference> groupsAsMember;
  List<DocumentReference> groupsAsOwner;
  List<DocumentReference> bookmarkGroups;

  String myThumbnail = '001-panda.png'; // 삭제필요

  // Constructor
  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.reference.id, snapshot.data());

  User.fromMap(String id, Map<String, dynamic> map)
      : this.id = id,
        createdTime = map['createdTime'],
        userFCMToken = map['userFCMToken'] {
    email = map['email'];
    userName = map['userName'];
    profileImageURL = map['profileImageURL'];
    descript = map['descript'];
    likeFeeds = map['likeFeeds'];
    likeCommnets = map['likeCommnets'];
    groupsAsMember = map['groupsAsMember'];
    groupsAsOwner = map['groupsAsOwner'];
    bookmarkGroups = map['bookmarkGroups'];
  }
}

class MyLocalProfileData {
  final String myThumbnail;
  final String userName;
  final List<String> likeFeeds;
  final List<String> likeCommnets;
  final String userFCMToken;
  MyLocalProfileData(
      {this.userName,
      this.myThumbnail,
      this.likeFeeds,
      this.likeCommnets,
      this.userFCMToken});
}
