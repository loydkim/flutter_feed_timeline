import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterthreadexample/commons/const.dart';
import 'package:flutterthreadexample/commons/utils.dart';
import 'package:flutterthreadexample/controllers/FBCloudMessaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterthreadexample/model/user_model.dart';

class FBCloudStore {
  static Future<void> sendPostInFirebase(
      DocumentReference newThreadRef,
      String postContent,
      MyLocalProfileData userProfile,
      String postImageURL) async {
    String postFCMToken;
    if (userProfile.userFCMToken == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      postFCMToken = prefs.get('FCMToken');
    } else {
      postFCMToken = userProfile.userFCMToken;
    }

    newThreadRef.set({
      'userName': userProfile.userName,
      'userThumbnail': userProfile.myThumbnail,
      'postTimeStamp': DateTime.now().millisecondsSinceEpoch,
      'postContent': postContent,
      'postImage': postImageURL,
      'postLikeCount': 0,
      'postCommentCount': 0,
      'FCMToken': postFCMToken
    });
  }

  static Future<void> likeToPost(
      String postID, MyLocalProfileData userProfile, bool isLikePost) async {
    if (isLikePost) {
      DocumentReference likeReference = FirebaseFirestore.instance
          .collection('thread')
          .doc(postID)
          .collection('like')
          .doc(userProfile.userName);
      await FirebaseFirestore.instance
          .runTransaction((Transaction myTransaction) async {
        myTransaction.delete(likeReference);
      });
    } else {
      await FirebaseFirestore.instance
          .collection('thread')
          .doc(postID)
          .collection('like')
          .doc(userProfile.userName)
          .set({
        'userName': userProfile.userName,
        'userThumbnail': userProfile.myThumbnail,
      });
    }
  }

  static Future<void> updatePostLikeCount(DocumentSnapshot postData,
      bool isLikePost, MyLocalProfileData myProfileData) async {
    postData.reference
        .update({'postLikeCount': FieldValue.increment(isLikePost ? -1 : 1)});
    if (!isLikePost) {
      await FBCloudMessaging.instance.sendNotificationMessageToPeerUser(
          '${myProfileData.userName} likes your post',
          '${myProfileData.userName}',
          postData.get('FCMToken'));
    }
  }

  static Future<void> updatePostCommentCount(
    DocumentSnapshot postData,
  ) async {
    postData.reference.update({'postCommentCount': FieldValue.increment(1)});
  }

  static Future<void> updateCommentLikeCount(DocumentSnapshot postData,
      bool isLikePost, MyLocalProfileData myProfileData) async {
    postData.reference.update(
        {'commentLikeCount': FieldValue.increment(isLikePost ? -1 : 1)});
    if (!isLikePost) {
      await FBCloudMessaging.instance.sendNotificationMessageToPeerUser(
          '${myProfileData.userName} likes your comment',
          '${myProfileData.userName}',
          postData.get('FCMToken'));
    }
  }

  static Future<void> commentToPost(
      String toUserID,
      String toCommentID,
      String postID,
      String commentContent,
      MyLocalProfileData userProfile,
      String postFCMToken) async {
    String commentID =
        Utils.getRandomString(8) + Random().nextInt(500).toString();
    String userFCMToken;
    if (userProfile.userFCMToken == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userFCMToken = prefs.get('FCMToken');
    } else {
      userFCMToken = userProfile.userFCMToken;
    }

    FirebaseFirestore.instance
        .collection('thread')
        .doc(postID)
        .collection('comment')
        .doc(commentID)
        .set({
      'toUserID': toUserID,
      'commentID': commentID,
      'toCommentID': toCommentID,
      'userName': userProfile.userName,
      'userThumbnail': userProfile.myThumbnail,
      'commentTimeStamp': DateTime.now().millisecondsSinceEpoch,
      'commentContent': commentContent,
      'commentLikeCount': 0,
      'FCMToken': userFCMToken
    });
    await FBCloudMessaging.instance.sendNotificationMessageToPeerUser(
        commentContent, '${userProfile.userName} was commented', postFCMToken);
  }
}
