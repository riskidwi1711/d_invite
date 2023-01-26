import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:d_invite/api/api.dart';
import 'package:d_invite/api/sharedPrefs/localStore.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/const/my_flutter_app_icons.dart' ;
import 'package:d_invite/page/invitation/RSVP.dart';
import 'package:d_invite/page/invitation/guestLists.dart';
import 'package:d_invite/page/invitation/others.dart';
import 'detailInvitation.dart';

class BaseInvitationPage extends StatefulWidget {
  final int invitationId;
  BaseInvitationPage({required this.invitationId});

  @override
  _BaseInvitationPageState createState() =>
      _BaseInvitationPageState(invitationId);
}

class _BaseInvitationPageState extends State<BaseInvitationPage> {
  int _selectedItem = 0;
  int invitationId;
  var chatRoom;
  _BaseInvitationPageState(this.invitationId);

  void _onTapItem(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  _getChatRoom() async {
    var userData = await CallLocal().getLocalString('user');
    var userId = jsonDecode(userData);
    var data = {
      'current_user_id': userId['id'],
      'invitation_id': widget.invitationId
    };

    var res = await CallApi().postData(data, 'getchatroom');
    var body = jsonDecode(res.body);

    setState(() {
      chatRoom = body;
    });
  }

  @override
  void initState() {
    _getChatRoom();
    super.initState();
  }

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
                Icons.inbox_outlined,
              ),
              label: "Detail",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: "Tamu"),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: "Pesan"),
            BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.money_bill_wave_alt), label: "Amplop"),
          ],
        ),
        body:  (_selectedItem == 0
                ? DetailInvitation(
                    invitationID: invitationId,
                  )
                : (_selectedItem == 1
                    ? GuestLists(
                        invitationId: invitationId,
                      )
                    : (_selectedItem == 2
                        ? Messages(
                            invitationId: invitationId,
                          )
                        : (_selectedItem == 3
                            ? OthersPage(invitationId: invitationId,)
                            : DetailInvitation())))));
  }
}
