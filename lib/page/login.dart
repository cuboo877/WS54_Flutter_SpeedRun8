import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun8/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun8/page/home.dart';
import 'package:ws54_flutter_speedrun8/page/register.dart';
import 'package:ws54_flutter_speedrun8/service/auth.dart';
import 'package:ws54_flutter_speedrun8/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun8/service/sql_service.dart';
import 'package:ws54_flutter_speedrun8/service/utilites.dart';
import 'package:ws54_flutter_speedrun8/widget/custom_text.dart';
import 'package:ws54_flutter_speedrun8/widget/custom_textbutton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  late TextEditingController account_controller;
  late TextEditingController password_controller;
  bool accountValid = false;
  bool passwordValid = false;
  bool doAuthWarning = false;
  @override
  void initState() {
    super.initState();
    account_controller = TextEditingController();
    password_controller = TextEditingController();
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customText(AppColor.black, "登入介面", 30, true),
            const SizedBox(height: 20),
            customText(AppColor.black, "帳號", 30, true),
            const SizedBox(height: 20),
            accountTextForm(),
            const SizedBox(height: 20),
            customText(AppColor.black, "密碼", 30, true),
            const SizedBox(height: 20),
            passwordTextForm(),
            const SizedBox(height: 20),
            loginButton(),
            const SizedBox(height: 20),
            loginToRegister()
          ],
        ),
      ),
    );
  }

  Widget loginButton() {
    return customTextButton(AppColor.black, "登入", 30, () async {
      if (accountValid && passwordValid) {
        bool result = await Auth.loginAuth(
            account_controller.text, password_controller.text);
        if (result) {
          String id = await SharedPref.getLoggedUserID();
          if (mounted) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage(userID: id)));
          }
        } else {
          setState(() {
            doAuthWarning = true;
          });
          Utilities.showSnackBar(context, "登入失敗");
        }
      } else {
        Utilities.showSnackBar(context, "檢查");
      }
    });
  }

  Widget loginToRegister() {
    return Column(
      children: [
        customText(AppColor.black, "尚未擁有帳號?", 20, false),
        InkWell(
          child: customText(AppColor.darkBlue, "註冊?", 30, true),
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RegsiterPage())),
        )
      ],
    );
  }

  Widget accountTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        onChanged: (value) => setState(() {
          doAuthWarning = false;
        }),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (doAuthWarning) {
            accountValid = false;
            return "";
          } else if (value == null || value.trim().isEmpty) {
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

  bool obscure2 = false;
  Widget passwordTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        onChanged: (value) => setState(() {
          doAuthWarning = false;
        }),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (doAuthWarning) {
            passwordValid = false;
            return "錯誤的帳號或密碼";
          } else if (value == null || value.trim().isEmpty) {
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
                      obscure2 = !obscure2;
                    }),
                icon: Icon(obscure2 ? Icons.visibility_off : Icons.visibility)),
            hintText: "password",
            prefixIcon: const Icon(Icons.tag)),
      ),
    );
  }
}
