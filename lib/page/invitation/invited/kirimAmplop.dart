import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';
import 'package:d_invite/api/api.dart';
import 'package:d_invite/components/button.dart';
import 'package:d_invite/const/config.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:http/http.dart' as http;
import 'package:d_invite/const/my_flutter_app_icons.dart';

class SendMoney extends StatefulWidget {

  final createdInvitations;
  final userId;
  SendMoney({this.createdInvitations, this.userId});

  @override
  _SendMoneyState createState() => _SendMoneyState(createdInvitations, userId);
}

class _SendMoneyState extends State<SendMoney> {

  var createdInvitations;
  var userId;
  _SendMoneyState(this.createdInvitations, this.userId);
  var isloading = true;
  var createdInvitation;
  var isLoadingUpload = false;


  void _getInvitationDetail() async {

    var res = await CallApi().getData('getAmplop/${createdInvitations['undangan_id']}');
    var body = jsonDecode(res.body);

    if (body.length != 0 && body['content'].length > 0) {
      setState(() {
        createdInvitation = body['content'][0];
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
    _getInvitationDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: isloading ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(gradientTwo),
                valueColor:
                AlwaysStoppedAnimation<Color>(Color(gradientOne)),
              )) : createdInvitation == null ? Column(
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
                  'Pemilik undangan belum mengatur amplop',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                  child: MyFlatButton(btnFunc: (){
                    Navigator.pop(context);
                  }, btnName: 'Kembali',textSize: 16, btnHeight: 30, btnColor: Color(gradientOne),),
                )
              ]) : Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 50),
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
                          "Kirim Amplop",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 24, color: Color(gradientOne)),
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
                    height: MediaQuery.of(context).size.height-120,
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
                      height: 450,
                      decoration: BoxDecoration(
                          color: Color(gradientOne),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: 10,),
                              Container(
                                padding: EdgeInsets.all(20),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: isLoadingUpload ? Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Color(gradientTwo),
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                                    )) : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Bank ${createdInvitation['bank']}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),),
                                        Text('No.Rek ${createdInvitation['no_rekening']}', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 24),),
                                        Text('a/n ${createdInvitation['pemilik_rekening']}', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 21),),
                                      ],
                                    ),
                                    SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap:(){
                                            Share.share('${createdInvitation['no_rekening']}');
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            child: Icon(Icons.share_rounded, color: Colors.white,),
                                            decoration: BoxDecoration(
                                                color: Color(gradientOne),
                                                borderRadius: BorderRadius.circular(999)
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 20,),
                              MyFlatButton(btnFunc: (){
                                getImage();
                              }, btnName: 'Kirim bukti pembayaran', btnHeight: 30, textSize: 18, btnColor: Colors.blueGrey, btnRounded: 15,),
                              SizedBox(height: 10,),
                              MyFlatButton(btnFunc: (){
                                Navigator.pop(context);
                              }, btnName: 'Kembali', btnHeight: 30, textSize: 18, btnColor: Colors.blueGrey,  btnRounded: 15,),
                              SizedBox(height: 20,),
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
                              image: AssetImage('assets/img/Illustrations.png')
                            )
                          ),
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

  final picker = ImagePicker();
  var _image;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        showDialogs(context, _image, true);
      } else {
        showDialogs(context, Text('Pilih foto terlebih dahulu'), false);
      }
    });
  }

  void _uploadPhoto() async {

    setState(() {
      isLoadingUpload = true;
    });
    String respon;
    var uri = Uri.parse('${base_url}api/sendBukti');
    var req = new http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', _image.path));
    req.fields['id'] = createdInvitation['id'].toString();
    req.fields['ids'] = createdInvitations['user_id'].toString();
    req.fields['user_id'] = userId.toString();
    final res = await req.send();
    print(createdInvitations['user_id']);
    if (res.statusCode == 200) {
      respon = String.fromCharCodes(await res.stream.toBytes());
      print(respon);
      setState(() {
        isLoadingUpload = false;
        showDialogs(context, Text('Berhasil upload bukti pembayaran'), false);
      });
    }else{
      setState(() {
        isLoadingUpload = false;
        showDialogs(context, Text('Gagal'), false);
      });
    }
  }

  void showDialogs(BuildContext context, content, bool image){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            actionsPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            titlePadding: EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            title: Center(child: new Text('Upload Bukti')),
            content: image ? Image.file(content) : content,
            actions: image ? <Widget>[
                MyFlatButton(
                btnHeight: 30,
                btnColor: Color(gradientOne),
                btnFunc: () {
                  Navigator.pop(context);
                  _uploadPhoto();
                },
                btnName: 'Upload',
                textSize: 16,
              ), MyFlatButton(
                btnHeight: 30,
                btnColor: Color(gradientOne),
                btnFunc: () {
                  Navigator.pop(context);
                },
                btnName: 'Batal',
                textSize: 16,
              )
            ] : [MyFlatButton(btnFunc: (){
            Navigator.pop(context);
          }, btnName: 'Ok', textSize: 16, btnColor: Color(gradientOne), btnHeight: 30,),]
          );
        });
  }

}
