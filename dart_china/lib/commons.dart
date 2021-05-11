import 'dart:async';

import 'package:flutter/material.dart';

typedef IndexCallback = void Function(int index);
typedef StrDataCallback = void Function(String data);

const kBackgroundColor = Color(0xFF2656cc);
const kTagColr = Color(0xFFf2f6fa);
const kTopicBgColor = Color(0xFFF1F6FA);
const kTopicCardColor = Color(0xFFFDFDFD);
const kTitleColor = Colors.black87;
const kSplashRadius = 25.0;

class Debouncer {
  late int millisecond;
  Timer? _timer;

  Debouncer({this.millisecond = 300});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(milliseconds: millisecond), action);
  }
}
