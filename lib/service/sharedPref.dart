import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static Future<String> getLoggedUserID() async {
    final pref = await SharedPreferences.getInstance();

    return pref.getString("id") ?? "";
  }

  static Future<void> setLoggedUserID(String userID) async {
    final pref = await SharedPreferences.getInstance();
    pref.remove("id");
    pref.setString("id", userID);
  }

  static Future<void> removeLoggedUserID() async {
    final pref = await SharedPreferences.getInstance();

    pref.remove("id");
  }
}
