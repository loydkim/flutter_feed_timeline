import 'package:cloud_firestore/cloud_firestore.dart';

class Content {
  final String id;
  final Timestamp createdAt;
  final Timestamp modifiedAt;
  //final Timestamp deleted_at;
  final DocumentReference ownerID;

  String contentURL;
  String title;
  List<dynamic> keywords;
  String descript;
  String thumbnailURL;

  // List<DocumentReference> comment_ids;
  // List<DocumentReference> highlight_ids;

  final DocumentReference reference; //firebase 데이터를 참조할 수 있는 링크

  Content.fromMap(Map<String, dynamic> map, {this.reference})
      : id = map['id'],
        createdAt = map['created_at'],
        modifiedAt = map['modified_at'],
        //deleted_at = map['deleted_at'],
        ownerID = map['owner_id'],
        contentURL = map['contentURL'],
        title = map['title'],
        keywords = map['keywords'],
        descript = map['descript'],
        thumbnailURL = map['thumbnail_URL'];
  // comment_ids = map['comment_ids'],
  // highlight_ids = map['highlight_ids'];

  Content.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Content<$title:$keywords>";
}
