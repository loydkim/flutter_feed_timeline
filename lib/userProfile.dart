import 'package:flutter/material.dart';
import 'package:flutterthreadexample/commons/youtubepromotion.dart';
import 'package:flutterthreadexample/subViews/changeUserIcon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'commons/const.dart';

class UserProfile extends StatefulWidget{
  final MyProfileData myData;
  final ValueChanged<MyProfileData> updateMyData;
  UserProfile({this.myData,this.updateMyData});
  @override State<StatefulWidget> createState() => _UserProfile();
}

class _UserProfile extends State<UserProfile>{
  String _myThumbnail;
  String _myName;
  @override
  void initState() {
    _myName = widget.myData.myName;
    _myThumbnail = widget.myData.myThumbnail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Card(
          elevation:2.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    width: 60,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 40,
                          child: Image.asset('images/$_myThumbnail')
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:3.0),
                          child: Text('Change',style: TextStyle(color: Colors.blue[900],fontWeight: FontWeight.bold,fontSize: size.width *0.03),),
                        )
                      ],
                    )
                  ),
                ),
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (context) => ChangeUserIcon(myData: widget.myData,),
                    barrierDismissible: true,
                  ).then((newMyThumbnail){
                    _updateMyData(widget.myData.myName,newMyThumbnail);
                  });
                },
              ),
              GestureDetector(
                onTap: (){
                  _showDialog();
                },
                child: Text('Name: $_myName',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),)
              ),
            ],
          )
        ),

        Padding(
          padding: const EdgeInsets.only(top:38.0),
          child: youtubePromotion(),
        )
      ],
    );
  }

  Future<void> _updateMyData(String newName, String newThumbnail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('myName',newName);
    prefs.setString('myThumbnail',newThumbnail);
    setState(() {
      _myThumbnail = newThumbnail;
      _myName = newName;
    });
    MyProfileData newMyData = MyProfileData(
        myName: newName,
        myThumbnail: newThumbnail
    );
    widget.updateMyData(newMyData);
  }

  void _showDialog() async {
    TextEditingController _changeNameTextController = TextEditingController();
    await showDialog(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Type your other nick name',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    hintText: 'ex) loydkim',
                    icon: Icon(Icons.edit)),
                controller: _changeNameTextController,
              ),
            )
          ],
        ),
        actions: <Widget>[
        new FlatButton(
          child: const Text('CANCEL'),
          onPressed: ( ) {
            Navigator.pop(context);
          }),
        new FlatButton(
          child: const Text('SUBMIT'),
          onPressed: () {
            _updateMyData(_changeNameTextController.text,widget.myData.myThumbnail);
            Navigator.pop(context);
          })
        ],
      ),
    );
  }
}
