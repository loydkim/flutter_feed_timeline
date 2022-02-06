//import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart'; //DateFormat https://pub.dev/packages/intl
//import 'package:flutter_tags/flutter_tags.dart';

import 'package:flutterthreadexample/model/content_model.dart';
import 'package:flutterthreadexample/subViews/header_widget.dart';

import 'package:flutter_link_preview/flutter_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutterthreadexample/commons/utils_my.dart';

class ContentsAddPage extends StatefulWidget {
  static const title = 'Create a group'; //모든 클래스에서 공유하는?
  static const routeName = '/contentsAdd';

  @override
  _ContentsAddPageState createState() => _ContentsAddPageState();
}

class _ContentsAddPageState extends State<ContentsAddPage> {
  TextEditingController _controller;
  int _index = -1;
  List<String> urls = [
    //"https://mp.weixin.qq.com/s/qj7gkU-Pbdcdn3zO6ZQxqg",
  ];
  @override
  void initState() {
    _controller =
        TextEditingController(text: "https://brunch.co.kr/@linecard/457");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        isAppTitle: false,
        text: ContentsAddPage.title,
        widgets: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              Navigator.pushNamed(context, '/groupAdd', arguments: urls);
            },
          )
        ],
        //   text: HomeTab.title,
      ), // app
      body: Builder(
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Paste URL you want to learn with others'),
                TextField(
                  controller: _controller,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: "https://www.withon.io/..."),
                  //onChanged: (value) {              contentURL = value;            },
                ),

                Row(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        if (!urls.contains(_controller.value.text)) {
                          setState(() {
                            urls.add(_controller.value.text);
                            print(urls);
                            _controller.clear();
                          });
                        } else {
                          showSnackBar(ctx, 'Duplicated content exists');
                        }
                      },
                      child: const Text("Add"),
                    ),
                    const SizedBox(width: 15),
                    RaisedButton(
                      onPressed: () {
                        _controller.clear();
                      },
                      child: const Text("clear"),
                    ),
                  ],
                ),
                // URL 콘텐츠에 대한 미리보기 보여주는 부분
                Expanded(
                  child: ListView.builder(
                    itemCount: urls.length,
                    itemBuilder: (context, index) {
                      //final item = _urls[index];
                      return Dismissible(
                        key: Key(urls[index]),
                        direction: DismissDirection.startToEnd,
                        child: _buildCustomLinkPreview(context, index),
                        onDismissed: (direction) {
                          setState(() {
                            urls.removeAt(index);
                            print(urls);
                          });
                        },
                      );
                    },
                  ),
                ),

                // ListView.separated(
                //   //padding: const EdgeInsets.all(8),
                //   itemCount: _urls.length,
                //   itemBuilder: (context, index) {
                //     return InkWell(
                //         onTap: () {
                //           print(index);
                //         },
                //         child: _buildCustomLinkPreview(
                //             context, _urls[index], index));
                //   },
                //   separatorBuilder: (context, index) {
                //     return Divider();
                //   },
                //   shrinkWrap: true,
                // ),

                // ListView(
                //   padding: const EdgeInsets.all(8),
                //   itemCount: _urls.length,
                //   shrinkWrap: true,
                //   children: <Widget>[
                //     for (String url in _urls)
                //       _buildCustomLinkPreview(context, url)
                //   ],
                // ),

                //for (String url in _urls) _buildCustomLinkPreview(context, url),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // open graph 정보 보여주기
  Widget _buildCustomLinkPreview(BuildContext context, index) {
    return FlutterLinkPreview(
      //key: ValueKey("${_controller.value.text}211"),  // DUPLICATE KEY 에러 발생
      url: urls[index],
      builder: (info) {
        if (info == null) return const SizedBox();
        if (info is WebImageInfo) {
          return CachedNetworkImage(
            imageUrl: info.image,
            fit: BoxFit.contain,
          );
        }

        final WebInfo webInfo = info;
        if (!WebAnalyzer.isNotEmpty(webInfo.title)) return const SizedBox();
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFF0F1F2),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    //width: double.infinity,
                    child: Text(
                      webInfo.title,
                      textAlign: TextAlign
                          .left, // 공간이 있는 경우에만 정렬됨. 즉 SizedBox로 감싸고 width를 infinit로 해줘야 함
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                      icon: new Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          urls.removeAt(index);
                          print(urls);
                        });
                      })
                ],
              ),
              Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        if (WebAnalyzer.isNotEmpty(webInfo.description)) ...[
                          const SizedBox(height: 8),
                          Text(
                            webInfo.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: webInfo.icon ?? "",
                              imageBuilder: (context, imageProvider) {
                                return Image(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                  width: 15,
                                  height: 15,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.link);
                                  },
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                webInfo.redirectUrl,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child:
                        //thumnail 부분
                        // if (WebAnalyzer.isNotEmpty(webInfo.image)) ...[
                        //   const SizedBox(height: 8),
                        CachedNetworkImage(
                      imageUrl: webInfo.image,
                      fit: BoxFit.contain,
                    ),
                    // ],
                    flex: 1,
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

//--------------------------------------------------------------------

class GroupAddPage extends StatefulWidget {
  static const title = 'Paste URLs'; //모든 클래스에서 공유하는?
  static const routeName = '/groupAdd';

  //GroupAddPage(List<String> urls) : this.urls = urls {}

  @override
  _GroupAddPageState createState() => _GroupAddPageState();
}

class _GroupAddPageState extends State<GroupAddPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //List<String> contentURL;
  String contentURL;

  @override
  Widget build(BuildContext context) {
    final List<String> contentURLs = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: Header(),
      body: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: Text(
              "Complete other group meta information",
              textAlign: TextAlign
                  .left, // 공간이 있는 경우에만 정렬됨. 즉 SizedBox로 감싸고 width를 infinit로 해줘야 함
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          TextField(
            decoration: kTextFieldDecoration.copyWith(hintText: "Title"),
            onChanged: (value) {
              contentURL = value;
            },
          ),
          FlutterLinkPreview(
            url: "contentURL",
            titleStyle: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          FlatButton(
            // color: Colors.blue,
            // textColor: Colors.white,
            onPressed: () {}, //=> _contentsAddToFB(),
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }
}

// void _contentsAddToFB() async {
//   print(contentURL);
//   print(title);
//   print(keywords);
//   firestore.collection("groups").add({
//     "contentURL": contentURL, //int.parse(price),
//     "title": title,
//     "keywords": keywords
//   });
//   Navigator.pop(context);

//   // setState(() {
//   //   _isLoading = true;
//   // });
//   // //String postID = Utils.getRandomString(8) + Random().nextInt(500).toString();
//   // var newThreadRef = firestore.collection("thread").doc();

//   // String postImageURL;
//   // if (_postImageFile != null) {
//   //   postImageURL = await FBStorage.uploadPostImages(
//   //       threadRef: newThreadRef, postImageFile: _postImageFile);
//   // }
//   // FBCloudStore.sendPostInFirebase(newThreadRef, writingTextController.text,
//   //     widget.myData, postImageURL ?? 'NONE');

//   // setState(() {
//   //   _isLoading = false;
//   // });
//   // Navigator.pop(context);
// }
// }

// class GroupAddPage extends StatefulWidget {
//   static const title = 'Create New Group'; //모든 클래스에서 공유하는?

//   @override
//   _GroupAddPageState createState() => _GroupAddPageState();
// }

// class _GroupAddPageState extends State<GroupAddPage> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   // //final DocumentReference ownerID;
//   // //String id;
//   // //final Timestamp modifiedAt;
//   // //final Timestamp deleted_at;
//   // Timestamp createdAt;

//   // String title;
//   // List<dynamic> keywords;
//   // String descript;
//   // String thumbnailURL;
//   // Timestamp startAt;
//   // Timestamp endAt;

//   // List<DocumentReference> contentIDs;

//   // //_GroupAddPageState(); // this.ownerID

//   String title;
//   String keywords;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: Header(),
//       body: Column(
//         children: <Widget>[
//           Text("Copy and paste URL you want to learn with others"),
//           TextField(
//             decoration: kTextFieldDecoration.copyWith(
//                 hintText: "https://www.withon.io/..."),
//             onChanged: (value) {
//               contentURL = value;
//             },
//           ),
//           TextField(
//             decoration: kTextFieldDecoration.copyWith(hintText: "title"),
//             keyboardType: TextInputType.number,
//             onChanged: (value) {
//               title = value;
//             },
//           ),
//           TextField(
//             decoration: kTextFieldDecoration.copyWith(hintText: "keywords"),
//             onChanged: (value) {
//               keywords = value;
//             },
//           ),
//           FlatButton(
//             color: Colors.blue,
//             textColor: Colors.white,
//             onPressed: () => _groupAddToFB(),
//             child: Text("Submit"),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void _groupAddToFB() async {
//   //bool check = (purchase == 'true');
//   print(contentURL);
//   print(title);
//   print(keywords);
//   firestore.collection("groups").add({
//     "contentURL": contentURL, //int.parse(price),
//     "title": title,
//     "keywords": keywords
//   });
//   Navigator.pop(context);

//   // setState(() {
//   //   _isLoading = true;
//   // });
//   // //String postID = Utils.getRandomString(8) + Random().nextInt(500).toString();
//   // var newThreadRef = firestore.collection("thread").doc();

//   // String postImageURL;
//   // if (_postImageFile != null) {
//   //   postImageURL = await FBStorage.uploadPostImages(
//   //       threadRef: newThreadRef, postImageFile: _postImageFile);
//   // }
//   // FBCloudStore.sendPostInFirebase(newThreadRef, writingTextController.text,
//   //     widget.myData, postImageURL ?? 'NONE');

//   // setState(() {
//   //   _isLoading = false;
//   // });
//   // Navigator.pop(context);
// }

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
