import 'package:flutter/material.dart';
import 'xfocusnode.dart';
import 'xformcontainer.dart';
import 'option.dart';

class XRadioGroup extends StatefulWidget {
  final String name;
  final String label;
  final String selected;
  final List<Option> options;
  final bool required;
  final Function onSaved;
  XRadioGroup(
      {this.name,
      this.label,
      this.options,
      this.selected,
      this.required = false,
      this.onSaved});

  @override
  _XRadioGroupState createState() => _XRadioGroupState();
}

class _XRadioGroupState extends State<XRadioGroup> {
  XFocusNode focusNode;
  String errorMsg;
  String _groupValue;

  @override
  void initState() {
    super.initState();
    focusNode = XFormContainer.of(context).register(widget.name);
    String val = focusNode.defaultValue == null
        ? widget.selected
        : focusNode.defaultValue;
    _onSaved(val);
  }

  _onSaved(val) {
    setState(() {
      _groupValue = val;
    });
    XFormContainer.of(context).onSave(widget.name, _groupValue.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.label ?? ''),
        Wrap(
            children: widget.options.map((Option option) {
          return Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Radio(
                  value: option.value,
                  groupValue: _groupValue,
                  onChanged: (val) => _onSaved(val),
                ),
                Text(option.name)
              ],
            ),
          );
        }).toList()),
      ],
    );
  }
}
