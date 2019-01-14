import 'package:flutter/material.dart';

class XFocusNode {
  bool autoFocus = false;
  FocusNode focus;
  String defaultValue;
  XFocusNode({this.focus, this.autoFocus = false, this.defaultValue});
}
