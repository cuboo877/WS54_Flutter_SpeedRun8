import 'dart:ui';

import 'package:flutter/cupertino.dart';

Widget customText(Color color, String text, int size, bool isbold) {
  return Text(
    text,
    style: TextStyle(
        color: color,
        fontSize: size.toDouble(),
        fontWeight: isbold ? FontWeight.bold : FontWeight.normal),
  );
}
