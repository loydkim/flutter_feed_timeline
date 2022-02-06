import 'package:shared_preferences/shared_preferences.dart';

class LocalTempDB {
  static Future<List<String>> saveLikeList(String postID,
      List<String> likeFeeds, bool isLikePost, String updateType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> newLikeList = likeFeeds;
    if (likeFeeds == null) {
      newLikeList = List<String>();
      newLikeList.add(postID);
    } else {
      if (isLikePost) {
        likeFeeds.remove(postID);
      } else {
        likeFeeds.add(postID);
      }
    }
    prefs.setStringList(updateType, newLikeList);
    return newLikeList;
  }
}
