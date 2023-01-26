import 'dart:convert';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:d_invite/api/api.dart';
import 'package:d_invite/api/sharedPrefs/localStore.dart';
import 'package:d_invite/components/button.dart';
import 'package:d_invite/components/confusingComp.dart';
import 'package:d_invite/components/topBar.dart';
import 'package:d_invite/const/config.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/const/function/mainFunc.dart';
import 'package:d_invite/page/invitation/basePage.dart';
import 'package:d_invite/page/invitation/chatRoom.dart';

class SendPage extends StatefulWidget {
  final bool msg;
  final invitationID;
  final bool back;
  SendPage({this.invitationID, this.back = false, this.msg = false});

  @override
  _SendPageState createState() => _SendPageState(invitationID, back, msg);
}

class _SendPageState extends State<SendPage> {
  var msg;
  var invitationID;
  var back;
  _SendPageState(this.invitationID, this.back, this.msg);
  bool isLoading = true;
  bool isGranted = false;
  List<int> _selectedList = [];
  List<bool> isCheked = [];
  Iterable<Contact> _contacts = [];
  var phones;
  var registeredContact;
  var newF;
  var chatRoom;

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts];
    } else {
      return permission;
    }
  }

  checkIsGranted() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      getContacts();
      setState(() {
        isGranted = true;
      });
    } else {
      setState(() {
        isGranted = false;
      });
    }
  }

  Future<void> getContacts() async {
    Iterable<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);

    setState(() {
      _contacts = contacts.toList();
    });

    if (msg) {
      _getAllGuest();
    } else {
      getRegisteredContact();
    }
  }

  getRegisteredContact() async {
    isLoading = true;
    List phone = List.from(
        _contacts.map((e) => e.phones.map((e) => e.value.toString())));
    var userData = await CallLocal().getLocalString('user');
    var userId = jsonDecode(userData);
    var data = {
      'uid': userId['id'],
      'phones': phone.toString(),
    };

    var res = await CallApi().postData(data, 'getUserPhone');
    var body = jsonDecode(res.body);
    setState(() {
      registeredContact = body;
      isLoading = false;
    });

  }

  sendInvitation() async {
    var userData = await CallLocal().getLocalString('user');
    var userId = jsonDecode(userData);
    var data = {'userInvited': _selectedList, 'invitationId': invitationID, 'uid': userId['id']};
    await CallApi().postData(data, 'sendInvitation');
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (builder) => BaseInvitationPage(
                invitationId: invitationID
            )));
  }

  _getAllGuest() async {
    var data = {'invitationId': invitationID};

    var res = await CallApi().postData(data, 'getAllGuest');
    var body = jsonDecode(res.body);

    setState(() {
      registeredContact = body;
      isLoading = false;
    });
  }

  _createChatRoom(sentTo) async {
    isLoading = true;
    var userData = await CallLocal().getLocalString('user');
    var userId = jsonDecode(userData);
    var data = {
      'user_one': userId['id'],
      'user_two': sentTo,
      'invitation_id': invitationID,
      'last_msg': "Kirim Pesan",
      'unread': null
    };

    var res = await CallApi().postData(data, 'createChat');
    var body = jsonDecode(res.body);

    setState(() {
      isLoading = false;
      chatRoom = body;
    });

    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => ChatRoom(invitId: invitationID,chatRoom: chatRoom['content'].first)));
  }

  @override
  void initState() {
    super.initState();
    checkIsGranted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isGranted
          ? !msg
              ? FloatingActionButton(
                  child: Icon(Icons.send),
                  backgroundColor: Color(gradientTwo),
                  onPressed: () {
                    if(_selectedList.isEmpty){
                      MainFunc().pushDialog('Setidaknya pilih salah satu kontak', 'Error', context);
                    }else{
                      sendInvitation();
                    }
                    if(back){
                      Navigator.pop(context);
                    }
                  },
                )
              : null
          : null,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTopBarWithBack(
                      title: msg ? "Kirim Pesan" : "Kirim Undangan",
                    ),
                    !msg ? GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => BaseInvitationPage(
                                    invitationId: invitationID
                                )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text('Lewati', style: TextStyle(fontSize: 16, color: Colors.white ),),
                      ),
                    ) : Container()
                  ],
                )),
          ),
          Expanded(
            child: !isGranted
                ? SizedBox(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: MyFlatButton(
                          btnFunc: () async {
                            final PermissionStatus permissionStatus =
                            await _getPermission();
                            if (permissionStatus ==
                                PermissionStatus.granted) {
                              setState(() {
                                isGranted = true;
                              });
                            } else {
                              setState(() {
                                isGranted = false;
                              });
                            }
                          },
                          btnColor: Color(gradientOne),
                          textSize: 16,
                          btnHeight: 30,
                          btnName: 'Izinkan akses Kontak',
                        ),
                      ),
                    ),
                  )
                : isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        backgroundColor: Color(gradientTwo),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                      ))
                    : msg
                        ? ListView.builder(
                            itemCount: registeredContact.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1, style: BorderStyle.solid))
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      _createChatRoom(
                                          registeredContact[index]['id']);
                                    },
                                    child: ListTile(
                                      title: Text(
                                          registeredContact[index]['name']),
                                      subtitle: Text(registeredContact[index]
                                          ['no_handphone']),
                                      leading: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(999)),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    '${base_url}img/${registeredContact[index]['photo_profile']}'),
                                                fit: BoxFit.cover)),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                        : registeredContact['content'] == null ? ConfussingComponent(title: 'Tidak ada kontak yang terdaftar',) : ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            itemCount: registeredContact['content'].length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1, style: BorderStyle.solid))
                                ),
                                child: StatefulBuilder(
                                  builder: (context, _setState) =>
                                      CheckboxListTile(
                                        secondary: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(9999)),
                                            color: Colors.grey,
                                            image: DecorationImage(
                                              image: NetworkImage('${base_url}img/${registeredContact['content'][index]['photo_profile']}')
                                            )
                                          ),
                                        ),
                                    onChanged: (bool value) {
                                      if (value) {
                                        _setState(() => _selectedList.add(
                                            registeredContact['content']
                                                [index]['id']));
                                      } else {
                                        _setState(() => _selectedList.remove(
                                            registeredContact['content']
                                                [index]['id']));
                                      }
                                    },
                                    value: _selectedList.contains(
                                        registeredContact['content'][index]
                                            ['id']),
                                    title: Text(registeredContact['content']
                                        [index]['name']),
                                    subtitle: Text(
                                        registeredContact['content'][index]
                                            ['no_handphone']),
                                  ),
                                ),
                              );
                            }),
          )
        ],
      ),
    );
  }
}
