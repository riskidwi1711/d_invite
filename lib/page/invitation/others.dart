import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:d_invite/api/api.dart';
import 'package:d_invite/components/button.dart';
import 'package:d_invite/components/skeleton.dart';
import 'package:d_invite/const/config.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/page/setUpAmplop.dart';

class OthersPage extends StatefulWidget {
  final invitationId;
  OthersPage({this.invitationId});

  @override
  _OthersPageState createState() => _OthersPageState(invitationId);
}

class _OthersPageState extends State<OthersPage> {
  var invitationId;
  _OthersPageState(this.invitationId);
  var amplop;
  var listPembayaran;
  bool isloading = true;

  void getBuktiPembayaran(id) async {
    isloading = true;
    var data = {'id': id};
    var res = await CallApi().postData(data, 'listPembayaran');
    var body = jsonDecode(res.body);
    if (body.length != 0 && body['content'].length > 0) {
      setState(() {
        listPembayaran = body['content'];
        isloading = false;
      });
    } else {
      setState(() {
        listPembayaran = null;
        isloading = false;
      });
    }
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Text(
                  'Amplop',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ])),
        ),
        Expanded(
          child: isloading
              ? SkeletonProfile()
              : amplop == null
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
                            'Sepertinya kamu belum mengatur amplop',
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
                                        builder: (builder) => SetUpAmplop(
                                              invitationId: invitationId,
                                              createdInvitation: null,
                                            ))).then((value) {
                                  setState(() {
                                    getAmplop();
                                  });
                                });
                              },
                              btnName: 'Atur amplop sekarang',
                              textSize: 16,
                              btnHeight: 30,
                              btnColor: Color(gradientOne),
                            ),
                          )
                        ])
                  : listPembayaran == null
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
                                'Belum ada yang mengirimkan bukti amplop',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ])
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          itemCount: listPembayaran.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 7),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade400,
                                        offset: Offset(0, 1),
                                        spreadRadius: 0,
                                        blurRadius: 5)
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 1,
                                                  style: BorderStyle.solid))),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(999)),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  80,
                                              child: Text(
                                                '${listPembayaran[index]['name']} telah mengirimkan bukti pembayaran nih',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.2),
                                              ))
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialogs(
                                            context,
                                            Image(
                                              image: NetworkImage(
                                                  '${base_url}img/buktiPembayaran/${listPembayaran[index]['bukti_pembayaran']}'),
                                            ));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.remove_red_eye),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text('Lihat bukti')
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
        )
      ],
    );
  }

  void getAmplop() async {
    var res = await CallApi().getData('getAmplop/$invitationId');
    var body = jsonDecode(res.body);

    if (body.length != 0 && body['content'].length > 0) {
      setState(() {
        amplop = body['content'][0];
        isloading = false;
      });
      getBuktiPembayaran(amplop['id']);
    } else {
      setState(() {
        amplop = null;
        isloading = false;
      });
    }
  }

  void showDialogs(BuildContext context, content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            titlePadding: EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: content,
          );
        });
  }

  @override
  void initState() {
    getAmplop();
    super.initState();
  }
}
