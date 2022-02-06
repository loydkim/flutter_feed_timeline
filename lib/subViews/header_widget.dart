import 'package:flutter/material.dart';

class Header extends AppBar with PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(50.0);

  final bool useTitle;
  final bool isAppTitle;
  final String text;
  final List<Widget> widgets;
  final bool disappearedBackButton;

  Header({
    //Key key,
    this.useTitle = true,
    this.isAppTitle = true,
    this.text,
    this.widgets,
    this.disappearedBackButton = false,
  }) : super(
          //key: key,
          title: useTitle
              ? Text(
                  isAppTitle ? 'WithOn' : text,
                  style: TextStyle(
                    //color: Colors.white,
                    fontFamily: isAppTitle ? 'Signatra' : '',
                    //fontSize: isAppTitle ? 30 : 22,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          actions: widgets,
          automaticallyImplyLeading: disappearedBackButton ? false : true,
          //centerTitle: true,
          //backgroundColor: Colors.black,
          elevation: 0.0,
        ) {}

  // @override
  // Widget build(BuildContext context) {
  //   return AppBar(
  //     // iconTheme: IconThemeData(
  //     //     //color: Colors.white,
  //     //     ),
  //     title: Text(
  //       isAppTitle ? 'WithOn' : text,
  //       style: TextStyle(
  //         //color: Colors.white,
  //         fontFamily: isAppTitle ? 'Signatra' : '',
  //         //fontSize: isAppTitle ? 30 : 22,
  //       ),
  //       overflow: TextOverflow.ellipsis,
  //     ),
  //     actions: widgets,
  //     automaticallyImplyLeading: disappearedBackButton ? false : true,
  //     //centerTitle: true,
  //     //backgroundColor: Colors.black,
  //     elevation: 0.0,
  //   );

}

// https://stackoverflow.com/questions/53411890/how-can-i-have-my-appbar-in-a-separate-file-in-flutter-while-still-having-the-wi
// class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
//   //final Color backgroundColor = Colors.red;
//   final Text title;
//   final AppBar appBar;
//   final List<Widget> widgets;

//   /// you can add more fields that meet your needs

//   const BaseAppBar({Key key, this.title, this.appBar, this.widgets})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: title,
//       //backgroundColor: backgroundColor,
//       actions: widgets,
//     );
//   }

//   @override
//   Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
// }
