import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart'; //DateFormat https://pub.dev/packages/intl
import 'package:cloud_firestore/cloud_firestore.dart';

class Group with ChangeNotifier {
  final String id; //실제 db에는 저장되어 있지 않지만 여기서 사용하기 위해 저장
  final Timestamp createdTime;
  final Timestamp lastUpdatedTime;
  //final Timestamp deleted_at;

  String title;
  List<dynamic> keywords;
  String descript;
  String thumbnailURL;
  Timestamp startOpTime;
  Timestamp endOpTime;

  DocumentReference ownerID;
  //List<DocumentReference> contentIDs;
  List<DocumentReference> memberUserIDs;
  List<DocumentReference> bookmarkUserIDs;
  //final DocumentReference reference; //firebase 데이터를 참조할 수 있는 링크

// Constructor
  Group.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), snapshot.reference);

  Group.fromMap(Map<String, dynamic> map, DocumentReference reference)
      : id = reference.id,
        createdTime = map['createdTime'],
        lastUpdatedTime = map['lastUpdatedTime']
  //deleted_at = map['deleted_at'],
  {
    ownerID = map['ownerID'];
    title = map['title'];
    keywords = map['keywords'];
    descript = map['descript'];
    thumbnailURL = map['thumbnailURL'];
    startOpTime = map['startOpTime'];
    endOpTime = map['endOpTime'];
    // contentIDs = map['contentIDs'];
    memberUserIDs = map['memberUserIDs'];
    bookmarkUserIDs = map['bookmarkUserIDs'];
  }

// 값 변경 함수
  // void updateBookmarkCount(bool isbookmarkedPost) async {
  //   // User _newProfileData = await Utils.updateLikeCount(
  //   //     widget.data,
  //   //     widget.myData.likeFeeds != null &&
  //   //             widget.myData.likeFeeds.contains(widget.data.id)
  //   //         ? true
  //   //         : false,
  //   //     widget.myData,
  //   //     widget.updateMyDataToMain,
  //   //     true);
  //   // isbookmarkedPost ? bookmarkUserIDs.remove(value)
  //   //   isLikePost ? _likeCount-- : _likeCount++;
  //   // });
  // }

  @override
  String toString() => "Group<$title:$keywords>";

  //date 출력 포맷
  String dateToString() {
    DateTime startAtDate = this.startOpTime.toDate();
    DateTime endAtDate = this.endOpTime.toDate();
    var diffDays = endAtDate.difference(startAtDate).inDays;

    var format = new DateFormat('M/d(EEE)'); //, hh:mm a
    String startAtDateStr = format.format(startAtDate);
    String endAtDateStr = format.format(endAtDate);
    return "$startAtDateStr ~ $endAtDateStr  |  $diffDays days";
  }
}
