import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:d_invite/api/api.dart';
import 'package:d_invite/components/button.dart';
import 'package:d_invite/components/card.dart';
import 'package:d_invite/components/confirmationComp.dart';
import 'package:d_invite/components/skeleton.dart';
import 'package:d_invite/const/config.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/const/function/qrCode.dart';
import 'package:d_invite/page/sendInvitation.dart';

class GuestLists extends StatefulWidget {
  final invitationId;
  GuestLists({this.invitationId});

  @override
  _GuestListsState createState() => _GuestListsState(invitationId);
}

class _GuestListsState extends State<GuestLists> {
  var invitationId;
  var guestLists;
  var sumConfirmedGuest;
  bool isLoading = true;
  _GuestListsState(this.invitationId);

  var buttonindex = 0;

  _getAllGuest() async {
    var data = {'invitationId': invitationId};

    var res = await CallApi().postData(data, 'getAllGuest');
    var body = jsonDecode(res.body);

    var get = await CallApi().getData('getCountConfirmedGuest/$invitationId');
    var getRes = jsonDecode(get.body);

    if (this.mounted) {
      setState(() {
        sumConfirmedGuest = getRes;
        guestLists = body;
        isLoading = false;
      });
    }
  }

  _getConfirmedGuest(String konfirmasi) async {
    isLoading = true;
    var data = {'undangan_id': invitationId, 'konfirmasi': konfirmasi};

    var res = await CallApi().postData(data, 'getConfirmedGuest');
    var body = jsonDecode(res.body);

    if (this.mounted) {
      setState(() {
        guestLists = body;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _getAllGuest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
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
                    'Daftar Tamu',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            QrCodeGen().scan(context);
                          },
                          child: Icon(
                            Icons.qr_code_scanner_rounded,
                            color: Colors.white,
                          )),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => SendPage(
                                          msg: false,
                                          back: true,
                                          invitationID: invitationId,
                                        ))).then((value) {
                              setState(() {
                                _getAllGuest();
                              });
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ))
                    ],
                  )
                ],
              )),
            ),
            isLoading
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight,
                              colors: [Color(gradientOne), Color(gradientTwo)]),
                          borderRadius: BorderRadius.circular(25)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _getAllGuest();
                            },
                            child: Confirmation(
                              color: Colors.white60,
                              value: 'Semua',
                              sum: '0',
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _getConfirmedGuest('datang');
                            },
                            child: Confirmation(
                                color: Colors.lightGreen,
                                value: 'Datang',
                                sum: '0'),
                          ),
                          GestureDetector(
                            onTap: () {
                              _getConfirmedGuest('mungkin');
                            },
                            child: Confirmation(
                                color: Colors.orange,
                                value: 'Mungkin',
                                sum: '0'),
                          ),
                          GestureDetector(
                            onTap: () {
                              _getConfirmedGuest('tidak datang');
                            },
                            child: Confirmation(
                                color: Colors.redAccent,
                                value: 'Tidak',
                                sum: '0'),
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight,
                              colors: [Color(gradientOne), Color(gradientTwo)]),
                          borderRadius: BorderRadius.circular(25)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                buttonindex = 0;
                              });
                              _getAllGuest();
                            },
                            child: Confirmation(
                              color: Colors.white60,
                              value: 'Semua',
                              sum: sumConfirmedGuest['semua'].toString(),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              buttonindex = 1;
                              _getConfirmedGuest('datang');
                            },
                            child: Confirmation(
                                color: Colors.lightGreen,
                                value: 'Datang',
                                sum: sumConfirmedGuest['datang'].toString()),
                          ),
                          GestureDetector(
                            onTap: () {
                              buttonindex = 2;
                              _getConfirmedGuest('mungkin');
                            },
                            child: Confirmation(
                                color: Colors.orange,
                                value: 'Mungkin',
                                sum: sumConfirmedGuest['mungkin'].toString()),
                          ),
                          GestureDetector(
                            onTap: () {
                              buttonindex = 3;
                              _getConfirmedGuest('tidak datang');
                            },
                            child: Confirmation(
                                color: Colors.redAccent,
                                value: 'Tidak',
                                sum: sumConfirmedGuest['tidak datang']
                                    .toString()),
                          ),
                        ],
                      ),
                    ),
                  )
          ],
        ),
        Expanded(
          child: isLoading
              ? SkeletonProfile()
              : guestLists.length <= 0
                  ? buttonindex == 0
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
                                'Belum ada tamu yang diundang nih',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 40, horizontal: 30),
                                child: MyFlatButton(
                                  btnFunc: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) => SendPage(
                                                  msg: false,
                                                  back: true,
                                                  invitationID: invitationId,
                                                ))).then((value) {
                                      setState(() {
                                        _getAllGuest();
                                      });
                                    });
                                  },
                                  btnName: 'Kirim undangan',
                                  textSize: 16,
                                  btnHeight: 30,
                                  btnColor: Color(gradientOne),
                                ),
                              )
                            ])
                      : Column(
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
                                'Belum ada tamu yang mengkonfirmasikan kedatangan nih', textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ])
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      itemCount: guestLists.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                            direction: DismissDirection.endToStart,
                            onDismissed: (dir) async {
                              var data = {
                                'id_guest': guestLists[index]['id'],
                                'undangan_id': invitationId
                              };

                              var res = await CallApi()
                                  .postData(data, 'deleteGuestById');
                              var body = jsonDecode(res.body);

                              if (body == 'success') {
                                _getAllGuest();
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
                            child: MyCardWithBorder(
                                title: guestLists[index]['name'],
                                linkImg:
                                    '${base_url}img/${guestLists[index]['photo_profile']}',
                                subTitle: guestLists[index]['no_handphone']));
                      }),
        )
      ],
    );
  }
}
