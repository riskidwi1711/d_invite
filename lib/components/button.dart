import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String namaButton;
  final Color btnColor;
  final double btnHeight;
  final double btnWidth;
  final Color textColor;

  MyButton(
      {required this.btnHeight,
      this.btnColor = Colors.blue,
      this.namaButton = 'Example',
      required this.btnWidth,
      this.textColor = Colors.white});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: btnHeight,
      width: btnWidth,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      decoration: BoxDecoration(
          color: btnColor, borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Center(
          child: Text(
        namaButton,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
      )),
    );
  }
}

class MyFlatButton extends StatelessWidget {
  final VoidCallback btnFunc;
  final String btnName;
  final double btnWidth;
  final double btnHeight;
  final Color btnColor;
  final Color textColor;
  final double btnRounded;
  final double textSize;
  final double btnPadding;
  MyFlatButton(
      {required this.btnFunc,
        this.btnPadding = 10,
      this.btnColor = Colors.red,
      required this.btnWidth,
      this.textSize = 18,
      required this.btnHeight,
      required this.btnName,
      this.textColor = Colors.white,
      this.btnRounded = 20});
  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(btnRounded),
          ),
          primary: textColor,
          backgroundColor: btnColor,
          onSurface: Colors.grey,
          padding: EdgeInsets.all(btnPadding)
        ),
        onPressed: btnFunc,
        child: Container(
            height: btnHeight,
            width: btnWidth,
            child: Center(
                child: Text(btnName, style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w400)))));
  }
}

class MyFlatButtonWithIcon extends StatelessWidget {
  final VoidCallback btnFunc;
  final String btnName;
  final double btnWidth;
  final double btnHeight;
  final Color btnColor;
  final Color textColor;
  final double btnRounded;
  final double textSize;
  final double btnPadding;
  final Widget content;
  MyFlatButtonWithIcon(
      {required this.btnFunc,
        this.btnPadding = 10,
        required this.content,
        this.btnColor = Colors.red,
        required this.btnWidth,
        this.textSize = 18,
        required this.btnHeight,
        required this.btnName,
        this.textColor = Colors.white,
        this.btnRounded = 20});
  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(btnRounded),
            ),
            primary: textColor,
            backgroundColor: btnColor,
            onSurface: Colors.grey,
            padding: EdgeInsets.all(btnPadding)
        ),
        onPressed: btnFunc,
        child: Container(
            height: btnHeight,
            width: btnWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children :[
                  content,
                  SizedBox(width: 10,),
                  Text(btnName, style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w400))
                ] )));
  }
}
