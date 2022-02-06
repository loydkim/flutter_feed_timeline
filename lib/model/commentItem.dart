import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/commons/const.dart';
import 'package:flutterthreadexample/commons/utils.dart';
import 'package:flutterthreadexample/model/user_model.dart';

class CommentItem extends StatefulWidget {
  final DocumentSnapshot data;
  final MyLocalProfileData myData;
  final Size size;
  final ValueChanged<MyLocalProfileData> updateMyDataToMain;
  final ValueChanged<List<String>> replyComment;
  CommentItem(
      {this.data,
      this.size,
      this.myData,
      this.updateMyDataToMain,
      this.replyComment});
  @override
  State<StatefulWidget> createState() => _CommentItem();
}

class _CommentItem extends State<CommentItem> {
  MyLocalProfileData _currentMyData;
  @override
  void initState() {
    _currentMyData = widget.myData;
    super.initState();
  }

  void _updateLikeCount(bool isLikePost) async {
    MyLocalProfileData _newProfileData = await Utils.updateLikeCount(
        widget.data,
        isLikePost,
        widget.myData,
        widget.updateMyDataToMain,
        false);
    setState(() {
      _currentMyData = _newProfileData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.data.get('toCommentID') == null
          ? EdgeInsets.all(8.0)
          : EdgeInsets.fromLTRB(34.0, 8.0, 8.0, 8.0),
      child: Stack(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 2.0, 10.0, 2.0),
                child: Container(
                    width: widget.data.get('toCommentID') == null ? 48 : 40,
                    height: widget.data.get('toCommentID') == null ? 48 : 40,
                    child: Image.asset(
                        'images/${widget.data.get('userThumbnail')}')),
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
                            child: Text(
                              widget.data.get('userName'),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: widget.data.get('toCommentID') == null
                                ? Text(
                                    widget.data.get('commentContent'),
                                    maxLines: null,
                                  )
                                : RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: widget.data.get('toUserID'),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[800])),
                                        TextSpan(
                                            text: Utils.commentWithoutReplyUser(
                                                widget.data
                                                    .get('commentContent')),
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    width: widget.size.width -
                        (widget.data.get('toCommentID') == null ? 90 : 110),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Container(
                      width: widget.size.width * 0.38,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(Utils.readTimestamp(
                              widget.data.get('commentTimeStamp'))),
                          GestureDetector(
                              onTap: () => _updateLikeCount(
                                  _currentMyData.likeCommnets != null &&
                                          _currentMyData.likeCommnets
                                              .contains(widget.data.id)
                                      ? true
                                      : false),
                              child: Text('Like',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          _currentMyData.likeCommnets != null &&
                                                  _currentMyData.likeCommnets
                                                      .contains(widget.data.id)
                                              ? Colors.blue[900]
                                              : Colors.grey[700]))),
                          GestureDetector(
                              onTap: () {
                                widget.replyComment([
                                  widget.data.get('userName'),
                                  widget.data.id,
                                  widget.data.get('FCMToken')
                                ]);
//                                _replyComment(widget.data.get('userName'),widget.data.id,widget.data.get('FCMToken'));
                                print('leave comment of commnet');
                              },
                              child: Text('Reply',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700]))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          widget.data.get('commentLikeCount') > 0
              ? Positioned(
                  bottom: 10,
                  right: 0,
                  child: Card(
                      elevation: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.thumb_up,
                              size: 14,
                              color: Colors.blue[900],
                            ),
                            Text('${widget.data.get('commentLikeCount')}',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      )),
                )
              : Container(),
        ],
      ),
    );
  }
}
