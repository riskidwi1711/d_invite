import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:d_invite/api/api.dart';
import 'package:d_invite/components/button.dart';
import 'package:d_invite/components/textFormField.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/page/homepage.dart';


class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {



  //state
  bool isLoading = false;
  bool isLoginPage = false;

  //text edit control for login
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  //text edit control for register
  TextEditingController namaEditingController = new TextEditingController();
  TextEditingController emailRegEditingController = new TextEditingController();
  TextEditingController passwordRegEditingController =
      new TextEditingController();
  TextEditingController noHpEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          reverse: true,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                //Button Action
                Positioned(
                  bottom: 20,
                  child: isLoginPage
                      ? Column(
                          children: [
                            MyFlatButton(
                              btnFunc: () {
                                if(isLoading){
                                  handleLogin();
                                }
                              },
                              btnName: isLoading ? "Proses.." : "Masuk",
                              btnWidth: MediaQuery.of(context).size.width - 50,
                              btnColor: Color(gradientTwo),

                              btnRounded: 10,
                              btnPadding: 15,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyFlatButton(
                              btnFunc: () {
                                setState(() {
                                  isLoginPage = false;
                                });
                              },
                              btnName: "Daftar",
                              btnWidth: MediaQuery.of(context).size.width - 50,
                              btnColor: Color(gradientTwo),

                              btnRounded: 10,
                              btnPadding: 15,
                            )
                          ],
                        )
                      : Column(
                          children: [
                            MyFlatButton(
                              btnFunc: () {
                                if(isLoading){
                                  handleRegister();
                                }
                              },
                              btnName: isLoading ? "Proses..." : "Daftar",
                              btnWidth: MediaQuery.of(context).size.width - 50,
                              btnColor: Color(gradientTwo),
                              btnRounded: 10,
                              btnPadding: 15,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Sudah memiliki akun?',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isLoginPage = true;
                                    });
                                  },
                                  child: Text(
                                    ' Masuk',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color(gradientOne),
                                        fontWeight: FontWeight.w300),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                ),

                //Form Field
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(gradientOne), Color(gradientTwo)])),
                  padding: EdgeInsets.only(left: 25, right:25, top: 30),
                  height: MediaQuery.of(context).size.height -
                      (isLoginPage ? 200 : 120),
                  width: MediaQuery.of(context).size.width,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'D-Invite',
                          style: TextStyle(
                            fontFamily: 'Pattaya',
                            fontSize: 48,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Aplikasi pembuatan undangan digital',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 24,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        isLoginPage
                            ? Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height - 450,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    color: Colors.white),
                                child: Center(
                                  child: SingleChildScrollView(
                                    primary: true,
                                    reverse: true,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Masuk',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          'Masukan data yang dibutuhkan dengan benar',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        MyTextForm(
                                            bordered: true,
                                          textEditingController:
                                              emailEditingController,
                                          hintText: 'E-Mail',
                                          prefixIcon: Icon(Icons.alternate_email)
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        MyTextForm(
                                            bordered: true,
                                          textEditingController:
                                              passwordEditingController,
                                          obscureText: true,
                                          hintText: 'password',
                                          prefixIcon: Icon(Icons.vpn_key)
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height - 370,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    color: Colors.white),
                                child: SingleChildScrollView(
                                  primary: true,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Mendaftar',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        'Masukan data yang dibutuhkan dengan benar',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      MyTextForm(
                                        onchange: (){},
                                        bordered: true,
                                        textEditingController:
                                            namaEditingController,
                                        hintText: 'Nama',
                                        prefixIcon: Icon(Icons.perm_contact_cal_outlined), textInputType: TextInputType.text,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      MyTextForm(
                                          bordered: true,
                                        textEditingController:
                                            emailRegEditingController,
                                        hintText: 'E-Mail',
                                        prefixIcon: Icon(Icons.alternate_email)
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      MyTextForm(
                                          bordered: true,
                                        textEditingController:
                                            noHpEditingController,
                                        hintText: 'No Handphone',
                                        prefixIcon: Icon(Icons.phone)
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      MyTextForm(
                                          bordered: true,
                                        textEditingController:
                                            passwordRegEditingController,
                                        obscureText: true,
                                        hintText: 'password',
                                        prefixIcon:Icon(Icons.vpn_key)
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String msg, String status){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          title: new Text(status[0].toUpperCase()+status.substring(1)),
          content: new Text(msg[0].toUpperCase()+msg.substring(1)),
          actions: <Widget>[
            new MyFlatButton(
              btnRounded: 10,
              btnColor: Color(gradientTwo),
              btnPadding: 5,
              btnFunc: (){
                Navigator.of(context).pop();
              },
              btnName: 'Ok',
              textSize: 12,
            ),
          ],
        );
      },
    );
  }


  Future<void> handleLogin() async {
    setState(() {
      isLoading = true;
    });

    var data = {
      'email': emailEditingController.text,
      'password': passwordEditingController.text,
    };
    FocusScope.of(context).unfocus();

    var res = await CallApi().postData(data, 'login');
    var hasil = jsonDecode(res.body);
    if (hasil['status'] == 'berhasil') {
      SharedPreferences local = await SharedPreferences.getInstance();
      local.setString('token', hasil['content']['access_token']);
      local.setString('user', jsonEncode(hasil['content']['user']));

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>HomePage()));
    } else {
      _showDialog(context, hasil['message'], hasil['status']);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> handleRegister() async {
    setState(() {
      isLoading = true;
    });
    FocusScope.of(context).unfocus();
    var data = {
      'name': namaEditingController.text,
      'email': emailRegEditingController.text,
      'no_handphone': noHpEditingController.text,
      'password': passwordRegEditingController.text,
    };

    var res = await CallApi().postData(data, 'register');
    var hasil = jsonDecode(res.body);
    if (hasil['status'] == 'berhasil') {
      SharedPreferences local = await SharedPreferences.getInstance();
      local.setString('token', hasil['content']['access_token']);
      local.setString('user', jsonEncode(hasil['content']['user']));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>HomePage()));
    } else {
      _showDialog(context, hasil['message'], hasil['status']);
    }
    setState(() {
      isLoading = false;
    });


  }
}
