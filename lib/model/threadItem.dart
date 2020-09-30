import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/commons/const.dart';
import 'package:flutterthreadexample/commons/utils.dart';
import 'package:flutterthreadexample/model/user_model.dart';

class ThreadItem extends StatefulWidget {
  final DocumentSnapshot data;
  final User myData;
  final ValueChanged<User> updateMyDataToMain;
  final bool isFromThread;
  final Function threadItemAction;
  final int commentCount;
  ThreadItem(
      {this.data,
      this.myData,
      this.updateMyDataToMain,
      this.threadItemAction,
      this.isFromThread,
      this.commentCount});
  @override
  State<StatefulWidget> createState() => _ThreadItem();
}

class _ThreadItem extends State<ThreadItem> {
  User _currentMyData;
  int _likeCount;
  @override
  void initState() {
    _currentMyData = widget.myData;
    _likeCount = widget.data.get('postLikeCount');
    super.initState();
  }

  void _updateLikeCount(bool isLikePost) async {
    User _newProfileData = await Utils.updateLikeCount(
        widget.data,
        widget.myData.myLikeList != null &&
                widget.myData.myLikeList.contains(widget.data.id)
            ? true
            : false,
        widget.myData,
        widget.updateMyDataToMain,
        true);
    setState(() {
      _currentMyData = _newProfileData;
    });
    setState(() {
      isLikePost ? _likeCount-- : _likeCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 6),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () => widget.isFromThread
                    ? widget.threadItemAction(widget.data)
                    : null,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6.0, 2.0, 10.0, 2.0),
                      child: Container(
                          width: 48,
                          height: 48,
                          child: Image.asset(
                              'images/${widget.data.get('userThumbnail')}')),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.data.get('userName'),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            Utils.readTimestamp(
                                widget.data.get('postTimeStamp')),
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => widget.isFromThread
                    ? widget.threadItemAction(widget.data)
                    : null,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 4, 10),
                  child: Text(
                    (widget.data.get('postContent') as String).length > 200
                        ? '${widget.data.get('postContent').substring(0, 132)} ...'
                        : widget.data.get('postContent'),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    maxLines: 3,
                  ),
                ),
              ),
              widget.data.get('postImage') != 'NONE'
                  ? GestureDetector(
                      onTap: () => widget.isFromThread
                          ? widget.threadItemAction(widget.data)
                          : widget.threadItemAction(),
                      child: Utils.cacheNetworkImageWithEvent(
                          context, widget.data.get('postImage'), 0, 0))
                  : Container(),
              Divider(
                height: 2,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => _updateLikeCount(_currentMyData.myLikeList !=
                                  null &&
                              _currentMyData.myLikeList.contains(widget.data.id)
                          ? true
                          : false),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.thumb_up,
                              size: 18,
                              color: widget.myData.myLikeList != null &&
                                      widget.myData.myLikeList
                                          .contains(widget.data.id)
                                  ? Colors.blue[900]
                                  : Colors.black),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Like ( ${widget.isFromThread ? widget.data.get('postLikeCount') : _likeCount} )',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: widget.myData.myLikeList != null &&
                                          widget.myData.myLikeList
                                              .contains(widget.data.id)
                                      ? Colors.blue[900]
                                      : Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => widget.isFromThread
                          ? widget.threadItemAction(widget.data)
                          : null,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.mode_comment, size: 18),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Comment ( ${widget.commentCount} )',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
