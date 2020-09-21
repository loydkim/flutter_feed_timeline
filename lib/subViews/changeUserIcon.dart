import 'package:flutter/material.dart';
import '../commons/const.dart';

class ChangeUserIcon extends StatefulWidget{
  final MyProfileData myData;
  ChangeUserIcon({this.myData});
  @override State<StatefulWidget> createState() => _ChangeUserIcon();
}

class _ChangeUserIcon extends State<ChangeUserIcon>{

  String myThumbnail;

  @override
  void initState() {
    myThumbnail = widget.myData.myThumbnail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
        children: <Widget>[
          SimpleDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              contentPadding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                    width: size.width,
                    height: size.height-size.height*0.12,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GridView.count(crossAxisCount: 4,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            padding: const EdgeInsets.all(8),
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            children: iconImageList.map(_makeGridTile).toList()),
                      ),
                    ),
                )
              ]
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:2.0,right:2.0),
                  child: ClipOval(
                    child: Container(
                      color: Colors.blue,
                      height: 60.0, // height of the button
                      width: 60.0, // width of the button
                      child: RaisedButton(
                        elevation:8.0,
                        color: Colors.black,
                        onPressed: (){
                          Navigator.pop(context,myThumbnail);
                        },
                        child: Icon(Icons.close,size: 32,color: Colors.white,),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ]
    );
  }

  Widget _makeGridTile(String userIconPath){
    return GridTile(
      child: GestureDetector(
          onTap: () {
            setState(() {
              myThumbnail = userIconPath;
            });
          },
          child: Container(
              decoration: BoxDecoration(
                color: userIconPath == myThumbnail ? Colors.yellow : Colors.white,
                border: userIconPath == myThumbnail ? Border.all(width: 3,color: Colors.red) : null,
              ),
              child: Image.asset('images/$userIconPath')
          )
      ),//image,
    );
  }
}