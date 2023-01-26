import 'package:shared_preferences/shared_preferences.dart';

class CallLocal {
  Future<dynamic> getLocalString(String key) async {
    SharedPreferences local = await SharedPreferences.getInstance();
    var response = local.getString(key);

    return response;
  }

  Future<dynamic> setLocalString(String key, String value) async {
    SharedPreferences local = await SharedPreferences.getInstance();
    local.setString(key, value);
    var response = local.getString(key);
    return response;
  }

  Future<void> remove(String key) async {
    SharedPreferences local = await SharedPreferences.getInstance();
    local.remove(key);
  }
}
