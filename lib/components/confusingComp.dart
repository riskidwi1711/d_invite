import 'package:flutter/material.dart';

class ConfussingComponent extends StatelessWidget {
  final title;
  ConfussingComponent({this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
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
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
        ]);
  }
}

class WaitingComp extends StatelessWidget {
  final title;
  WaitingComp({this.title});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(image: AssetImage('assets/img/waiting.png'),),
        SizedBox(height: 20,),
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ],);
  }
}

