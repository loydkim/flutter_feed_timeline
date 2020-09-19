
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/commons/fullPhoto.dart';
import 'package:flutterthreadexample/controllers/FBCloudStore.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

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
  String _replyUserID;
  String _replyCommentID;
  int likeCount;
  int commentLikeCount;

  FocusNode _writingTextFocus = FocusNode();

  @override
  void initState() {
    currentMyData = widget.myData;
    likeCount = widget.postData['postLikeCount'];
    _msgTextController.addListener(_msgTextControllerListener);
    super.initState();
  }

  void _msgTextControllerListener(){
    if(_msgTextController.text.length == 0) {
      _replyUserID = null;
      _replyCommentID = null;
    }
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

  void _replyComment(String replyTo,String replyCommentID) async {
    _replyUserID = replyTo;
    _replyCommentID = replyCommentID;
    FocusScope.of(context).requestFocus(_writingTextFocus);
    _msgTextController.text = '$replyTo ';
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
                                children: _sortDocumentsByComment(snapshot.data.documents).map((document) {
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

  List<DocumentSnapshot> _sortDocumentsByComment(List<DocumentSnapshot> data){
    List<DocumentSnapshot> _originalData = data;
    Map<String,List<DocumentSnapshot>> commentDocuments = Map<String,List<DocumentSnapshot>>();
    List<int> replyCommentIndex = List<int>();
    for(int i = 0; i < _originalData.length; i++){
      for(int j = 0; j < _originalData.length; j++){
        if (_originalData[i]['commentID'] == _originalData[j]['toCommentID']){
          print('Do it index is $i and ${_originalData[i]['commentID']} and compare name is ${_originalData[j]['commentID']} ${_originalData[j]['toCommentID']}');
          List<DocumentSnapshot> savedCommentData;
          if (commentDocuments[_originalData[i]['commentID']] != null && commentDocuments[_originalData[i]['commentID']].length > 0) {
            savedCommentData = commentDocuments[_originalData[i]['commentID']];
          }else {
            savedCommentData = List<DocumentSnapshot>();
          }
          savedCommentData.add(_originalData[j]);
          commentDocuments[_originalData[i]['commentID']] = savedCommentData;
          replyCommentIndex.add(j);
        }
      }
    }

    print('replyCommentIndex length is ${replyCommentIndex.length}');
    replyCommentIndex.sort((a,b){
      return b.compareTo(a);
    });

    // remove comment
    if(replyCommentIndex.length > 0){
      for(int i = 0; i < replyCommentIndex.length; i++){
        _originalData.removeAt(replyCommentIndex[i]);
      }
    }

    print('commentDocuments length is ${commentDocuments.length}');
    // saved comment
    for(DocumentSnapshot snapshot in _originalData){
      if(commentDocuments[snapshot['commentID']] != null){
        for(int j = 0; j < commentDocuments[snapshot['commentID']].length; j ++){
          print(commentDocuments[snapshot['commentID']][j]['commentID']);
        }
      }
    }

    print('final arranged list is ');
    // Add list to comment
    for(int i = 0; i < _originalData.length; i++){
      if (commentDocuments[_originalData[i]['commentID']] != null){
        _originalData.insertAll(i+1,commentDocuments[_originalData[i]['commentID']]);
      }
    }

    // final print
    for (DocumentSnapshot snapshot in _originalData){
      print(snapshot['commentContent']);
    }
    return _originalData;
  }

  Widget _commentListItem(DocumentSnapshot data,Size size){
    return Padding(
      padding: data['toUserID'] == widget.postData['userName'] ? EdgeInsets.all(8.0) : EdgeInsets.fromLTRB(34.0,8.0,8.0,8.0),
      child: Stack(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0,2.0,10.0,2.0),
                child: Container(
                    width: data['toUserID'] == widget.postData['userName'] ? 48 : 40,
                    height: data['toUserID'] == widget.postData['userName'] ? 48 : 40,
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
                            child: data['toUserID'] == widget.postData['userName'] ? Text(data['commentContent'],maxLines: null,) :
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text: data['toUserID'], style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[800])),
                                  TextSpan(text: _commentWithoutReplyUser(data['commentContent']), style: TextStyle(color:Colors.black)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    width: size.width- (data['toUserID'] == widget.postData['userName'] ? 90 : 110),
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
                          GestureDetector(
                            onTap: (){
                              _replyComment(data['userName'],data['commentID']);
                              print('leave comment of commnet');
                            },
                            child: Text('Reply',style:TextStyle(fontWeight: FontWeight.bold,color:Colors.grey[700]))
                          ),
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

  String _commentWithoutReplyUser(String commentString){
    List<String> splitCommentString = commentString.split(' ');
    int commentUserNameLength = splitCommentString[0].length;
    String returnText = commentString.substring(commentUserNameLength,commentString.length);
    return returnText;
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
                focusNode: _writingTextFocus,
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
      await FBCloudStore.commentToPost(_replyUserID == null ? widget.postData['userName'] : _replyUserID,_replyCommentID == null ? widget.postData['commentID'] : _replyCommentID,widget.postData['postID'], _msgTextController.text, widget.myData);
      await FBCloudStore.updatePostCommentCount(widget.postData);
      FocusScope.of(context).requestFocus(FocusNode());
      _msgTextController.text = '';
    }catch(e){
      print('error to submit comment');
    }
  }

}