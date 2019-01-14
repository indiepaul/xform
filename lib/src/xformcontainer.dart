import 'package:flutter/material.dart';

class XFormContainer extends StatefulWidget {
  final Widget child;
  final Function register;
  final Function onSave;
  final Function next;
  XFormContainer(
      {@required this.child,
      @required this.register,
      @required this.onSave,
      @required this.next});

  static XFormContainerState of(BuildContext context) {
    final XFormContainerState scope =
        context.ancestorStateOfType(const TypeMatcher<XFormContainerState>());
    return scope;
  }

  @override
  XFormContainerState createState() {
    return new XFormContainerState();
  }
}

class XFormContainerState extends State<XFormContainer> {
  register(name) {
    return widget.register(name);
  }

  onSave(field, value) {
    return widget.onSave(field, value);
  }

  next(focusNode) {
    return widget.next(focusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: widget.child);
  }
}
