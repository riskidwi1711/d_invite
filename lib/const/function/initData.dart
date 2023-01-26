import 'dart:convert';

import 'package:d_invite/api/sharedPrefs/localStore.dart';
import 'package:d_invite/const/function/mainFunc.dart';

class InitData {

  Future<void> getAllData() async {
    var userJson = await CallLocal().getLocalString('user');
    var user = jsonDecode(userJson);
    await MainFunc().getUserData(user['id']).then((value) async {
      await CallLocal()
          .setLocalString('userData', jsonEncode(value))
          .then((value) async {
        var userData = jsonDecode(value);
        await CallLocal()
            .setLocalString('imgName', userData['user_data']['photo_profile']);
      });
    });
    await MainFunc().getCategory().then((value) async {
      await CallLocal().setLocalString('category', jsonEncode(value));
    });
    await MainFunc().getAllTemplate().then((value) async {
      await CallLocal().setLocalString('template', jsonEncode(value));
    });
    await MainFunc().getNewTemplate().then((value) async {
      await CallLocal().setLocalString('newTemplate', jsonEncode(value));
    });
  }

  Future<void> getTemplateByCategory(id) async {
    await MainFunc().getTemplateByCategory(id).then((value) async {
      await CallLocal().setLocalString('template', jsonEncode(value));
    });
  }
}
