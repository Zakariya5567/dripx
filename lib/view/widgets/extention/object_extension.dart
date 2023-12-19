import 'package:flutter/material.dart';

extension LogExtension on Object {
  void get log => debugPrint(toString());

  void get printLog => debugPrint(toString());
}
