import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:d_invite/api/api.dart';
import 'package:d_invite/components/button.dart';
import 'package:d_invite/components/textFormField.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/page/homepage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //text edit control for login
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  //text edit control for register
  TextEditingController namaEditingController = new TextEditingController();
  TextEditingController emailRegEditingController = new TextEditingController();
  TextEditingController passwordRegEditingController =
  new TextEditingController();
  TextEditingController noHpEditingController = new TextEditingController();

  double height = 0;
  double height2 = 0;
  double yOffset = 0;
  double width2 = 0;
  Color color = Colors.white;
  bool _keyboardVisible = false;
  var _pageState = 1;
  bool isLoading = false;
  double loginYoff = 0;
  double padding = 0;

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible){
        setState(() {
          _keyboardVisible = visible;
          print(visible);
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {

   switch (_pageState) {
     case 0:
       padding = 20;
       color = Colors.grey.shade400;
       height = MediaQuery.of(context).size.height;
       height2 = MediaQuery.of(context).size.height;
       width2 = 20;
       loginYoff = _keyboardVisible ? 50 : 250;
       yOffset = _keyboardVisible ? 70 : 270;
       break;

     case 1:
       padding = 0;
       color = Colors.white;
       yOffset = MediaQuery.of(context).size.height;
       loginYoff = _keyboardVisible ? 70 : 270;
       height = MediaQuery.of(context).size.height;
       height2 = _keyboardVisible ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height-200;
       width2 =  0;
   }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [Color(gradientOne), Color(gradientTwo)]),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'D-Invite',
                        style: TextStyle(
                          fontFamily: 'Pattaya',
                          fontSize: 60,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Aplikasi pembuatan undangan digital', textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 24,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            transform: Matrix4.translationValues(0, loginYoff, 0),
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 800),
            padding: EdgeInsets.symmetric(horizontal: padding),
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    _pageState = 1;
                  });
                },
                child: Container(
                  height: height2,
                  padding: EdgeInsets.only(left: 20,right: 20, bottom: 50, top: 30),
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))
                  ),
                  child: Column(
                    children: [
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
                      SizedBox(height: 30,),
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
                      SizedBox(height: 30,),
                      MyFlatButton(
                        btnFunc: () {
                          if(!isLoading){
                            handleLogin();
                          }
                        },
                        btnName: isLoading ? "Proses.." : "Masuk",
                        btnColor: Color(gradientTwo),
                        btnWidth: MediaQuery.of(context).size.width - 50,
                        btnRounded: 20,
                        btnPadding: 15,
                      ),
                      SizedBox(height: 10,),
                      MyFlatButton(

                        btnFunc: () {
                          setState(() {
                            _pageState = 0;
                          });
                        },
                        btnName: "Daftar",
                        btnWidth: MediaQuery.of(context).size.width - 50,
                        btnColor: Color(gradientTwo),

                        btnRounded: 20,
                        btnPadding: 15,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            transform: Matrix4.translationValues(0,yOffset, 0),
            height: height,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 600),
            padding: EdgeInsets.only(left: 20,right: 20, bottom: 50, top: 30),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))
            ),
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.center,
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
                      bordered: true,
                      textEditingController:
                      namaEditingController,
                      hintText: 'Nama',
                      prefixIcon: Icon(Icons.perm_contact_cal_outlined)
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
                    type: TextInputType.number,
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
                    height: 20,
                  ),

                  MyFlatButton(
                    btnFunc: () {
                      if(!isLoading){
                        handleRegister();
                      }
                    },
                    btnName:  isLoading ? "Proses..." : "Daftar",
                    btnWidth: MediaQuery.of(context).size.width - 50,
                    btnColor: Color(gradientTwo),
                    btnRounded: 20,
                    btnPadding: 15,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                            _pageState = 1;
                          });
                        },
                        child: Text(
                          ' Masuk',
                          style: TextStyle(
                              fontSize: 18,
                              color: Color(gradientOne),
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,)
                ],
              ),
            ),
          )
        ],
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
