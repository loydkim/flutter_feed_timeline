import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/commons/const.dart';
import 'package:flutterthreadexample/contentDetail.dart';
import 'package:flutterthreadexample/subViews/threadItem.dart';
import 'package:flutterthreadexample/writePost.dart';

import 'commons/utils.dart';

class ThreadMain extends StatefulWidget{
  final MyProfileData myData;
  final ValueChanged<MyProfileData> updateMyData;
  ThreadMain({this.myData,this.updateMyData});
  @override State<StatefulWidget> createState() => _ThreadMain();
}

class _ThreadMain extends State<ThreadMain>{
  bool _isLoading = false;

  void _writePost() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WritePost(myData: widget.myData,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('thread').orderBy('postTimeStamp',descending: true).snapshots(),
        builder: (context,snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return Stack(
            children: <Widget>[
              snapshot.data.documents.length > 0 ?
              ListView(
                shrinkWrap: true,
                children: snapshot.data.documents.map((DocumentSnapshot data){
                  return ThreadItem(data: data,myData: widget.myData,updateMyDataToMain: widget.updateMyData,threadItemAction: _moveToContentDetail,isFromThread:true,commentCount: data['postCommentCount'],parentContext: context,);
                }).toList(),
              ) : Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.error,color: Colors.grey[700],
                        size: 64,),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text('There is no post',
                          style: TextStyle(fontSize: 16,color: Colors.grey[700]),
                          textAlign: TextAlign.center,),
                      ),
                    ],
                  )
                ),
              ),
              Utils.loadingCircle(_isLoading),
            ],
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _writePost,
        tooltip: 'Increment',
        child: Icon(Icons.create),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _moveToContentDetail(DocumentSnapshot data) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ContentDetail(postData: data,myData: widget.myData,updateMyData: widget.updateMyData,)));
  }
}