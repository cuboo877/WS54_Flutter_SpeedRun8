import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun8/page/login.dart';
import 'package:ws54_flutter_speedrun8/service/sql_service.dart';

import '../constant/style_guide.dart';
import '../service/auth.dart';
import '../service/sharedPref.dart';
import '../service/utilites.dart';
import '../widget/custom_text.dart';
import '../widget/custom_textbutton.dart';
import 'home.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  late TextEditingController account_controller;
  late TextEditingController password_controller;
  late TextEditingController usernmae_controller;
  late TextEditingController birthday_controller;
  bool accountValid = true;
  bool passwordValid = true;
  bool nameValid = true;
  bool birthdayValid = true;
  UserData userData = UserData("", "", "", "", "");
  @override
  void initState() {
    super.initState();
    getCurrentUserData();
    account_controller = TextEditingController();
    password_controller = TextEditingController();
    usernmae_controller = TextEditingController();
    birthday_controller = TextEditingController();
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_controller.dispose();
    usernmae_controller.dispose();
    birthday_controller.dispose();
    super.dispose();
  }

  Future<void> getCurrentUserData() async {
    UserData _userData = await UserDAO.getUserDataByUserID(widget.userID);
    userData = _userData;
    account_controller.text = _userData.account;
    password_controller.text = _userData.password;
    birthday_controller.text = _userData.birthday;
    usernmae_controller.text = _userData.username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: topbar(),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customText(AppColor.black, "使用者基本資料", 30, true),
            const SizedBox(height: 20),
            customText(AppColor.black, "帳號", 30, true),
            const SizedBox(height: 20),
            accountTextForm(),
            const SizedBox(height: 20),
            customText(AppColor.black, "密碼", 30, true),
            const SizedBox(height: 20),
            passwordTextForm(),
            const SizedBox(height: 20),
            customText(AppColor.black, "使用者名稱", 30, true),
            const SizedBox(height: 20),
            usernameTextForm(),
            const SizedBox(height: 20),
            customText(AppColor.black, "生日", 30, true),
            const SizedBox(height: 20),
            birthdayTextForm(),
            const SizedBox(height: 20),
            submitButotn(),
            const SizedBox(height: 20),
            logOutButton()
          ],
        ),
      ),
    );
  }

  UserData packUserData() {
    return UserData(
        widget.userID,
        usernmae_controller.text,
        account_controller.text,
        password_controller.text,
        birthday_controller.text);
  }

  Widget submitButotn() {
    return customTextButton(AppColor.black, "編輯完成", 30, () async {
      if (accountValid && passwordValid && nameValid && birthdayValid) {
        await UserDAO.updateUserData(packUserData());
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(userID: widget.userID)));
        }
      } else {
        Utilities.showSnackBar(context, "檢查");
      }
    });
  }

  Widget accountTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            accountValid = false;
            return "請輸入";
          } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
              .hasMatch(value)) {
            accountValid = false;
            return "請輸入正確格式";
          } else {
            accountValid = true;
            return null;
          }
        },
        controller: account_controller,
        decoration: const InputDecoration(
            hintText: "account", prefixIcon: Icon(Icons.tag)),
      ),
    );
  }

  bool obscure1 = false;
  Widget passwordTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            passwordValid = false;
            return "請輸入";
          } else {
            passwordValid = true;
            return null;
          }
        },
        controller: password_controller,
        decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () => setState(() {
                      obscure1 = !obscure1;
                    }),
                icon: Icon(obscure1 ? Icons.visibility_off : Icons.visibility)),
            hintText: "password",
            prefixIcon: const Icon(Icons.tag)),
      ),
    );
  }

  Widget usernameTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            nameValid = false;
            return "請輸入";
          } else {
            nameValid = true;
            return null;
          }
        },
        controller: usernmae_controller,
        decoration: const InputDecoration(
            hintText: "name", prefixIcon: Icon(Icons.key)),
      ),
    );
  }

  Widget birthdayTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onTap: () async {
          DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2026));
          if (picked != null) {
            birthdayValid = true;
            birthday_controller.text = picked.toString().split(" ")[0];
          } else {
            birthdayValid = false;
          }
        },
        readOnly: true,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            birthdayValid = false;
            return "請輸入";
          } else {
            birthdayValid = true;
            return null;
          }
        },
        controller: birthday_controller,
        decoration: const InputDecoration(
            hintText: "YYYY-MM-DD", prefixIcon: Icon(Icons.key)),
      ),
    );
  }

  Widget topbar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: AppColor.black,
      title: const Text("編輯使用者資料"),
    );
  }

  Widget logOutButton() {
    return customTextButton(AppColor.red, "log out", 30, () async {
      await Auth.logOiut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    });
  }
}
