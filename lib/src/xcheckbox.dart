import 'package:flutter/material.dart';
import 'xfocusnode.dart';
import 'xformcontainer.dart';

class XCheckbox extends StatefulWidget {
  final String name;
  final String label;
  final bool defaultValue;
  final bool required;
  final Function onSaved;
  final InputDecoration decoration;
  XCheckbox(
      {this.name,
      this.label,
      this.defaultValue = false,
      this.required = false,
      this.onSaved,
      this.decoration});

  @override
  _XCheckboxState createState() => _XCheckboxState();
}

class _XCheckboxState extends State<XCheckbox> {
  InputDecoration decoration;
  XFocusNode focusNode;
  String errorMsg;
  bool _value = false;

  @override
  void initState() {
    super.initState();
    focusNode = XFormContainer.of(context).register(widget.name);
    _value = focusNode.defaultValue == null
        ? widget.defaultValue
        : focusNode.defaultValue;
    _onSaved(_value);
  }

  _onSaved(bool val) {
    setState(() {
      _value = val;
    });
    XFormContainer.of(context).onSave(widget.name, val);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: _value,
          onChanged: (val) => _onSaved(val),
        ),
        Text(widget.label)
      ],
    );
  }
}
