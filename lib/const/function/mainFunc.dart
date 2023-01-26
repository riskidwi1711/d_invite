import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:d_invite/api/api.dart';
import 'package:d_invite/components/button.dart';
import 'package:d_invite/const/config.dart';

import '../designHelper.dart';

class MainFunc {
  Future<Object> getTemplateByCategory(id) async {
    var req = await CallApi().postData({'id': id}, 'template/bycategory');
    var body = jsonDecode(req.body);
    return body;
  }

  Future<dynamic> getUserData(id) async {
    var req = await CallApi().getData('user/$id');
    var body = jsonDecode(req.body);
    return body;
  }

  Future<Object> getAllTemplate() async {
    var req = await CallApi().getData('template');
    var body = jsonDecode(req.body);
    return body;
  }

  Future<Object> getNewTemplate() async {
    var req = await CallApi().getData('getnewTemplate');
    var body = jsonDecode(req.body);
    return body;
  }

  Future<Object> getCategory() async {
    var req = await CallApi().getData('category');
    var body = jsonDecode(req.body);
    return body;
  }

  Future<void> handleLogout() async {
    SharedPreferences local = await SharedPreferences.getInstance();
    var token = local.getString('token');
    local.remove('imgName');
    local.remove('token');
    local.remove('user');
    await CallApi().logOutData(token);
  }

  getNotificationTime(String timeDb) {
    var now = DateTime.now().day;
    if (DateTime.parse(timeDb).day == now) {
      String time = DateFormat.Hm().format(DateTime.parse(timeDb).toLocal());
      return time;
    } else {
      String time = DateFormat.yMd().format(DateTime.parse(timeDb).toLocal());
      return time;
    }
  }

  Future<String> networkTo64Img(url) async {
    http.Response response = await http.get(Uri.parse(url));
    final bytes = response?.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  Future<File> saveNetworkImage(url) async {
    var rng = new Random();
    Directory tmpDir = await getTemporaryDirectory();
    String tempPath = tmpDir.path;
    File file = new File('$tempPath' + (rng.nextInt(50).toString()) + '.png');
    http.Response response = await http.get(url);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<Object> templateProccessing(inputData) async {
    var data = await CallApi().postData(inputData, 'createinvitation');
    var res = jsonDecode(data.body);
    return res;
  }

  Future<DateTime>selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2021), lastDate: DateTime(2022));
    return picked;
  }

  Future<TimeOfDay>selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    return picked;
  }

  Future<String>getTemplate(id) async {
    var data = {
      'id': id
    };
    var res = await CallApi().postData(data, 'getDetailInvitation');
    var body = jsonDecode(res.body);
    String url = '${base_url}savedtemplate/${body['content']['file_path']}';
    return url ;
  }

  Future<dynamic>pushDialog(msg, title, context) async {
   return showDialog(
      context: context,
      builder: (BuildContext context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        title: new Text(title),
        content: new Text(msg),
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
      }
    );
  }

  Future<dynamic>dialogWithContent(Widget widget, context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            content: widget,
          );
        }
    );
  }

  getWelcomeWords() {
    var rangeDate = {
      "pagi": [4, 10],
      "siang": [10, 14],
      "sore": [14, 18],
      "malam": [18, 4]
    };
    var now = DateTime.now().hour;
    if (now >= rangeDate['pagi'][0] && now <= rangeDate['pagi'][1]) {
      return "Selamat Pagi";
    } else if (now >= rangeDate['siang'][0] && now <= rangeDate['siang'][1]) {
      return "Selamat Siang";
    } else if (now >= rangeDate['sore'][0] && now <= rangeDate['sore'][1]) {
      return "Selamat sore";
    } else if (now >= rangeDate['malam'][0] || now <= rangeDate['malam'][1]) {
      return "Selamat Malam";
    } else {
      return "Selamat Datang";
    }
  }
}
