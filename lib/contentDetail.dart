import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/commons/fullPhoto.dart';
import 'package:flutterthreadexample/controllers/FBCloudStore.dart';
import 'package:flutterthreadexample/subViews/threadItem.dart';

import 'commons/const.dart';
import 'commons/utils.dart';
import 'subViews/commentItem.dart';

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
  String _replyUserFCMToken;
  FocusNode _writingTextFocus = FocusNode();

  @override
  void initState() {
    currentMyData = widget.myData;
    _msgTextController.addListener(_msgTextControllerListener);
    super.initState();
  }

  void _msgTextControllerListener(){
    if(_msgTextController.text.length == 0 || _msgTextController.text.split(" ")[0] != _replyUserID) {
      _replyUserID = null;
      _replyCommentID = null;
      _replyUserFCMToken = null;
    }
  }

  void _replyComment(List<String> commentData) async{//String replyTo,String replyCommentID,String replyUserToken) async {
    _replyUserID = commentData[0];
    _replyCommentID = commentData[1];
    _replyUserFCMToken = commentData[2];
    FocusScope.of(context).requestFocus(_writingTextFocus);
    _msgTextController.text = '${commentData[0]} ';
  }

  void _moveToFullImage() => Navigator.push(context, MaterialPageRoute(builder: (context) => FullPhoto(imageUrl: widget.postData['postImage'],)));

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
                              ThreadItem(data: widget.postData,myData: widget.myData,updateMyDataToMain: widget.updateMyData,threadItemAction: _moveToFullImage,isFromThread:false,commentCount: snapshot.data.documents.length,parentContext: context,),
                              snapshot.data.documents.length > 0 ? ListView(
                                primary: false,
                                shrinkWrap: true,
                                children: Utils.sortDocumentsByComment(snapshot.data.documents).map((document) {
                                  return CommentItem(data: document,myData: widget.myData,size: size,updateMyDataToMain: widget.updateMyData,replyComment:_replyComment);
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
      await FBCloudStore.commentToPost(_replyUserID == null ? widget.postData['userName'] : _replyUserID,_replyCommentID == null ? widget.postData['commentID'] : _replyCommentID,widget.postData['postID'], _msgTextController.text, widget.myData,_replyUserID == null ? widget.postData['FCMToken'] : _replyUserFCMToken);
      await FBCloudStore.updatePostCommentCount(widget.postData);
      FocusScope.of(context).requestFocus(FocusNode());
      _msgTextController.text = '';
    }catch(e){
      print('error to submit comment');
    }
  }
}