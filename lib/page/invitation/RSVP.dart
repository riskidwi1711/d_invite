import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:d_invite/api/api.dart';
import 'package:d_invite/api/sharedPrefs/localStore.dart';
import 'package:d_invite/components/button.dart';
import 'package:d_invite/components/skeleton.dart';
import 'package:d_invite/const/config.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/page/invitation/chatRoom.dart';
import 'package:d_invite/page/sendInvitation.dart';

class Messages extends StatefulWidget {
  final invitationId;
  Messages({this.invitationId});

  @override
  _MessagesState createState() => _MessagesState(invitationId);
}

class _MessagesState extends State<Messages> {
  var invitationId;
  var curUser;
  _MessagesState(this.invitationId);
  var isLoading = true;
  var chatRoom;

  _getuserId() async {
    var userData = await CallLocal().getLocalString('user');
    var userId = jsonDecode(userData);

    if(userId != null){
      setState(() {
        curUser = userId['id'];
      });
    }else{
      userId = null;
    }

    _getChatRoom();
  }

  _getChatRoom() async {
    var userData = await CallLocal().getLocalString('user');
    var userId = jsonDecode(userData);
    var data = {'current_user_id': userId['id'], 'invitation_id': invitationId};

    var res = await CallApi().postData(data, 'getchatroom');
    var body = jsonDecode(res.body);

    if (body.length != 0 && body['content'].length > 0) {
      setState(() {
        chatRoom = body;
        isLoading = false;
      });
    } else {
      setState(() {
        chatRoom = null;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _getuserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          padding: EdgeInsets.all(20),
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
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Pesan',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => SendPage(
                                msg: true,
                                back: true,
                                invitationID: invitationId,
                              ))).then((value) {
                    setState(() {
                      _getChatRoom();
                    });
                  });
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              )
            ],
          )),
        ),
        Expanded(
          child: isLoading
              ? SkeletonProfile()
              : chatRoom== null ? Column(
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
                  'Belum ada pesan',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                  child: MyFlatButton(btnFunc: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => SendPage(
                              msg: true,
                              back: true,
                              invitationID: invitationId,
                            ))).then((value) {
                      setState(() {
                        _getChatRoom();
                      });
                    });
                  }, btnName: 'Kirim pesan',textSize: 16, btnHeight: 30, btnColor: Color(gradientOne),),
                )
              ])
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      itemCount: chatRoom['content'].length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => ChatRoom(invitId: invitationId, chatRoom: chatRoom['content'][index],))).then((value) {
                              _getChatRoom();
                            } );
                          },
                          child: Dismissible(
                            direction: DismissDirection.endToStart,
                            onDismissed: (dir) async {
                              var data = {
                                'id_guest': chatRoom['content'][index]['user_dua_id'], 'chat_room_id': chatRoom['content'][index]['id'], 'curr_user': curUser,
                              };

                              var res = await CallApi().postData(data, 'deleteGuestChat');
                              var body = jsonDecode(res.body);

                              if(body == 'success'){
                                _getChatRoom();
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
                                border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1, style: BorderStyle.solid))
                              ),
                              child: ListTile(
                                trailing:
                                    chatRoom['content'][index]['unread_msg'] <= 0
                                        ? null
                                        : Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                                color: Color(gradientTwo),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(999))),
                                            child: Text(
                                              chatRoom['content'][index]['unread_msg'].toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                title: Text(chatRoom['content'][index]['name']),
                                subtitle:
                                    Text('${chatRoom['content'][index]['last_msg']}'),
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(999)),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              '${base_url}img/${chatRoom['content'][index]['photo_profile']}'),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
        )
      ],
    );
  }
}
