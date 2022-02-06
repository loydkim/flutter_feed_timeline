import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutterthreadexample/commons/const.dart';
import 'package:flutterthreadexample/model/user_model.dart';
import 'package:flutterthreadexample/screens/userProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'commons/utils.dart';
import 'controllers/FBCloudMessaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/feed/thread_tab.dart';

import 'package:flutterthreadexample/screens/explore_tab.dart';
import 'package:flutterthreadexample/screens/group_add1_screen.dart';

import 'package:provider/provider.dart';
import 'package:flutterthreadexample/blocs/auth_bloc.dart';

void main() async {
  //https://stackoverflow.com/questions/63492211/no-firebase-app-default-has-been-created-call-firebase-initializeapp-in
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          // 스트림 프로바이더로 파이어베이스 내 인증 정보를 읽어들임. 인증 상태가 변하면, 변한 값이 출력됨.
          Provider<AuthBloc>(create: (_) => AuthBloc()),
          // 스트림 프로바이더로 파이어스토어 데이터를 읽어들임.
          // StreamProvider<List<User>>.value(
          //   value: db.getUser(),
          // ),
        ],
        child: MaterialApp(
          title: 'withOn',
          theme: ThemeData(
            //primarySwatch: Colors.teal,
            // 밝기는 어둡게
            //brightness: Brightness.dark,
            // Color의 색상의 배열값? 색의 농도를 의미하며 100부터 900까지 100단위로 설정 가능
            // 사용자와 상호작용하는 앨리먼트들의 기본 색상
            primaryColor: Colors.teal[400],
            // 위젯을 위한 전경색상
            accentColor: Colors.teal[400],
            // 사용할 폰트
            //fontFamily: 'Montserrat',
            // 텍스트 테마 설정
            textTheme: TextTheme(
                // headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                // title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
                // body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
                ),
          ),
          //home: MyHomePage(), // 필수로 home 값 지정해줘야하나 아래 initialRoute 지정해줬으니
          //routing
          initialRoute: '/',
          routes: {
            '/': (context) => MyHomePage(),
            //'/explore': (context) => ExploreTab(),
            ContentsAddPage.routeName: (context) => ContentsAddPage(),
            GroupAddPage.routeName: (context) => GroupAddPage(),
          },
          debugShowCheckedModeBanner: false,
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController _tabController;
  MyLocalProfileData myData;

  bool _isLoading = false;

  @override
  void initState() {
    FBCloudMessaging.instance.takeFCMTokenWhenAppLaunch();
    FBCloudMessaging.instance.initLocalNotification();
    _tabController = new TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
    _takeMyData();
    super.initState();
  }

  Future<void> _takeMyData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myThumbnail;
    String userName;
    if (prefs.get('myThumbnail') == null) {
      String tempThumbnail = iconImageList[Random().nextInt(50)];
      prefs.setString('myThumbnail', tempThumbnail);
      myThumbnail = tempThumbnail;
    } else {
      myThumbnail = prefs.get('myThumbnail');
    }

    if (prefs.get('userName') == null) {
      String tempName = Utils.getRandomString(8);
      prefs.setString('userName', tempName);
      userName = tempName;
    } else {
      userName = prefs.get('userName');
    }

    setState(() {
      myData = MyLocalProfileData(
        myThumbnail: myThumbnail,
        userName: userName,
        likeFeeds: prefs.getStringList('likeList'),
        likeCommnets: prefs.getStringList('likeCommnetList'),
        userFCMToken: prefs.getString('FCMToken'),
      );
    });

    setState(() {
      _isLoading = false;
    });
  }

  void _handleTabSelection() => setState(() {});

  void onTabTapped(int index) {
    setState(() {
      _tabController.index = index;
    });
  }

  void updateMyData(MyLocalProfileData newMyData) {
    setState(() {
      myData = newMyData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Flutter Thread example'),
      //   centerTitle: true,
      // ),
      body: Stack(
        children: <Widget>[
          TabBarView(controller: _tabController, children: [
            ExploreTab(),
            ThreadMain(
              myData: myData,
              updateMyData: updateMyData,
            ),
            ExploreTab(),
          ]),
          Utils.loadingCircle(_isLoading),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _tabController.index,
        // selectedItemColor: Colors.amber[900],
        // unselectedItemColor: Colors.grey[800],
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: ExploreTab.androidIcon, //
            title: Text(ExploreTab.title),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.people),
            title: new Text('Thread'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_circle),
            title: new Text('Profile'),
          ),
        ],
      ),
    );
  }
}
