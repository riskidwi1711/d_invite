import 'package:flutter/material.dart';
import 'package:d_invite/components/button.dart';
import 'package:d_invite/const/designHelper.dart';

class MyCardSimpleWithImgAssets extends StatelessWidget {
  final double radius;
  final String assets;
  final Color cardColor;
  final BoxFit boxFit;

  MyCardSimpleWithImgAssets(
      {required this.radius, required this.assets, required this.cardColor, required this.boxFit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                offset: Offset(0, 0),
                spreadRadius: 2,
                blurRadius: 5),
          ],
          color: cardColor,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          image: DecorationImage(image: NetworkImage(assets), fit: boxFit)),
    );
  }
}

class MyRoundedIcons extends StatelessWidget {
  final Icon icon;
  final String title;
  final Color color;
  final VoidCallback btnFunc;
  MyRoundedIcons({required this.color, required this.icon, required this.title, required this.btnFunc});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: btnFunc,
          child: Container(
              height: 45,
              width: 45,
              child: icon),
          style: TextButton.styleFrom(
            backgroundColor: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(99)))),
        ),
        Text(
          title,
          softWrap: false,
          style: TextStyle(
            height: 1.5,
          ),
        )
      ],
    );
  }
}

class MyCardWithBorder extends StatelessWidget {

  final String linkImg;
  final String title;
  final String subTitle;

  MyCardWithBorder({required this.title, required this.linkImg, required this.subTitle});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1, style: BorderStyle.solid))
      ),
      child: Row(
        children: [
          Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(999)),
                  image: DecorationImage(
                      image: NetworkImage(
                          linkImg),
                      fit: BoxFit.cover))),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),Text(subTitle),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Function onPressed;
  final int selected;
  final int index;
  final String title;

  CategoryCard({required this.title, required this.index, required this.onPressed, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: MyFlatButton(
        btnHeight: 40,
        btnColor: selected != index
            ? Colors.grey
            : Color(gradientOne),
        btnFunc: onPressed,
        btnName: title,
        btnPadding: 10,
        textSize: 14,
        textColor: Colors.white,
        btnRounded: 20,
      ),
    );
  }
}
