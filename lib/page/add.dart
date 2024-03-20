import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:ws54_flutter_speedrun8/page/home.dart';
import 'package:ws54_flutter_speedrun8/service/sql_service.dart';
import 'package:ws54_flutter_speedrun8/service/utilites.dart';
import 'package:ws54_flutter_speedrun8/widget/custom_textbutton.dart';

import '../constant/style_guide.dart';
import '../widget/custom_text.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _AddPage();
}

class _AddPage extends State<AddPage> {
  bool tagValid = false;
  bool urlValid = false;
  bool loginValid = false;
  bool passwordValid = false;

  bool hasLower = true;
  bool hasUpper = true;
  bool hasNumber = true;
  bool hasSymbol = true;

  int length = 16;

  late TextEditingController tag_controller;
  late TextEditingController url_controller;
  late TextEditingController login_controller;
  late TextEditingController password_controller;

  late TextEditingController custom_controller;
  @override
  void initState() {
    super.initState();
    tag_controller = TextEditingController();
    url_controller = TextEditingController();
    login_controller = TextEditingController();
    password_controller = TextEditingController();
    custom_controller = TextEditingController();
  }

  @override
  void dispose() {
    tag_controller.dispose();
    url_controller.dispose();
    login_controller.dispose();
    password_controller.dispose();
    custom_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: topbar(context),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 20),
            customText(AppColor.black, "tag", 20, true),
            const SizedBox(height: 20),
            tagTextForm(),
            const SizedBox(height: 20),
            customText(AppColor.black, "url", 20, true),
            const SizedBox(height: 20),
            urlTextForm(),
            const SizedBox(height: 20),
            customText(AppColor.black, "login", 20, true),
            const SizedBox(height: 20),
            loginTextForm(),
            const SizedBox(height: 20),
            customText(AppColor.black, "password", 20, true),
            const SizedBox(height: 20),
            passwordTextForm(),
            const SizedBox(height: 20),
            favButton(),
            const SizedBox(height: 20),
            randomPasswordButton(context),
            const SizedBox(height: 20),
            submitCreateButton(context)
          ],
        ),
      ),
    );
  }

  PasswordData packPasswordData() {
    return PasswordData(
        Utilities.randomID(),
        widget.userID,
        tag_controller.text,
        url_controller.text,
        login_controller.text,
        password_controller.text,
        isFav);
  }

  Widget submitCreateButton(BuildContext context) {
    return customTextButton(AppColor.black, "submit", 30, () async {
      if (loginValid && passwordValid && tagValid && urlValid) {
        await PasswordDAO.addPassordData(packPasswordData());
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(userID: widget.userID)));
        }
      } else {
        Utilities.showSnackBar(context, "檢查");
      }
    });
  }

  Widget randomPasswordButton(BuildContext context) {
    return customTextButton(AppColor.black, "random setting", 20, () async {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: const Text("random setting"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: custom_controller,
                    ),
                    CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text("包含小寫"),
                        value: (hasLower),
                        onChanged: (value) =>
                            setState(() => hasLower = !hasLower)),
                    CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text("包含大寫"),
                        value: (hasUpper),
                        onChanged: (value) =>
                            setState(() => hasUpper = !hasUpper)),
                    CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text("包含符號"),
                        value: (hasSymbol),
                        onChanged: (value) =>
                            setState(() => hasSymbol = !hasSymbol)),
                    CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text("包含數字"),
                        value: (hasNumber),
                        onChanged: (value) =>
                            setState(() => hasNumber = !hasNumber)),
                    Row(
                      children: [
                        Slider(
                            min: 1,
                            max: 20,
                            divisions: 19,
                            value: (length.toDouble()),
                            onChanged: (value) =>
                                setState(() => length = value.toInt())),
                        Text(length.toString())
                      ],
                    )
                  ],
                ),
              );
            });
          });
    });
  }

  int isFav = 0;
  Widget favButton() {
    return TextButton(
        style: TextButton.styleFrom(
            side: const BorderSide(color: AppColor.red, width: 2.0),
            shape: const CircleBorder(),
            backgroundColor: isFav == 0 ? AppColor.white : AppColor.red,
            iconColor: isFav == 1 ? AppColor.white : AppColor.red),
        onPressed: () => setState(() {
              isFav = isFav == 0 ? 1 : 0;
            }),
        child: const Icon(Icons.favorite));
  }

  Widget tagTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            tagValid = false;
            return "請輸入";
          } else {
            tagValid = true;
            return null;
          }
        },
        controller: tag_controller,
        decoration:
            const InputDecoration(hintText: "tag", prefixIcon: Icon(Icons.tag)),
      ),
    );
  }

  Widget urlTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            urlValid = false;
            return "請輸入";
          } else {
            urlValid = true;
            return null;
          }
        },
        controller: url_controller,
        decoration: const InputDecoration(
            hintText: "url", prefixIcon: Icon(Icons.link)),
      ),
    );
  }

  Widget loginTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            loginValid = false;
            return "請輸入";
          } else {
            loginValid = true;
            return null;
          }
        },
        controller: login_controller,
        decoration: const InputDecoration(
            hintText: "login", prefixIcon: Icon(Icons.email)),
      ),
    );
  }

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
                      password_controller.text = Utilities.randomPassword(
                          hasLower,
                          hasUpper,
                          hasSymbol,
                          hasNumber,
                          length,
                          custom_controller.text);
                    }),
                icon: const Icon(Icons.casino)),
            hintText: "password",
            prefixIcon: const Icon(Icons.key)),
      ),
    );
  }

  Widget topbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: AppColor.black,
      title: const Text("創建密碼"),
    );
  }
}