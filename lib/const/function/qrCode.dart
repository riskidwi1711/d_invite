import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:d_invite/api/api.dart';
import 'package:d_invite/const/function/mainFunc.dart';

class QrCodeGen {
  scan(context) async {
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      if (barcode.rawContent.isNotEmpty) {
        var jsonData = jsonDecode(barcode.rawContent);
        var data = {
          'ids': jsonData['owner'],
          'user_id': jsonData['uid'],
          'undangan_id': jsonData['undangan'],
          'konfirmasi': 'datang'
        };
        await CallApi().postData(data, 'konfirmasi');
      }
      print(barcode.rawContent);
      MainFunc().dialogWithContent(
          Container(
            color: Colors.blue,
            child: Text('hello'),
          ),
          context);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        MainFunc().pushDialog('Berikan akses kamera', 'Error', context);
      } else {
        MainFunc().pushDialog('Unknown Error', 'Eror', context);
      }
    }
  }

  showCode(context, data) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: Container(
                height: 0.5 * MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: QrImage(
                        data: data,
                        size: MediaQuery.of(context).size.height * 0.4))),
          );
        });
  }
}
