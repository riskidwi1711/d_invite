import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:d_invite/api/api.dart';
import 'package:d_invite/components/topBar.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/const/function/mainFunc.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var notif;
  bool load = true;
  var now;

  void _getNotif() async {
    SharedPreferences local = await SharedPreferences.getInstance();
    var user = jsonDecode(local.getString('user'));
    var res = await CallApi().getData('getNotif/${user['id']}');
    var body = jsonDecode(res.body);
    if (body.length > 0) {
      setState(() {
        notif = body;
        load = false;
      });
    } else {
      setState(() {
        notif = null;
        load = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getNotif();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              height: 90,
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(gradientOne), Color(gradientTwo)]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: SafeArea(
                  child: MyTopBarWithBack(
                title: "Notifikasi",
              )),
            ),
            Expanded(
              child: load
                  ? Center(child: CircularProgressIndicator())
                  : notif == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Container(
                                height: 250,
                                width: 300,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fitWidth,
                                        image: AssetImage(
                                            'assets/img/confussed.png'))),
                              ),
                              Text(
                                'Belum ada notifikasi baru',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ])
                      : ListView.builder(
                          itemCount: notif.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                                direction: DismissDirection.endToStart,
                                onDismissed: (dir) async {
                                  var data = {
                                    'nId': notif[index]['id'],
                                    'id': notif[index]['user_id']
                                  };

                                  var res = await CallApi()
                                      .postData(data, 'deleteNotifById');
                                  var body = jsonDecode(res.body);

                                  if (body == 'success') {
                                    _getNotif();
                                  }
                                },
                                background: Container(
                                  padding: EdgeInsets.only(right: 20),
                                  alignment: Alignment.centerRight,
                                  color: Colors.redAccent,
                                  child: Icon(
                                    CupertinoIcons.delete_solid,
                                    color: Colors.white,
                                  ),
                                ),
                                key: UniqueKey(),
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 1,
                                                style: BorderStyle.solid))),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.notifications_rounded,
                                        color: Color(gradientOne),
                                      ),
                                      title: Text(
                                          notif[index]['type'] == 'message'
                                              ? 'Pesan baru'
                                              : notif[index]['type'] ==
                                                      'confirmation'
                                                  ? 'Konfirmasi terbaru' : notif[index]['type'] == 'invited'
                                                  ? 'Undangan baru' :  'Bukti transfer baru'),
                                      subtitle:
                                          Text(notif[index]['notification']),
                                      trailing: Text(MainFunc()
                                          .getNotificationTime(
                                              notif[index]['created_at'])),
                                    )));
                          }),
            )
          ],
        ));
  }
}
