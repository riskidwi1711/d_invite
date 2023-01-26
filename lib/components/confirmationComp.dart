import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Confirmation extends StatelessWidget {
  final Color color;
  final String value;
  final String sum;
  Confirmation({this.value, this.color, this.sum});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(children: [
        Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(999))),
            child: Center(
                child: Text(
              sum,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 12),
            ))),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10),
          ),
        )
      ]),
    );
  }
}

class ConfirmationButton extends StatelessWidget {
  final Color color;
  final VoidCallback btnfunc;
  final String value;
  final Icon icon;
  ConfirmationButton({this.value, this.color, this.btnfunc, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(9999999))
            )
          ),
          onPressed: btnfunc,
          child: Container(
              height: 50,
              width: 50,
              child: Center(
                  child: icon)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10),
          ),
        )
      ]),
    );
  }
}
