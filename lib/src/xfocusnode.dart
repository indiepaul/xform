import 'package:flutter/material.dart';

class XFocusNode {
  bool autoFocus = false;
  FocusNode focus;
  dynamic defaultValue;
  XFocusNode({this.focus, this.autoFocus = false, this.defaultValue});
}
