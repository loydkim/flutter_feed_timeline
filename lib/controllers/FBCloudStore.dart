import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterthreadexample/commons/const.dart';
import 'package:flutterthreadexample/commons/utils.dart';

class FBCloudStore{
  static Future<void> sendPostInFirebase(String postID,String postContent,MyProfileData userProfile,String postImageURL) async{
    Firestore.instance.collection('thread').document(postID).setData({
      'postID':postID,
      'userName':userProfile.myName,
      'userThumbnail':userProfile.myThumbnail,
      'postTimeStamp':DateTime.now().millisecondsSinceEpoch,
      'postContent':postContent,
      'postImage':postImageURL,
      'postLikeCount':0,
      'postCommentCount':0
    });
  }

  static Future<void> likeToPost(String postID,MyProfileData userProfile,bool isLikePost) async{
    if (isLikePost) {
      DocumentReference likeReference = Firestore.instance.collection('thread').document(postID).collection('like').document(userProfile.myName);
      await Firestore.instance.runTransaction((Transaction myTransaction) async {
        await myTransaction.delete(likeReference);
      });
    }else {
      await Firestore.instance.collection('thread').document(postID).collection('like').document(userProfile.myName).setData({
        'userName':userProfile.myName,
        'userThumbnail':userProfile.myThumbnail,
      });
    }

  }

  static Future<void> updatePostLikeCount(DocumentSnapshot postData,bool isLikePost) async{
    postData.reference.updateData({'postLikeCount': FieldValue.increment(isLikePost ? -1 : 1)});
  }

  static Future<void> updatePostCommentCount(DocumentSnapshot postData,) async{
    postData.reference.updateData({'postCommentCount': FieldValue.increment(1)});
  }

  static Future<void> updateCommentLikeCount(DocumentSnapshot postData,bool isLikePost) async{
    postData.reference.updateData({'commentLikeCount': FieldValue.increment(isLikePost ? -1 : 1)});
  }

  static Future<void> commentToPost(String toUserID,String postID,String commentContent,MyProfileData userProfile) async{
    String commentID = getRandomString(8) + Random().nextInt(500).toString();
    Firestore.instance.collection('thread').document(postID).collection('comment').document(commentID).setData({
      'toUserID':toUserID,
      'commentID':commentID,
      'userName':userProfile.myName,
      'userThumbnail':userProfile.myThumbnail,
      'commentTimeStamp':DateTime.now().millisecondsSinceEpoch,
      'commentContent':commentContent,
      'commentLikeCount':0,
    });
  }
}