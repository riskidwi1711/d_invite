import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/page/homepage.dart';
import 'package:d_invite/page/loginReg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize('resource://drawable/ic_launcher', [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'basic notif',
        channelDescription: 'this channel basic',
        defaultColor: Color(gradientOne),
        ledColor: Colors.white)
  ]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool hasToken = false;

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    _getToken();
  }

  void _getToken() async {
    SharedPreferences local = await SharedPreferences.getInstance();
    var token = local.getString('token');
    if (token != null) {
      setState(() {
        hasToken = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Virtual Invitation',
      theme: ThemeData(
        fontFamily: 'RobotoMono',
        primarySwatch: Colors.blue,
      ),
      home: hasToken ? HomePage() : LoginPage(),
    );
  }
}
