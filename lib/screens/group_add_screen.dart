//import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart'; //DateFormat https://pub.dev/packages/intl
//import 'package:flutter_tags/flutter_tags.dart';

import 'package:flutterthreadexample/model/content_model.dart';
import 'package:flutterthreadexample/subViews/header_widget.dart';

class GroupAddPage extends StatefulWidget {
  static const title = 'Create New Group'; //모든 클래스에서 공유하는?

  @override
  _GroupAddPageState createState() => _GroupAddPageState();
}

class _GroupAddPageState extends State<GroupAddPage> {
  //final DocumentReference ownerID;
  //String id;
  //final Timestamp modifiedAt;
  //final Timestamp deleted_at;
  Timestamp createdAt;

  String title;
  List<dynamic> keywords;
  String descript;
  String thumbnailURL;
  Timestamp startAt;
  Timestamp endAt;

  List<DocumentReference> contentIDs;

  //_GroupAddPageState(); // this.ownerID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: Column(
        children: <Widget>[
          TextField(
            decoration:
                kTextFieldDecoration.copyWith(hintText: "Copy and paste URL"),
            onChanged: (value) {
              title = value;
            },
          ),
          // TextField(
          //   decoration:
          //       kTextFieldDecoration.copyWith(hintText: "price(only number)"),
          //   keyboardType: TextInputType.number,
          //   onChanged: (value) {
          //     price = value;
          //   },
          // ),
          // TextField(
          //   decoration: kTextFieldDecoration.copyWith(
          //       hintText: "purchased?(true / false)"),
          //   onChanged: (value) {
          //     purchase = value;
          //   },
          // ),
          FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              // bool check = (purchase == 'true');
              // print(price);
              // print(title);
              // print(check);
              // FirebaseFirestore.instance.collection("books").add({
              //   "price": int.parse(price),
              //   "title": title,
              //   "purchase?": check
              // });
              // Navigator.pop(context);
            },
            child: Text("Finish"),
          ),
        ],
      ),
    );
  }
}

const kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  hintStyle: TextStyle(color: Colors.grey),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide.none,
  ),
);

//   @override
//   void initState() {
//     super.initState();
//     //isBookmark = widget.content.isBookmark;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: SafeArea(
//           child: ListView(
//             children: <Widget>[
//               Header(
//                   // isAppTitle = false,
//                   // text = title,
//                   ),
//               Stack(
//                 children: <Widget>[
//                   Container(
//                     width: double.maxFinite,
//                     child: ClipRect(
//                       child: Container(
//                         alignment: Alignment.center,
//                         //color: Colors.black.withOpacity(0.1),
//                         child: Container(
//                           child: Column(
//                             children: <Widget>[
//                               Container(
//                                 padding: EdgeInsets.all(7),
//                                 alignment: Alignment.centerLeft,
//                                 child: Text(
//                                   widget.content.title,
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16),
//                                 ),
//                               ),
//                               Container(
//                                   alignment: Alignment.centerLeft,
//                                   padding: EdgeInsets.all(5),
//                                   child: Text(
//                                       'ddd') //widget.content.dateToString()),
//                                   ),
//                               Container(
//                                 padding: EdgeInsets.all(5),
//                                 alignment: Alignment.centerLeft,
//                                 child: Text(
//                                   '출연: 현빈, 손예진, 서지혜\n제작자: 이정효, 박지은',
//                                   style: TextStyle(
//                                     color: Colors.white60,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 color: Colors.black26,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     Container(
//                       padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                       child: InkWell(
//                         onTap: () {
//                           setState(() {
//                             //isBookmark = !isBookmark;
//                             // widget.content.reference.update({'like': isBookmark});
//                           });
//                         },
//                         child: Column(
//                           children: <Widget>[
//                             // isBookmark ? Icon(Icons.check) : Icon(Icons.add),
//                             Padding(
//                               padding: EdgeInsets.all(5),
//                             ),
//                             Text(
//                               '내가 찜한 콘텐츠',
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 color: Colors.white60,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                       child: Container(
//                         child: Column(
//                           children: <Widget>[
//                             Icon(Icons.thumb_up),
//                             Padding(
//                               padding: EdgeInsets.all(5),
//                             ),
//                             Text(
//                               '평가',
//                               style: TextStyle(
//                                   fontSize: 11, color: Colors.white60),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                       child: Container(
//                         child: Column(
//                           children: <Widget>[
//                             Icon(Icons.send),
//                             Padding(padding: EdgeInsets.all(5)),
//                             Text(
//                               '공유',
//                               style: TextStyle(
//                                   fontSize: 11, color: Colors.white60),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               FloatingActionButton.extended(
//                 onPressed: () {
//                   // Add your onPressed code here!
//                 },
//                 label: Text('Join'),
//                 shape: RoundedRectangleBorder(),
//                 //backgroundColor: Colors.pink,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
