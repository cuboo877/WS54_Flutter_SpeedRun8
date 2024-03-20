import 'dart:math';

import 'package:flutter/material.dart';

class Utilities {
  static void showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 2),
    ));
  }

  static String randomID() {
    Random random = Random();
    String result = "";
    for (int i = 0; i < 9; i++) {
      result += random.nextInt(9).toString();
    }
    return result;
  }

  static String randomPassword(
      bool l, bool u, bool s, bool n, int length, String custom) {
    Random random = Random();
    StringBuffer buffer = StringBuffer();
    if (l) {
      buffer.write("abcdefghijklmnopqrstuvwxyz");
    }
    if (u) {
      buffer.write("ABCEDFGHIJKLMNOPQRSTUVWXYZ");
    }
    if (s) {
      buffer.write("!@#%^&*()_+}{?|}");
    }
    if (n) {
      buffer.write("0123456798");
    }
    String result = "";
    for (int i = 0; i < length - custom.length; i++) {
      result += buffer.toString()[random.nextInt(buffer.length)];
    }
    int index = random.nextInt(result.length);
    return "${result.substring(0, index)}$custom${result.substring(index)}";
  }
}
