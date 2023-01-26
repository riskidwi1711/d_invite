import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:d_invite/api/api.dart';
import 'package:d_invite/components/button.dart';
import 'package:d_invite/components/textFormField.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/const/function/mainFunc.dart';
import 'package:d_invite/const/my_flutter_app_icons.dart';
import 'package:d_invite/page/previewPage.dart';

class SetUpAmplop extends StatefulWidget {
  final createdInvitation;
  final invitationId;
  SetUpAmplop({this.createdInvitation, this.invitationId});

  @override
  _SetUpAmplopState createState() =>
      _SetUpAmplopState(createdInvitation, invitationId);
}

class _SetUpAmplopState extends State<SetUpAmplop> {
  var createdInvitation;
  var invitationId;
  _SetUpAmplopState(this.createdInvitation, this.invitationId);
  var bank;
  bool isloading = true;

  TextEditingController pemilikRek = new TextEditingController();
  TextEditingController noRek = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isloading
            ? Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                MyFlutterApp.money_bill_wave_alt,
                                size: 33,
                                color: Color(gradientOne),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Atur Amplop",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                    color: Color(gradientOne)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: Stack(children: [
                        Container(
                          height: MediaQuery.of(context).size.height - 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            padding: EdgeInsets.only(top: 38),
                            height: 450,
                            decoration: BoxDecoration(
                                color: Color(gradientOne),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 20, top: 20),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyTextForm(
                                            hintText: "No Rekening",
                                            bordered: true,
                                            type: TextInputType.number,
                                            textEditingController: noRek,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          AppDropDownInput(
                                            hint: 'Pilih Bank',
                                            option: [
                                              'BNI',
                                              'BRI',
                                              'Mandiri',
                                              'Cimb Niaga',
                                              'BCA',
                                              'Mandiri Syariah',
                                              'BRI Syariah',
                                              'BNI Syariah',
                                              'Bank Syariah Indonesia (BSI)'
                                            ],
                                            value: bank,
                                            onChanged: (dynamic value) {
                                              setState(() {
                                                bank = value;
                                              });
                                            },
                                            getLabel: (dynamic value) => value,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          MyTextForm(
                                            hintText: "Atas Nama",
                                            bordered: true,
                                            textEditingController: pemilikRek,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    MyFlatButton(
                                      btnFunc: () {
                                        if(pemilikRek.text.isEmpty && noRek.text.isEmpty){
                                          MainFunc().pushDialog('Masukan data dengan benar', 'Error', context);
                                        }else{
                                          createAmplop().then((value) => print('hello'));
                                        }
                                      },
                                      btnName: 'Simpan',
                                      btnHeight: 30,
                                      textSize: 18,
                                      btnColor: Colors.blueGrey,
                                      btnRounded: 15,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    MyFlatButton(
                                      btnFunc: () {
                                        if (invitationId == null) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (builder) =>
                                                      PreviewInvitation(
                                                          createdInvitation:
                                                              createdInvitation)));
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      },
                                      btnName: invitationId != null
                                          ? 'kembali'
                                          : 'Lewati',
                                      btnHeight: 30,
                                      textSize: 18,
                                      btnColor: Colors.blueGrey,
                                      btnRounded: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            child: Center(
                              child: Container(
                                height: 300,
                                width: 400,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fitWidth,
                                        image: AssetImage(
                                            'assets/img/Illustrations.png'))),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> createAmplop() async {
    print(createdInvitation);
    var data = {
      'undangan_id': createdInvitation['content']['id'],
      'nama_bank': bank,
      'rekening': noRek.text,
      'pemilik': pemilikRek.text,
    };

    await CallApi().postData(data, 'createAmplop');
    if (invitationId == null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (builder) => PreviewInvitation(
                    createdInvitation: createdInvitation,
                  )));
    } else {
      Navigator.pop(context);
    }
  }

  void _getInvitationDetail() async {
    var data = {'id': invitationId};

    var res = await CallApi().postData(data, 'getDetailInvitation');
    var body = jsonDecode(res.body);

    if (body.length != 0 && body['content'].length > 0) {
      setState(() {
        createdInvitation = body;
        isloading = false;
      });
    } else {
      setState(() {
        createdInvitation = null;
        isloading = false;
      });
    }
  }

  @override
  void initState() {
    if (createdInvitation == null && invitationId != null) {
      _getInvitationDetail();
    } else {
      setState(() {
        isloading = false;
      });
    }
    super.initState();
  }
}
