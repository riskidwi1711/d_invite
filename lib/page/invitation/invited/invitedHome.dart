import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:d_invite/api/api.dart';
import 'package:d_invite/api/sharedPrefs/localStore.dart';
import 'package:d_invite/components/button.dart';
import 'package:d_invite/components/card.dart';
import 'package:d_invite/components/confirmationComp.dart';
import 'package:d_invite/components/topBar.dart';
import 'package:d_invite/const/config.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/const/function/qrCode.dart';
import 'package:d_invite/const/my_flutter_app_icons.dart';
import 'package:d_invite/page/invitation/chatRoom.dart';
import 'package:d_invite/page/invitation/invited/kirimAmplop.dart';

class InvitedHome extends StatefulWidget {
  final undangan;
  final currentUser;
  InvitedHome({this.undangan, this.currentUser});

  @override
  _InvitedHomeState createState() => _InvitedHomeState(undangan, currentUser);
}

class _InvitedHomeState extends State<InvitedHome> {
  var undangan;
  var currentUser;
  _InvitedHomeState(this.undangan, this.currentUser);
  var response;
  var chatRoom;
  var currentConfirm;
  bool isLoad = false;
  bool isloading = true;
  var _selectedIn = {
    0: false,
    1: false,
    2: false,
  };

  _selected(int index) {
    setState(() {
      _selectedIn[index] = true;
    });

    switch (index) {
      case 0:
        _selectedIn[0] = true;
        _selectedIn[1] = false;
        _selectedIn[2] = false;
        break;
      case 1:
        _selectedIn[0] = false;
        _selectedIn[1] = true;
        _selectedIn[2] = false;
        break;
      case 2:
        _selectedIn[0] = false;
        _selectedIn[1] = false;
        _selectedIn[2] = true;
        break;
      case 3:
        _selectedIn[0] = false;
        _selectedIn[1] = false;
        _selectedIn[2] = false;
    }
  }

  _createChatRoom() async {
    var data = {
      'user_one': undangan['user_id'],
      'user_two': undangan['user_invited'],
      'invitation_id': undangan['id'],
      'last_msg': "Kirim Pesan",
      'unread': null
    };

    var res = await CallApi().postData(data, 'getchatroomByInvited');
    var body = jsonDecode(res.body);

    if (body.length != 0 && body['content'].length > 0) {
      setState(() {
        chatRoom = body;
        isloading = false;
      });
    } else {
      setState(() {
        chatRoom = null;
        isloading = false;
      });
    }

  }

  void initWid() async {
    var getLocal = await CallLocal().getLocalString('konfirmasi${undangan['id']}');
    setState(() {
      currentConfirm = getLocal;
    });
    _selected(currentConfirm == "datang" ? 0 : currentConfirm == "tidak datang" ? 2 : currentConfirm == "mungkin" ? 1 : 3 );
  }

  void handleConfirmation(String konfirmasi) async {
    isLoad = true;
    var data = {
      'ids': undangan['user_id'],
      'user_id': currentUser,
      'undangan_id': undangan['id'],
      'konfirmasi': konfirmasi
    };
    var res = await CallApi().postData(data, 'konfirmasi');
    var body = jsonDecode(res.body);
    await CallLocal().setLocalString('konfirmasi${undangan['id']}', konfirmasi);
    setState(() {
      response = body;
      isLoad = false;
    });

    _showResponse(context, response['message'], response['status']);
  }

  double height = 300;
  double width = 250;
  ScrollController scrollController;

@override
  void initState() {
  super.initState();
  initWid();
  _createChatRoom();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Stack(
              children: [
                SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 120, bottom: 150, right: 20, left: 20),
                      child:  Container(
                        width: MediaQuery.of(context).size.width,
                        child: Image(image: NetworkImage('${base_url}savedtemplate/${undangan['file_path']}'),),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                      ),
                    )),
                Positioned(
                  top: 0,
                  child: Container(
                    height: 100,
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Color(gradientOne),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: SafeArea(
                        child: MyTopBarWithBack(
                          title: "Detail Undangan",
                        )),
                  ),
                ),
              ],
            ),
          ),
           Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyRoundedIcons(
                      btnFunc: () {
                        _showDialog();
                      },
                      title: 'Konfirmasi',
                      color: Color(gradientOne),
                      icon: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 33,
                      ),
                    ),
                    MyRoundedIcons(
                      btnFunc: () async {
                        await CallLocal().getLocalString('user').then((value) {
                          var data = jsonDecode(value);
                          QrCodeGen().showCode(context, jsonEncode({
                            "owner": undangan['user_id'],
                            'undangan_id': undangan['id'],
                            "uid": data['id'],
                            "nama": data['name'],
                            "email": data['email'],
                            "no_handphone": data['no_handphone']
                          }));
                        });
                      },
                      title: 'Kode QR',
                      color: Color(gradientOne),
                      icon: Icon(
                        Icons.qr_code_sharp,
                        color: Colors.white,
                        size: 33,
                      ),
                    ),
                    Stack(
                      children: [
                        MyRoundedIcons(
                        btnFunc: () {
                          Navigator.push(
                              (context),
                              MaterialPageRoute(
                                  builder: (builder) => ChatRoom(invitId:undangan['id'], fromInvited: true, chatRoom: chatRoom['content'].first,))).then((value) => _createChatRoom());
                        },
                        title: 'Pesan',
                        color: Color(gradientOne),
                        icon: Icon(
                          Icons.message,
                          color: Colors.white,
                          size: 33,
                        ),
                      ),
                      chatRoom != null ? chatRoom['content'][0]['unread_msg'] <= 0 ? Container() : Positioned(
                        top: 15,
                        right: 0,
                        child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: Colors.red
                          ),
                        ),
                      ) : Container()
                      ]
                    ),
                    MyRoundedIcons(
                      btnFunc: () {
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=> SendMoney(createdInvitations: undangan, userId: currentUser,)));
                      },
                      title: 'Amplop',
                      color: Color(gradientOne),
                      icon: Icon(
                        MyFlutterApp.money_bill_wave_alt,
                        color: Colors.white,
                        size: 33,
                      ),
                    ),
                  ],
                ),
                height: 110,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 6,
                          blurRadius: 7,
                          offset: Offset(0, 6))
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(99))),
                width: MediaQuery.of(context).size.width,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showResponse(BuildContext context, String msg, String status) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            title: new Text(status[0].toUpperCase() + status.substring(1)),
            content: new Text(msg[0].toUpperCase() + msg.substring(1)),
            actions: <Widget>[
              new MyFlatButton(
                btnRounded: 10,
                btnColor: Color(gradientOne),
                btnPadding: 5,
                btnFunc: () {
                  Navigator.of(context).pop();
                },
                btnName: 'Ok',
                textSize: 12,
              ),
            ],
          );
        });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white.withOpacity(0),
            content: Container(
              height: 120,
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color : Color(gradientOne),
                  borderRadius: BorderRadius.circular(25)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ConfirmationButton(
                      icon: Icon(
                        CupertinoIcons.checkmark_alt,
                        color: Colors.white,
                      ),
                      btnfunc: () {
                        _selected(0);
                        handleConfirmation('datang');

                        Navigator.of(context).pop();
                      },
                      color: _selectedIn[0]
                          ? Colors.lightGreen
                          : Colors.grey.shade400,
                      value: 'Datang'),
                  ConfirmationButton(
                      icon: Icon(
                        CupertinoIcons.question,
                        color: Colors.white,
                      ),
                      btnfunc: () {
                        _selected(1);
                        handleConfirmation('mungkin');
                        Navigator.of(context).pop();
                      },
                      color:
                          _selectedIn[1] ? Colors.orange : Colors.grey.shade400,
                      value: 'Mungkin'),
                  ConfirmationButton(
                      icon: Icon(
                        CupertinoIcons.clear,
                        color: Colors.white,
                      ),
                      btnfunc: () {
                        _selected(2);
                        handleConfirmation('tidak datang');
                        Navigator.of(context).pop();
                      },
                      color: _selectedIn[2]
                          ? Colors.redAccent
                          : Colors.grey.shade400,
                      value: 'Tidak'),
                ],
              ),
            ),
          );
        });
  }
}
