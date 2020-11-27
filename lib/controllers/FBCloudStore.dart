import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterthreadexample/commons/const.dart';
import 'package:flutterthreadexample/commons/utils.dart';
import 'package:flutterthreadexample/controllers/FBCloudMessaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FBCloudStore{
  static Future<void> sendPostInFirebase(String postID,String postContent,MyProfileData userProfile,String postImageURL) async{
    String postFCMToken;
    if(userProfile.myFCMToken == null){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      postFCMToken = prefs.get('FCMToken');
    }else {
      postFCMToken = userProfile.myFCMToken;
    }
    Firestore.instance.collection('thread').document(postID).setData({
      'postID':postID,
      'userName':userProfile.myName,
      'userThumbnail':userProfile.myThumbnail,
      'postTimeStamp':DateTime.now().millisecondsSinceEpoch,
      'postContent':postContent,
      'postImage':postImageURL,
      'postLikeCount':0,
      'postCommentCount':0,
      'FCMToken':postFCMToken
    });
  }

  static Future<void> sendReportUserToFB(context,String reason, String userName,String postId,String content,String reporter) async{
    try {
      Firestore.instance.collection('report').document().setData({
        'reason': reason,
        'author': userName,
        'postId':postId,
        'content':content,
        'reporter':reporter
      });
    }catch(e) {
      print('Report post error');
    }
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

  static Future<void> updatePostLikeCount(DocumentSnapshot postData,bool isLikePost,MyProfileData myProfileData) async{
    postData.reference.updateData({'postLikeCount': FieldValue.increment(isLikePost ? -1 : 1)});
    if(!isLikePost){
      await FBCloudMessaging.instance.sendNotificationMessageToPeerUser('${myProfileData.myName} likes your post','${myProfileData.myName}',postData['FCMToken']);
    }
  }

  static Future<void> updatePostCommentCount(DocumentSnapshot postData,) async{
    postData.reference.updateData({'postCommentCount': FieldValue.increment(1)});
  }

  static Future<void> updateCommentLikeCount(DocumentSnapshot postData,bool isLikePost,MyProfileData myProfileData) async{
    postData.reference.updateData({'commentLikeCount': FieldValue.increment(isLikePost ? -1 : 1)});
    if(!isLikePost){
      await FBCloudMessaging.instance.sendNotificationMessageToPeerUser('${myProfileData.myName} likes your comment','${myProfileData.myName}',postData['FCMToken']);
    }
  }

  static Future<void> commentToPost(String toUserID,String toCommentID,String postID,String commentContent,MyProfileData userProfile,String postFCMToken) async{
    String commentID = Utils.getRandomString(8) + Random().nextInt(500).toString();
    String myFCMToken;
    if(userProfile.myFCMToken == null){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      myFCMToken = prefs.get('FCMToken');
    }else {
      myFCMToken = userProfile.myFCMToken;
    }
    Firestore.instance.collection('thread').document(postID).collection('comment').document(commentID).setData({
      'toUserID':toUserID,
      'commentID':commentID,
      'toCommentID':toCommentID,
      'userName':userProfile.myName,
      'userThumbnail':userProfile.myThumbnail,
      'commentTimeStamp':DateTime.now().millisecondsSinceEpoch,
      'commentContent':commentContent,
      'commentLikeCount':0,
      'FCMToken':myFCMToken
    });
    await FBCloudMessaging.instance.sendNotificationMessageToPeerUser(commentContent,'${userProfile.myName} was commented',postFCMToken);
  }
}