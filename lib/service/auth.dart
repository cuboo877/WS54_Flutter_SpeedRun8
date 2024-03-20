import 'package:ws54_flutter_speedrun8/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun8/service/sql_service.dart';

class Auth {
  static Future<bool> loginAuth(String account, String password) async {
    try {
      UserData userdata =
          await UserDAO.getUserDataByAccountAndPassword(account, password);
      await SharedPref.setLoggedUserID(userdata.id);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> hasAccountBeenRegistered(String account) async {
    try {
      UserData userdata = await UserDAO.getUserDataByAccount(account);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> registerAuth(UserData userData) async {
    await UserDAO.addUserData(userData);
    await SharedPref.setLoggedUserID(userData.id);
  }

  static Future<void> logOiut() async {
    await SharedPref.removeLoggedUserID();
  }
}
