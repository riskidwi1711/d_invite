import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:d_invite/api/api.dart';
import 'package:d_invite/api/sharedPrefs/localStore.dart';
import 'package:d_invite/components/topBar.dart';
import 'package:d_invite/const/config.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/const/function/mainFunc.dart';
import 'package:d_invite/page/handlerMediaChat.dart';

class ChatRoom extends StatefulWidget {
  final bool fromInvited;
  final chatRoom;
  final invitId;
  ChatRoom({this.chatRoom, this.invitId, this.fromInvited = false});

  @override
  _ChatRoomState createState() =>
      _ChatRoomState(chatRoom, invitId, fromInvited);
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(children: [
        Positioned(
          top: 80,
          bottom: 60,
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).viewInsets.bottom,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: chatData.length != null ? chatData.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return Align(
                    alignment: chatData[index]['user_id'] == curUser['id']
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: chatData[index]['user_id'] == curUser['id'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width / 1.5),
                            padding: chatData[index]['type'] == 'image' ||
                                chatData[index]['type'] == 'video'
                                ? EdgeInsets.all(0)
                                : EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius:
                                chatData[index]['user_id'] == curUser['id']
                                    ? BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(0))
                                    : BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(0),
                                    topLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                                color: Color(gradientTwo)),
                            child: chatData[index]['type'] == 'image'
                                ? GestureDetector(
                              onTap: () {
                                _showDi(Image(
                                  image: NetworkImage(
                                      '${base_url}img/chatMedia/${chatData[index]['chat']}'),
                                ));
                              },
                              child: Container(
                                  height: 150,
                                  width:
                                  MediaQuery.of(context).size.width / 2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15)),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              '${base_url}img/chatMedia/${chatData[index]['chat']}')))),
                            )
                                : chatData[index]['type'] == 'video'
                                ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => MediaChat(
                                          file:
                                          '${base_url}img/chatMedia/${chatData[index]['chat']}',
                                          type: 'fromchat',
                                        )));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                      height: 150,
                                      width: MediaQuery.of(context)
                                          .size
                                          .width /
                                          2,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight:
                                              Radius.circular(15),
                                              topLeft:
                                              Radius.circular(15),
                                              bottomLeft:
                                              Radius.circular(15)),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  '${base_url}img/thumbnail/${chatData[index]['thumbnail']}')))),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      bottom: 0,
                                      left: 0,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    999),
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
                                            child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            )
                                : Text(
                              '${chatData[index]['chat']}',
                              textAlign: chatData[index]['user_id'] ==
                                  curUser['id']
                                  ? TextAlign.justify
                                  : null,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(DateFormat.Hm().format(DateTime.parse(chatData[index]['created_at']).toLocal()), style: TextStyle(fontSize: 12),)
                        ],
                      )
                    ),
                  );
                },
              )),
        ),
        Column(
          children: [
            Container(
              height: 100,
              padding: EdgeInsets.only(left: 10),
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
                  child: MyTopBarWithImg(
                chat: status == null ? false : true,
                stat: status,
                img:
                    NetworkImage('${base_url}img/${chatRoom['photo_profile']}'),
                title: chatRoom['name'],
              )),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(gradientTwo),
              ),
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      _getImage();
                    },
                    child: Icon(
                      Icons.image_outlined,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        _getVideo();
                      },
                      child: Icon(
                        Icons.videocam,
                        color: Colors.white,
                      )),
                  Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 180,
                            child: TextFormField(
                              controller: msg,
                              decoration: InputDecoration(
                                  hintText: 'Tulis pesan disini...',
                                  border: InputBorder.none),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _sendMsg('text');
                              msg.clear();
                            },
                            child: Icon(
                              Icons.send,
                              color: Color(gradientTwo),
                            ),
                          )
                        ],
                      )),
                ],
              )),
        ),
      ]),
    );
  }

  var chatRoom;
  var invitId;
  bool fromInvited;
  var curUser;
  var chats;
  var send;
  var img;
  var video;
  var imgMem;
  var status;
  List chatData = [];
  _ChatRoomState(this.chatRoom, this.invitId, this.fromInvited);
  TextEditingController msg = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  FlutterPusher pusher = new FlutterPusher(
      'ABCDEFG',
      PusherOptions(
        host: '10.0.2.2',
        port: 6001,
        encrypted: false,
      ));

  final imgPicker = ImagePicker();

  Future<void> _initPusher() async {
    await pusher.connect(
        onConnectionStateChange: (val) {
          setState(() {
            if (val.currentState == "CONNECTED") {
              status = null;
            } else if (val.currentState == "CONNECTING") {
              status = 'Menghubungkan..';
            } else if (val.currentState == "RECONNECTING") {
              status = 'Menghubungkan kembali..';
            } else {
              status = val.currentState;
            }
          });
        },
        onError: (err) {});

    await pusher
        .subscribe('chatRoom.${chatRoom['id']}')
        .bind("App\\Events\\newMsg", (e) async {
      if (this.mounted) {
        chatData.add(e['msg'][0]);
        _getMsgList();
      } else {
        var typeMsg = e['msg'][0]['type'];
        var sender = e['msg'][0]['user_id'];
        if (sender != curUser['id']) {
          await MainFunc().getUserData(e['msg'][0]['user_id']).then((value) {
            AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: 10,
                    channelKey: 'basic_channel',
                    title: value['name'],
                    body: typeMsg == 'text' ? e['msg'][0]['chat'] : typeMsg));
          });
        }
      }
    });

    await pusher
        .subscribe('user.${curUser['id']}')
        .bind("App\\Events\\notificationUsers", (e) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              title: e['notification']['type'],
              body: e['notification']['notification']));
    });
  }

  _showDi(content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: content,
          );
        });
  }

  _sendMsg(typeMsg) async {
    var data = {
      'user_one': curUser['id'],
      'chat_id': chatRoom['id'],
      'msg': msg.text,
      'type': typeMsg,
      'invitId': invitId,
      'sentTo': fromInvited ? chatRoom['user_satu_id'] : chatRoom['user_dua_id']
    };
    var res = await CallApi().postData(data, 'sendMsg');
    var body = jsonDecode(res.body);
    setState(() {
      send = body;
    });
  }

  _getMsgList() async {
    var data = {
      'chat_id': chatRoom['id'],
      'user_dua': chatRoom['user_dua_id'] == null
          ? chatRoom['user_satu_id']
          : chatRoom['user_dua_id']
    };
    var res = await CallApi().postData(data, 'getMsg');
    var body = jsonDecode(res.body);
    setState(() {
      chatData = body;
    });
  }

  _getuserId() async {
    var userId = await CallLocal().getLocalString('user');
    setState(() {
      curUser = jsonDecode(userId);
    });
  }

  @override
  void initState() {
    super.initState();
    _getMsgList();
    _initPusher();
    _getuserId();
  }

  _scrollToEnd() async {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  _getImage() async {
    final pickedImage = await imgPicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        img = pickedImage.path;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => MediaChat(
                    chatroom: chatRoom,
                    userId: curUser,
                    invit: invitId,
                    from: fromInvited,
                    file: pickedImage.path,
                    type: 'image',
                  )));
    }
  }

  _getVideo() async {
    final videoFile = await imgPicker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 30),
    );
    if (videoFile != null) {
      setState(() {
        video = videoFile.path;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => MediaChat(
                    chatroom: chatRoom,
                    userId: curUser,
                    invit: invitId,
                    from: fromInvited,
                    file: videoFile.path,
                    type: 'video',
                  )));
    }
  }
}
