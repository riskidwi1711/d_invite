import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/const/function/mainFunc.dart';
import 'package:d_invite/page/bantuan.dart';
import 'package:d_invite/page/home.dart';
import 'package:d_invite/page/notificationPage.dart';
import 'package:d_invite/page/profile.dart';
import 'package:d_invite/page/undangan.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedItem = 0;
  var userData;

  void _getUserData() async {
    SharedPreferences local = await SharedPreferences.getInstance();
    var user = local.getString('user');
    if (user != null) {
      setState(() {
        userData = jsonDecode(user);
      });
      _initPusher();
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _onTapItem(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  final _pageOption = [
    Home(),
    UndanganPage(),
    ProfilePage(),
    BantuanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: _onTapItem,
          currentIndex: _selectedItem,
          backgroundColor: Colors.white,
          selectedItemColor: Color(gradientOne),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_rounded,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.inbox), label: "Undangan"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
            BottomNavigationBarItem(icon: Icon(Icons.help), label: "Bantuan"),
          ],
        ),
        body: _pageOption.elementAt(_selectedItem));
  }

  FlutterPusher pusher = new FlutterPusher(
      'ABCDEFG',
      PusherOptions(
        host: '10.0.2.2',
        port: 6001,
        encrypted: false,
      ));

  Future<void> _initPusher() async {
    await pusher.connect(onConnectionStateChange: (val) {
      if (val.currentState == 'CONNECTED') {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 11,
                channelKey: 'basic_channel',
                title: 'Terhubung',
                body: 'Berhasil terhubung ke server'));
      }
    }, onError: (err) {
      print(err);
    });

    await pusher
        .subscribe('user.${userData['id']}')
        .bind("App\\Events\\notificationUsers", (e) async {
      if (e['notification']['type'] == 'invited') {
        await MainFunc()
            .getTemplate(e['notification']['undangan_id'])
            .then((value) {
          print(value);
          AwesomeNotifications().createNotification(
              content: NotificationContent(
                displayOnBackground: true,
                  displayOnForeground: true,
                  bigPicture: value,
                  notificationLayout: NotificationLayout.BigPicture,
                  id: 10,
                  channelKey: 'basic_channel',
                  title: e['notification']['type'],
                  body: e['notification']['notification']));
        });
      } else {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                displayOnBackground: true,
                displayOnForeground: true,
                id: 10,
                channelKey: 'basic_channel',
                title: e['notification']['type'],
                body: e['notification']['notification']));
      }
    }).whenComplete(() {
      AwesomeNotifications().actionStream.listen((event) {
        Navigator.push(context,
            MaterialPageRoute(builder: (builder) => NotificationPage()));
      });
    });
  }
}
