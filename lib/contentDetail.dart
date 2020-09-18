
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/commons/fullPhoto.dart';
import 'package:flutterthreadexample/controllers/FBCloudStore.dart';

import 'commons/const.dart';
import 'commons/utils.dart';
import 'controllers/localTempDB.dart';

class ContentDetail extends StatefulWidget{
  final DocumentSnapshot postData;
  final MyProfileData myData;
  final ValueChanged<MyProfileData> updateMyData;
  ContentDetail({this.postData,this.myData,this.updateMyData});
  @override State<StatefulWidget> createState() => _ContentDetail();
}

class _ContentDetail extends State<ContentDetail> {
  final TextEditingController _msgTextController = new TextEditingController();
  MyProfileData currentMyData;
  int likeCount;
  int commentLikeCount;
  @override
  void initState() {
    currentMyData = widget.myData;
    likeCount = widget.postData['postLikeCount'];
    super.initState();
  }
  void _updateLikeCount(DocumentSnapshot data, bool isLikePost) async {
    List<String> newLikeList = await LocalTempDB.saveLikeList(data['postID'],widget.myData.myLikeList,isLikePost,'likeList');
    MyProfileData myProfileData = MyProfileData(
        myName: widget.myData.myName,
        myThumbnail: widget.myData.myThumbnail,
        myLikeList: newLikeList,
        myLikeCommnetList: widget.myData.myLikeCommnetList
    );
    widget.updateMyData(myProfileData);
    setState(() {
      currentMyData = myProfileData;
    });
    setState(() {
      isLikePost ? likeCount-- : likeCount++;
    });
    await FBCloudStore.updatePostLikeCount(data,isLikePost);
    await FBCloudStore.likeToPost(data['postID'], myProfileData,isLikePost);
  }

  void _likeComment(DocumentSnapshot data, bool isLikeComment) async {
    List<String> newLikeCommentList = await LocalTempDB.saveLikeList(data['commentID'],widget.myData.myLikeCommnetList,isLikeComment,'likeCommnetList');
    MyProfileData myProfileData = MyProfileData(
        myName: widget.myData.myName,
        myThumbnail: widget.myData.myThumbnail,
        myLikeList: widget.myData.myLikeList,
        myLikeCommnetList: newLikeCommentList
    );
    widget.updateMyData(myProfileData);
    setState(() {
      currentMyData = myProfileData;
    });
    await FBCloudStore.updateCommentLikeCount(data,isLikeComment);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('thread').document(widget.postData['postID']).collection('comment').orderBy('commentTimeStamp',descending: true).snapshots(),
        builder: (context,snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return
            Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0,2.0,2.0,6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Card(
                                elevation:2.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(6.0,2.0,10.0,2.0),
                                            child: Container(
                                                width: 48,
                                                height: 48,
                                                child: Image.asset('images/${widget.postData['userThumbnail']}')
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(widget.postData['userName'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                              Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: Text(readTimestamp(widget.postData['postTimeStamp']),style: TextStyle(fontSize: 16,color: Colors.black87),),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(8,10,4,10),
                                        child: Text(widget.postData['postContent'],style: TextStyle(fontSize: 16),),
                                      ),
                                      widget.postData['postImage'] != 'NONE' ? GestureDetector(
                                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FullPhoto(imageUrl: widget.postData['postImage'],))),
                                          child: Utils.cacheNetworkImageWithEvent(context,widget.postData['postImage'],0,0)
                                      ) : Container(),
                                      Divider(height: 2,color: Colors.black,),
                                      Padding(
                                        padding: const EdgeInsets.only(top:6.0,bottom: 2.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () => _updateLikeCount(widget.postData,currentMyData.myLikeList != null && currentMyData.myLikeList.contains(widget.postData['postID']) ? true : false),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.thumb_up,size: 18,color: currentMyData.myLikeList != null && currentMyData.myLikeList.contains(widget.postData['postID']) ? Colors.blue[900] : Colors.black),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left:8.0),
                                                    child: Text('Like ( $likeCount )',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: currentMyData.myLikeList != null && currentMyData.myLikeList.contains(widget.postData['postID']) ? Colors.blue[900] : Colors.black),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.mode_comment,size: 18),
                                                Padding(
                                                  padding: const EdgeInsets.only(left:8.0),
                                                  child: Text('Comment ( ${snapshot.data.documents.length} )',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              snapshot.data.documents.length > 0 ? ListView(
                                primary: false,
                                shrinkWrap: true,
                                children: snapshot.data.documents.map((document) {
                                  return _commentListItem(document,size);
                                }).toList(),
                              ) : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildTextComposer()
              ],
            );
        }
      )
    );
  }

  void _functionTest(){
    List<String> testList = List<String>();
    List<String> testList2 = List<String>();
    testList.sublist(start)
  }


  Widget _commentListItem(DocumentSnapshot data,Size size){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0,2.0,10.0,2.0),
                child: Container(
                    width: 48,
                    height: 48,
                    child: Image.asset('images/${data['userThumbnail']}')
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(data['userName'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:4.0),
                            child: Text(data['commentContent'],maxLines: null,),
                          ),
                        ],
                      ),
                    ),
                    width: size.width-90,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(
                          Radius.circular(15.0)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0,top: 4.0),
                    child: Container(
                      width: 110,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(readTimestamp(data['commentTimeStamp'])),
                          GestureDetector(
                            onTap: () => _likeComment(data,currentMyData.myLikeCommnetList != null && currentMyData.myLikeCommnetList.contains(data['commentID']) ? true : false),
                            child: Text('Like',
                                style:TextStyle(fontWeight: FontWeight.bold,color:currentMyData.myLikeCommnetList != null && currentMyData.myLikeCommnetList.contains(data['commentID']) ? Colors.blue[900] : Colors.grey[700]))
                          ),
                          Text('Reply',style:TextStyle(fontWeight: FontWeight.bold,color:Colors.grey[700])),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          data['commentLikeCount'] > 0 ? Positioned(
            bottom: 10,
            right:0,
            child: Card(
                elevation:2.0,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.thumb_up,size: 14,color: Colors.blue[900],),
                      Text('${data['commentLikeCount']}',style:TextStyle(fontSize: 14)),
                    ],
                  ),
                )
            ),
          ) : Container(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _msgTextController,
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(
                    hintText: "Write a comment"),
              ),
            ),

            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 2.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () {
                    _handleSubmitted(_msgTextController.text);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmitted(String text) async {
    try {
      await FBCloudStore.commentToPost(widget.postData['userName'],widget.postData['postID'], _msgTextController.text, widget.myData);
      await FBCloudStore.updatePostCommentCount(widget.postData);
      FocusScope.of(context).requestFocus(FocusNode());
      _msgTextController.text = '';
//      setState(() { _isLoading = true; });
//      await FirebaseController.instanace.sendMessageToChatRoom(widget.chatID,widget.myID,widget.selectedUserID,text,messageType);
//      await FirebaseController.instanace.updateChatRequestField(widget.selectedUserID, messageType == 'text' ? text : '(Photo)',widget.chatID,widget.myID,widget.selectedUserID);
//      await FirebaseController.instanace.updateChatRequestField(widget.myID, messageType == 'text' ? text : '(Photo)',widget.chatID,widget.myID,widget.selectedUserID);
//      _getUnreadMSGCountThenSendMessage();
    }catch(e){
//      _showDialog('Error user information to database');
//      _resetTextFieldAndLoading();
    }
  }

}