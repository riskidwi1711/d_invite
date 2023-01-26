import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTopBarWithBack extends StatelessWidget {

  final String title;
  MyTopBarWithBack({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                  height: 50,
                  width: 50,
                  child: Icon(CupertinoIcons.back, color: Colors.white,))),
          SizedBox(width: 15,),
          Text(
            title,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ]
    );
  }
}


class MyTopBarWithImg extends StatelessWidget {
  final String title;
  final ImageProvider img;
  final bool chat;
  final String stat;
  MyTopBarWithImg({required this.title, required this.img, this.chat = false, required this.stat});
  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                  height: 50, width: 50,child: Icon(CupertinoIcons.back, color: Colors.white,))),
          SizedBox(width: 15,),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(999)),
              image: DecorationImage(image: img != null ? img : AssetImage('assets/img/avatar.jpg') ),
              color: Colors.green,
            ),
          ),
          SizedBox(width: 15,),
          chat ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
              ),
              Text(stat, style: TextStyle(color: CupertinoColors.white),)
            ],
          ) :  Text(
            title,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
          ),

        ]
    );
  }
}
