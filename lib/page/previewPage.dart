import 'package:flutter/material.dart';
import 'package:d_invite/components/button.dart';
import 'package:d_invite/components/card.dart';
import 'package:d_invite/components/topBar.dart';
import 'package:d_invite/const/config.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/page/sendInvitation.dart';

class PreviewInvitation extends StatefulWidget {
  final createdInvitation;
  PreviewInvitation({this.createdInvitation});

  @override
  _PreviewInvitationState createState() => _PreviewInvitationState(createdInvitation);
}

class _PreviewInvitationState extends State<PreviewInvitation> {

  var createdInvitation;
  _PreviewInvitationState(this.createdInvitation);

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: MyTopBarWithBack(title: 'Tampilan Undangan',)),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height-100,
                    width: MediaQuery.of(context).size.width,
                    child: MyCardSimpleWithImgAssets(
                      assets: '${base_url}savedtemplate/${createdInvitation['content']['file_path']}',
                      radius: 15,
                      boxFit: BoxFit.cover,
                      cardColor: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 20,),
                  MyFlatButton(
                    btnHeight: 30,
                    btnFunc: () {

                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>SendPage(invitationID: createdInvitation['content']['id'], back: false, msg: false,)));
                  }, btnName: 'Kirim Undangan', btnColor: Color(gradientTwo),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
