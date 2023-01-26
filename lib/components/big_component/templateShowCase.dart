import 'package:flutter/material.dart';
import 'package:d_invite/components/card.dart';

class TemplateShowCase extends StatelessWidget {
  final onTap;
  final thumbnailTemplate;

  TemplateShowCase({this.onTap, this.thumbnailTemplate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(0, 0),
              spreadRadius: 0.1,
              blurRadius: 4),
        ], borderRadius: BorderRadius.circular(20)),
        child: MyCardSimpleWithImgAssets(
          assets: thumbnailTemplate,
          radius: 15,
          boxFit: BoxFit.fitHeight,
          cardColor: Colors.grey.shade200,
        ),
      ),
    );
  }
}
