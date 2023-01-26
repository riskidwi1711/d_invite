import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:d_invite/api/api.dart';
import 'package:d_invite/components/button.dart';
import 'package:d_invite/components/skeleton.dart';
import 'package:d_invite/components/topBar.dart';
import 'package:d_invite/const/config.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/const/function/mainFunc.dart';
import 'package:d_invite/page/homepage.dart';

import '../sendInvitation.dart';

class DetailInvitation extends StatefulWidget {
  final int invitationID;
  DetailInvitation({this.invitationID});

  @override
  _DetailInvitationState createState() => _DetailInvitationState(invitationID);
}

class _DetailInvitationState extends State<DetailInvitation> {
  int invitationId;
  String namaFile;
  bool isLoading = true;
  _DetailInvitationState(this.invitationId);

  void _getInvitationDetail() async {
    var data = {'id': invitationId};

    var res = await CallApi().postData(data, 'getDetailInvitation');
    var body = jsonDecode(res.body);

    setState(() {
      namaFile = body['content']['file_path'];
      isLoading = false;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(5),
            actionsPadding: EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            actions: [
              MyFlatButton(
                btnRounded: 10,
                btnColor: Color(gradientTwo),
                btnPadding: 5,
                btnFunc: () async {
                  var data = {
                    'id_undangan': invitationId
                  };
                  var res = await CallApi().postData(data, 'deleteInvitation');
                  var body = jsonDecode(res.body);
                  print(body);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => HomePage()));
                },
                btnName: 'Yakin',
                textSize: 16,
              ),
              MyFlatButton(
                btnRounded: 10,
                btnColor: Color(gradientTwo),
                btnPadding: 5,
                btnFunc: (){
                  Navigator.of(context).pop();
                },
                btnName: 'Tidak',
                textSize: 16,
              ),
            ],
            backgroundColor: Colors.white,
            content: SizedBox(
              height: 150,
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Apakah kamu yakin ?', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                  SizedBox(height:20,),
                  Text('Semua data terkait undangan ini akan ikut terhapus !', textAlign: TextAlign.center, style: TextStyle(fontSize: 18),)
                ],
              ),
            )
          );
        });
  }

  @override
  void initState() {
    _getInvitationDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
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
              child: MyTopBarWithBack(
                title: "Detail Undangan",
              )),
        ),
        Expanded(
          child: isLoading
              ? SkeletonDetailUndangan()
              : SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Image(image: NetworkImage('${base_url}savedtemplate/$namaFile'),)
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MyFlatButton(
                        btnFunc: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => SendPage(
                                        invitationID: invitationId,
                                      )));
                        },
                        btnHeight: 30,
                        btnName: 'Kirim Undangan',
                        textSize: 16,
                        btnColor: Color(gradientTwo),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      MyFlatButtonWithIcon(
                        content: Icon(Icons.share_rounded),
                        btnFunc: () async {
                          var pathFunc;
                          await MainFunc().saveNetworkImage(Uri.parse('${base_url}savedtemplate/$namaFile'))
                              .then((value){
                                if(this.mounted){
                                  pathFunc = value;
                                }
                          }).whenComplete(() => Share.shareFiles([pathFunc.path], text: 'Kamu diundang, silahkan unduh aplikasi untuk menggunakan fitur lain-nya '));
                        },
                        btnHeight: 30,
                        btnName: 'Bagikan',
                        textSize: 16,
                        btnColor: Color(gradientTwo),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      MyFlatButton(
                        btnFunc: () {
                          _showDialog();

                        },
                        btnHeight: 30,
                        btnName: 'Hapus Undangan',
                        textSize: 16,
                        btnColor: Colors.red,
                      )
                    ],
                  ),
                ),
        )
      ],
    );
  }




}
