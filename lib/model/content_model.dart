import 'package:cloud_firestore/cloud_firestore.dart';

class Content {
  final String id;
  final Timestamp createdTime;
  Timestamp lastUpdatedTime;
  //final Timestamp deleted_at;
  final DocumentReference ownerID;

  String contentURL;
  String title;
  List<dynamic> keywords;
  String descript;
  String thumbnailURL;

  // List<DocumentReference> comment_ids;
  // List<DocumentReference> highlight_ids;

  Content.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), snapshot.reference);
  Content.fromMap(Map<String, dynamic> map, DocumentReference reference)
      : id = map['id'],
        createdTime = map['createdTime'],
        lastUpdatedTime = map['lastUpdatedTime'],
        //deleted_at = map['deleted_at'],
        ownerID = map['ownerID'],
        contentURL = map['contentURL'],
        title = map['title'],
        keywords = map['keywords'],
        descript = map['descript'],
        thumbnailURL = map['thumbnail_URL'];
  // comment_ids = map['comment_ids'],
  // highlight_ids = map['highlight_ids'];

  @override
  String toString() => "Content<$title:$keywords>";
}
