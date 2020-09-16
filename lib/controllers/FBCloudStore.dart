import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterthreadexample/commons/const.dart';

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

  static Future<void> updatePostCommentCount(DocumentSnapshot postData,) async{
    postData.reference.updateData({'postCommentCount': FieldValue.increment(1)});
  }

  static Future<void> commentToPost(String postID,String commentContent,MyProfileData userProfile) async{
    Firestore.instance.collection('thread').document(postID).collection('comment').document().setData({
      'postID':postID,
      'userName':userProfile.myName,
      'userThumbnail':userProfile.myThumbnail,
      'commentTimeStamp':DateTime.now().millisecondsSinceEpoch,
      'commentContent':commentContent,
      'commentLikeCount':0,
    });
  }
}