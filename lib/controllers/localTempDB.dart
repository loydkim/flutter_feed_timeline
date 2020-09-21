
import 'package:shared_preferences/shared_preferences.dart';

class LocalTempDB{
  static Future<List<String>> saveLikeList(String postID,List<String> myLikeList,bool isLikePost,String updateType) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> newLikeList = myLikeList;
    if(myLikeList == null) {
      newLikeList = List<String>();
      newLikeList.add(postID);
    }else {
      if (isLikePost) {
        myLikeList.remove(postID);
      }else {
        myLikeList.add(postID);
      }
    }
    prefs.setStringList(updateType, newLikeList);
    return newLikeList;
  }
}