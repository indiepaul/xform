import 'package:flutter/material.dart';
import 'xfocusnode.dart';
import 'xformcontainer.dart';

class XSlider extends StatefulWidget {
  final String name;
  final String label;
  final double defaultValue;
  final bool required;
  final Function onSaved;
  final InputDecoration decoration;
  XSlider(
      {this.name,
      this.label,
      this.defaultValue = 0,
      this.required = false,
      this.onSaved,
      this.decoration});

  @override
  _XSliderState createState() => _XSliderState();
}

class _XSliderState extends State<XSlider> {
  InputDecoration decoration;
  XFocusNode focusNode;
  String errorMsg;
  double _value;

  @override
  void initState() {
    super.initState();
    focusNode = XFormContainer.of(context).register(widget.name);
    _value = focusNode.defaultValue == null
        ? widget.defaultValue
        : focusNode.defaultValue;
    _onSaved(_value);
  }

  _onSaved(double val) {
    setState(() {
      _value = val;
    });
    XFormContainer.of(context).onSave(widget.name, val);
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      // mainAxisSize: MainAxisSize.max,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(widget.label),
        Slider(
          value: _value,
          onChanged: (val) => _onSaved(val),
        ),
      ],
    );
  }
}
