import 'package:flutter/material.dart';
import 'package:flutterthreadexample/model/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:flutterthreadexample/screens/content_detail_screen.dart';
import 'package:flutterthreadexample/subViews/header_widget.dart';
import 'package:flutterthreadexample/subViews/float_button_widget.dart';

import 'package:flutterthreadexample/screens/group_add1_screen.dart';

//import 'package:flutter/cupertino.dart';
//import 'package:flutter/foundation.dart';

// import 'package:flutter_lorem/flutter_lorem.dart';

// import 'utils.dart';

class ExploreTab extends StatefulWidget {
  static const title = 'Explore';
  static const androidIcon = Icon(Icons.explore);
  //static const iosIcon = Icon(CupertinoIcons.news);

  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> streamData;

  @override
  void initState() {
    // class가 처음 생성될 때 한 번만.
    super.initState();
    streamData = firestore
        .collection('groups')
        .snapshots(); // firestore.collection("books").where("purchase?", isEqualTo: true).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        widgets: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          )
        ],
        //   text: HomeTab.title,
      ), // appBar: AppBar(
      // ),
      body: Container(
        child: ListView.builder(
          itemCount: 1, // 수정 필요
          itemBuilder: _listBuilder,
        ),
      ),
      floatingActionButton: FloatButton(
        onPressed: () {
          Navigator.pushNamed(context, '/contentsAdd');
        },
        label: 'Add',
        icon: Icon(Icons.add),
      ),
    );
  }

  Widget _listBuilder(BuildContext context, int index) {
    //_fetchData
    return StreamBuilder<QuerySnapshot>(
      stream: streamData,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return LinearProgressIndicator(); //데이터 못가져왔다면 로딩화면 출력
        return _buildBody(context, snapshot.data.docs, index);
      },
    );
  }

  Widget _buildBody(
      BuildContext context, List<DocumentSnapshot> snapshot, int index) {
    List<Group> groups =
        snapshot.map((d) => Group.fromSnapshot(d)).toList(); // 전체데이터

    if (index >= groups.length) return null;
    return SafeArea(
      top: false,
      bottom: false,
      child: Card(
        elevation: 1.5,
        margin: EdgeInsets.fromLTRB(6, 12, 6, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: InkWell(
          // Make it splash on Android. It would happen automatically if this
          // was a real card but this is just a demo. Skip the splash on iOS.
          onTap: () {
            //Navigator.pushNamed(context, 'explore');
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: contentBuilder(groups, index)),
          ),
        ),
      ),
    );
  }
}

List<Widget> contentBuilder(List<Group> groups, int index) {
  const defaultThumbnailURL = 'images/001-panda.png';
  return [
    groups[index].thumbnailURL != 'NONE'
        ? Image.network(
            groups[index].thumbnailURL,
            scale: 10,
          )
        : Image(image: AssetImage(defaultThumbnailURL)),
    Padding(padding: EdgeInsets.only(left: 16)),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            groups[index].title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 8)),
          Text(
            groups[index].descript,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          Row(
            children: tagStringBuilder(groups[index].keywords),
          )
        ],
      ),
    ),
  ];
}

List<Widget> tagStringBuilder(List<dynamic> tags) {
  List<Widget> results = new List();
  for (String tag in tags) {
    results.add(Text(' ' + tag + ' ',
        style: TextStyle(
          backgroundColor: Colors.teal[300],
          color: Colors.white,
        )));
    results.add(Padding(padding: EdgeInsets.only(right: 8)));
  }
  return results;
}
