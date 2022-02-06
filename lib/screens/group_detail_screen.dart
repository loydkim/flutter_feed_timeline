// //import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:testflutter2/model/content_model.dart';

// class ContentPage extends StatefulWidget {
//   final Content content;
//   ContentPage({this.content});
//   _ContentPageState createState() => _ContentPageState();
// }

// class _ContentPageState extends State<ContentPage> {
//   bool isBookmark = false;
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
//               AppBar(
//                 //backgroundColor: Colors.white,
//                 elevation: 0,
//               ),
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
//                                 alignment: Alignment.centerLeft,
//                                 padding: EdgeInsets.all(5),
//                                 child: Text(widget.content.dateToString()),
//                               ),
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
//                             isBookmark = !isBookmark;
//                             widget.content.reference.update({'like': isBookmark});
//                           });
//                         },
//                         child: Column(
//                           children: <Widget>[
//                             isBookmark ? Icon(Icons.check) : Icon(Icons.add),
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
