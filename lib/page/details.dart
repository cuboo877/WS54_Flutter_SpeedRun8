import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun8/page/home.dart';
import 'package:ws54_flutter_speedrun8/service/auth.dart';
import 'package:ws54_flutter_speedrun8/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun8/service/sql_service.dart';
import 'package:ws54_flutter_speedrun8/service/utilites.dart';
import 'package:ws54_flutter_speedrun8/widget/custom_textbutton.dart';

import '../constant/style_guide.dart';
import '../widget/custom_text.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.account, required this.password});
  final String account;
  final String password;
  @override
  State<StatefulWidget> createState() => _DetailsPage();
}

class _DetailsPage extends State<DetailsPage> {
  late TextEditingController username_controller;
  late TextEditingController birthday_controller;
  bool nameValid = false;
  bool birthdayValid = false;
  @override
  void initState() {
    super.initState();
    username_controller = TextEditingController();
    birthday_controller = TextEditingController();
  }

  @override
  void dispose() {
    username_controller.dispose();
    birthday_controller.dispose();
    super.dispose();
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
            customText(AppColor.black, "使用者名稱", 20, true),
            const SizedBox(height: 20),
            usernameTextForm(),
            const SizedBox(height: 20),
            customText(AppColor.black, "生日", 20, true),
            const SizedBox(height: 20),
            birthdayTextForm(),
            const SizedBox(height: 20),
            startButton()
          ],
        ),
      ),
    );
  }

  UserData packUserData() {
    return UserData(Utilities.randomID(), username_controller.text,
        widget.account, widget.password, birthday_controller.text);
  }

  Widget startButton() {
    return customTextButton(AppColor.black, "start", 30, () async {
      if (nameValid && birthdayValid) {
        await Auth.registerAuth(packUserData());
        String id = await SharedPref.getLoggedUserID();
        if (mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage(userID: id)));
        }
      } else {
        Utilities.showSnackBar(context, "檢查");
      }
    });
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
        controller: username_controller,
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
      title: const Text("即將完成註冊"),
    );
  }
}
