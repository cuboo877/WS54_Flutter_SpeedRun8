import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun8/page/home.dart';
import 'package:ws54_flutter_speedrun8/page/login.dart';
import 'package:ws54_flutter_speedrun8/service/sharedPref.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPage();
}

class _SplashPage extends State<SplashPage> {
  void delayNav() async {
    await Future.delayed(const Duration(milliseconds: 250));
    String id = await SharedPref.getLoggedUserID();
    if (id.isNotEmpty) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage(userID: id)));
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    delayNav();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/icon.png",
        width: 200,
        height: 200,
      ),
    );
  }
}
