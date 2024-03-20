import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun8/page/login.dart';

import '../constant/style_guide.dart';
import '../service/auth.dart';
import '../service/sharedPref.dart';
import '../service/utilites.dart';
import '../widget/custom_text.dart';
import '../widget/custom_textbutton.dart';
import 'details.dart';
import 'home.dart';

class RegsiterPage extends StatefulWidget {
  const RegsiterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegsiterPage();
}

class _RegsiterPage extends State<RegsiterPage> {
  late TextEditingController account_controller;
  late TextEditingController password_controller;
  late TextEditingController confirm_controller;
  bool accountValid = false;
  bool passwordValid = false;
  bool confirmValid = false;
  @override
  void initState() {
    super.initState();
    account_controller = TextEditingController();
    password_controller = TextEditingController();
    confirm_controller = TextEditingController();
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_controller.dispose();
    confirm_controller.dispose();
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
            customText(AppColor.black, "註冊介面", 30, true),
            const SizedBox(height: 20),
            customText(AppColor.black, "帳號", 30, true),
            const SizedBox(height: 20),
            accountTextForm(),
            const SizedBox(height: 20),
            customText(AppColor.black, "密碼", 30, true),
            const SizedBox(height: 20),
            passwordTextForm(),
            const SizedBox(height: 20),
            confirmTextForm(),
            const SizedBox(height: 20),
            registerButton(),
            const SizedBox(height: 20),
            loginToRegister()
          ],
        ),
      ),
    );
  }

  Widget registerButton() {
    return customTextButton(AppColor.black, "註冊", 30, () async {
      if (accountValid && passwordValid) {
        bool result =
            await Auth.hasAccountBeenRegistered(account_controller.text);
        if (result == false) {
          if (mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => DetailsPage(
                      account: account_controller.text,
                      password: password_controller.text,
                    )));
          }
        }
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    });
  }

  Widget loginToRegister() {
    return Column(
      children: [
        customText(AppColor.black, "已經擁有帳號?", 20, false),
        InkWell(
          child: customText(AppColor.darkBlue, "登入?", 30, true),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const LoginPage())),
        )
      ],
    );
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
        obscureText: obscure1,
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
            prefixIcon: const Icon(Icons.key)),
      ),
    );
  }

  bool obscure2 = false;
  Widget confirmTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        obscureText: obscure2,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            confirmValid = false;
            return "請輸入";
          } else if (value != password_controller.text) {
            confirmValid = false;
            return "請確認密碼";
          } else {
            confirmValid = true;
            return null;
          }
        },
        controller: confirm_controller,
        decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () => setState(() {
                      obscure2 = !obscure2;
                    }),
                icon: Icon(obscure2 ? Icons.visibility_off : Icons.visibility)),
            hintText: "confirm",
            prefixIcon: const Icon(Icons.key)),
      ),
    );
  }
}
