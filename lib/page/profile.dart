import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:d_invite/api/api.dart';
import 'package:d_invite/api/sharedPrefs/localStore.dart';
import 'package:d_invite/components/button.dart';
import 'package:d_invite/components/skeleton.dart';
import 'package:d_invite/components/textFormField.dart';
import 'package:d_invite/const/config.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/const/function/mainFunc.dart';
import 'package:d_invite/page/loginReg.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userData;
  bool isEditUser = false;
  bool isLoading = true;
  bool showButton = false;
  var imageName;
  File _image;
  TextEditingController nama = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController noHp = TextEditingController();
  TextEditingController alamat = TextEditingController();

  @override
  void initState() {
    _getUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 180,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(gradientOne), Color(gradientTwo)]),
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showButton = !showButton;
                          });
                        },
                        child: Container(
                          child: showButton
                              ? GestureDetector(
                                  onTap: () {
                                    getImage();
                                  },
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey,
                                  ))
                              : null,
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      '${base_url + 'img/' + imageName}')),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(999))),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ]),
              ),
      ),
      Expanded(
        child: isLoading
            ? SkeletonProfile()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                      style: BorderStyle.solid))),
                          child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Nama'),
                            subtitle: isEditUser
                                ? Container(
                                    height: 50,
                                    child: MyTextForm(
                                      onchange: (value) {
                                        value.toString().isNotEmpty
                                            ? setState(() {
                                                nama.text = value;
                                              })
                                            : setState(() {
                                                nama.text = userData['name'];
                                              });
                                      },
                                      hintText: userData['name'],
                                      bordered: false,
                                    ),
                                  )
                                : Text(userData['name']),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                      style: BorderStyle.solid))),
                          child: ListTile(
                            leading: Icon(Icons.alternate_email),
                            title: Text('Email'),
                            subtitle: isEditUser
                                ? Container(
                                    height: 50,
                                    child: MyTextForm(
                                      textEditingController: email,
                                      onchange: (value) {
                                        value.toString().isNotEmpty
                                            ? setState(() {
                                                nama.text = value;
                                              })
                                            : setState(() {
                                                nama.text = userData['email'];
                                              });
                                      },
                                      hintText: userData['email'],
                                      bordered: false,
                                    ),
                                  )
                                : Text(userData['email']),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                      style: BorderStyle.solid))),
                          child: ListTile(
                            leading: Icon(Icons.phone),
                            title: Text('No Handphone'),
                            subtitle: isEditUser
                                ? Container(
                                    height: 50,
                                    child: MyTextForm(
                                      onchange: (value) {
                                        value.toString().isNotEmpty
                                            ? setState(() {
                                                nama.text = value;
                                              })
                                            : setState(() {
                                                nama.text =
                                                    userData['no_handphone'];
                                              });
                                      },
                                      textEditingController: noHp,
                                      hintText: userData['no_handphone'],
                                      bordered: false,
                                    ),
                                  )
                                : Text(userData['no_handphone']),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                      style: BorderStyle.solid))),
                          child: ListTile(
                            leading: Icon(Icons.house_outlined),
                            title: Text('Alamat'),
                            subtitle: isEditUser
                                ? Container(
                                    height: 50,
                                    child: MyTextForm(
                                      onchange: (value) {
                                        value.toString().isNotEmpty
                                            ? setState(() {
                                                nama.text = value;
                                              })
                                            : setState(() {
                                                nama.text =
                                                    userData['user_data']
                                                        ['alamat'];
                                              });
                                      },
                                      textEditingController: alamat,
                                      hintText: userData['user_data']['alamat'],
                                      bordered: false,
                                    ),
                                  )
                                : Text(userData['user_data']['alamat']),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      isEditUser
                          ? MyFlatButton(
                              btnHeight: 30,
                              textSize: 16,
                              btnColor: Color(gradientTwo),
                              btnFunc: () {
                                _editProfile();
                              },
                              btnName: 'Save')
                          : MyFlatButton(
                              btnHeight: 30,
                              btnFunc: () {
                                setState(() {
                                  isEditUser = true;
                                });
                              },
                              btnRounded: 17,
                              textSize: 16,
                              btnName: 'Edit Profil',
                              btnColor: Color(gradientTwo),
                            ),
                      SizedBox(
                        height: 5,
                      ),
                      !isEditUser
                          ? MyFlatButton(
                              btnHeight: 30,
                              textSize: 16,
                              btnFunc: () async {
                               await MainFunc().handleLogout().whenComplete(() =>
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                LoginPage())));
                              },
                              btnRounded: 17,
                              btnColor: Colors.red.shade700,
                              btnName: 'Log Out')
                          : MyFlatButton(
                              btnColor: Colors.red.shade700,
                              btnHeight: 30,
                              textSize: 16,
                              btnFunc: () {
                                setState(() {
                                  isEditUser = false;
                                });
                              },
                              btnRounded: 17,
                              btnName: 'Batal'),
                    ],
                  ),
                ),
              ),
      )
    ]);
  }

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });

        _editPhoto();
      } else {
        print('No image selected.');
      }
    });
  }

  void _editPhoto() async {
    String respon;
    var uri = Uri.parse('${base_url}api/uploadPhotoProfile');
    var req = new http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', _image.path));
    req.fields['id'] = userData['id'].toString();

    final res = await req.send();
    if (res.statusCode == 200) {
      respon = String.fromCharCodes(await res.stream.toBytes());
      await CallLocal().setLocalString('imgName', respon);
      var imgName = await CallLocal().getLocalString('imgName');
      setState(() {
        imageName = imgName;
      });
    }
  }

  void _showDialog(BuildContext context, String msg, String status) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            title: new Text(status[0].toUpperCase() + status.substring(1)),
            content: new Text(msg[0].toUpperCase() + msg.substring(1)),
            actions: <Widget>[
              new MyFlatButton(
                btnRounded: 10,
                btnColor: Color(gradientTwo),
                btnPadding: 5,
                btnFunc: () {
                  Navigator.of(context).pop();
                },
                btnName: 'Ok',
                textSize: 12,
              ),
            ],
          );
        });
  }

  void _getUserProfile() async {
    var userProfile = await CallLocal().getLocalString('user');
    var imgName = await CallLocal().getLocalString('imgName');
    if (this.mounted) {
      setState(() {
        userData = jsonDecode(userProfile);
        imageName = imgName;
        isLoading = false;
        nama.text = userData['name'];
        email.text = userData['email'];
        noHp.text = userData['no_handphone'];
        alamat.text = userData['user_data']['alamat'];
      });
    }
  }

  void _editProfile() async {
    isLoading = true;
    var data = {
      'id': userData['id'],
      'nama': nama.text,
      'email': email.text,
      'no_handphone': noHp.text,
      'alamat': alamat.text,
    };
    var res = await CallApi().postData(data, 'editProfile');
    var body = jsonDecode(res.body);
    await CallLocal().setLocalString('user', jsonEncode(body['content']));

    _showDialog(context, body['msg'], body['status']);

    if (body['status'] == 'success') {
      setState(() {
        isLoading = false;
        isEditUser = false;
        userData = body['content'];
        imageName = userData['user_data']['photo_profile'];
      });
    }
    print(body);
  }
}
