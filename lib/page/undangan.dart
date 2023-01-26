import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:d_invite/api/api.dart';
import 'package:d_invite/api/sharedPrefs/localStore.dart';
import 'package:d_invite/components/big_component/AppBar.dart';
import 'package:d_invite/components/button.dart';
import 'package:d_invite/components/card.dart';
import 'package:d_invite/components/confusingComp.dart';
import 'package:d_invite/components/skeleton.dart';
import 'package:d_invite/const/config.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/page/invitation/basePage.dart';
import 'package:d_invite/page/invitation/invited/invitedHome.dart';

class UndanganPage extends StatefulWidget {
  @override
  _UndanganPageState createState() => _UndanganPageState();
}

class _UndanganPageState extends State<UndanganPage> {
  bool isLoading = true;
  var undangan;
  var currentUser;
  var menu = false;
  int select = 0;
  @override
  void initState() {
    super.initState();
    getAllUndangan();
  }

  void getAllUndangan() async {
    var id = await CallLocal().getLocalString('user');
    var ids = jsonDecode(id);
    var data = {
      'id': ids['id'],
    };
    var res = await CallApi().postData(data, 'invitation');
    var body = jsonDecode(res.body);
    if (this.mounted) {
      setState(() {
        currentUser = ids;
        undangan = body;
        isLoading = false;
        menu = false;
      });
    }
  }

  void getInvited() async {
    var id = await CallLocal().getLocalString('user');
    var ids = jsonDecode(id);
    var data = {
      'id': ids['id'],
    };
    var res = await CallApi().postData(data, 'invited');
    var body = jsonDecode(res.body);
    if (this.mounted) {
      setState(() {
        undangan = body;
        isLoading = false;
        menu = true;
      });
    }
  }

  void onTapItem(int index) {
    setState(() {
      select = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              InvitationAppBar(),
              Expanded(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        child: MyFlatButton(
                          btnName: index == 0 ? 'Mengundang' : 'Di Undang',
                          btnRounded: 13,
                          btnFunc: () {
                            onTapItem(index);
                            index == 0 ? getAllUndangan() : getInvited();
                          },
                          btnColor: select != index
                              ? Colors.grey
                              : Color(gradientOne),
                          textSize: 16,
                          btnWidth: MediaQuery.of(context).size.width / 2 - 35,
                        ));
                  },
                ),
              )
            ],
          ),
        ),
        Expanded(
            child: isLoading
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SkeletonHomeTemplate(),
                  )
                : undangan['content'].length <= 0
                    ? menu
                        ? ConfussingComponent(
                            title: 'Belum ada yang mengundang kamu',
                          )
                        : ConfussingComponent(
                            title: 'Kamu belum membuat undangan',
                          )
                    : GridView.builder(
                        itemCount: undangan['content'].length,
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? 3
                              : 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: (1 / 1.3),
                        ),
                        itemBuilder: (BuildContext context, int i) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => menu
                                          ? InvitedHome(
                                              undangan: undangan['content'][i],
                                              currentUser: currentUser['id'],
                                            )
                                          : BaseInvitationPage(
                                              invitationId: undangan['content']
                                                  [i]['id'],
                                            )));
                            },
                            child: MyCardSimpleWithImgAssets(
                              assets:
                                  '${base_url}savedtemplate/${undangan['content'][i]['file_path']}',
                              radius: 15,
                              boxFit: BoxFit.fitWidth,
                              cardColor: Colors.white30,
                            ),
                          );
                        }))
      ],
    );
  }
}
