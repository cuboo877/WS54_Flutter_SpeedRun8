import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class sql {
  static Database? database;

  static Future<Database> _initDataBase() async {
    database = await openDatabase(join(await getDatabasesPath(), "ws.db"),
        onCreate: (db, version) async {
      await db.execute(
          "create table users (id text primary key, username text, account text, password text, birthday text)");
      await db.execute(
          "create table passwords (id text primary key, userID text, tag text, url text, login text, password text, isFav, foreign key (userID) references users (id))");
    }, version: 1);
    return database!;
  }

  static Future<Database> getDBConnect() async {
    if (database != null) {
      return database!;
    } else {
      return await _initDataBase();
    }
  }
}

class UserDAO {
  static Future<UserData> getUserDataByUserID(String userID) async {
    final database = await sql.getDBConnect();
    List<Map<String, dynamic>> maps =
        await database.query("users", where: "id = ?", whereArgs: [userID]);
    Map<String, dynamic> reuslt = maps.first;
    return UserData(reuslt["id"], reuslt["username"], reuslt["account"],
        reuslt["password"], reuslt["birthday"]);
  }

  static Future<UserData> getUserDataByAccount(String acocunt) async {
    final database = await sql.getDBConnect();
    List<Map<String, dynamic>> maps = await database
        .query("users", where: "acocunt = ?", whereArgs: [acocunt]);
    Map<String, dynamic> reuslt = maps.first;
    return UserData(reuslt["id"], reuslt["username"], reuslt["account"],
        reuslt["password"], reuslt["birthday"]);
  }

  static Future<UserData> getUserDataByAccountAndPassword(
      String acocunt, String password) async {
    final database = await sql.getDBConnect();
    List<Map<String, dynamic>> maps = await database.query("users",
        where: "acocunt = ? and password = ?", whereArgs: [acocunt, password]);
    Map<String, dynamic> reuslt = maps.first;
    return UserData(reuslt["id"], reuslt["username"], reuslt["account"],
        reuslt["password"], reuslt["birthday"]);
  }

  static Future<void> addUserData(UserData userData) async {
    final database = await sql.getDBConnect();
    await database.insert("users", userData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateUserData(UserData userData) async {
    final database = await sql.getDBConnect();
    await database.update("users", userData.toJson(),
        where: "id = ?",
        whereArgs: [userData.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

class PasswordDAO {
  static Future<List<PasswordData>> getPasswordListByUserID(
      String userID) async {
    final database = await sql.getDBConnect();
    List<Map<String, dynamic>> maps = await database
        .query("passwords", where: "userID = ?", whereArgs: [userID]);
    return List.generate(maps.length, (index) {
      return PasswordData(
          maps[index]["id"],
          maps[index]["userID"],
          maps[index]["tag"],
          maps[index]["url"],
          maps[index]["login"],
          maps[index]["password"],
          maps[index]["isFav"]);
    });
  }

  static Future<List<PasswordData>> getPasswordListByConditoin(
      String userID,
      String tag,
      String url,
      String login,
      String password,
      String id,
      bool hasFav,
      int isFav) async {
    final database = await sql.getDBConnect();

    String whereCondition = "userID = ?";
    List whereArgs = [userID];

    if (tag.trim().isEmpty) {
      whereCondition += "and tag like ?";
      whereArgs.add("%$tag%");
    }
    if (url.trim().isEmpty) {
      whereCondition += "and url like ?";
      whereArgs.add("%$url%");
    }
    if (login.trim().isEmpty) {
      whereCondition += "and login like ?";
      whereArgs.add("%$login%");
    }
    if (password.trim().isEmpty) {
      whereCondition += "and password like ?";
      whereArgs.add("%$password%");
    }
    if (id.trim().isEmpty) {
      whereCondition += "and id like ?";
      whereArgs.add("%$id%");
    }

    if (hasFav) {
      whereCondition += "and isFav = ?";
      whereArgs.add(isFav);
    }

    List<Map<String, dynamic>> maps = await database.query("passwords",
        where: whereCondition, whereArgs: whereArgs);
    return List.generate(maps.length, (index) {
      return PasswordData(
          maps[index]["id"],
          maps[index]["userID"],
          maps[index]["tag"],
          maps[index]["url"],
          maps[index]["login"],
          maps[index]["password"],
          maps[index]["isFav"]);
    });
  }

  static Future<void> addPassordData(PasswordData passwordData) async {
    final database = await sql.getDBConnect();
    await database.insert("passwords", passwordData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> removePassordData(String passwordID) async {
    final database = await sql.getDBConnect();
    await database
        .delete("passwords", where: "id = ?", whereArgs: [passwordID]);
  }

  static Future<void> updatePassordData(PasswordData passwordData) async {
    final database = await sql.getDBConnect();
    await database.update("passwords", passwordData.toJson(),
        where: "id = ?",
        whereArgs: [passwordData.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
class UserData {
  final String id;
  late String username;
  late String account;
  late String password;
  late String birthday;
  UserData(this.id, this.username, this.account, this.password, this.birthday);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "account": account,
      "password": password,
      "birthday": birthday
    };
  }
}

class PasswordData {
  final String id;
  final String userID;
  late String tag;
  late String url;
  late String login;
  late String password;
  late int isFav;
  PasswordData(this.id, this.userID, this.tag, this.url, this.login,
      this.password, this.isFav);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userID": userID,
      "tag": tag,
      "url": url,
      "login": login,
      "password": password,
      "isFav": isFav
    };
  }
}
