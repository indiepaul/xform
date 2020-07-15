import 'package:flutter/material.dart';
import 'xfocusnode.dart';
import 'xformcontainer.dart';
import 'option.dart';

class XCheckboxGroup extends StatefulWidget {
  final String name;
  final String label;
  final List<String> selected;
  final List<Option> options;
  final bool required;
  final Function onSaved;
  final InputDecoration decoration;
  XCheckboxGroup(
      {this.name,
      this.label,
      this.options,
      this.selected,
      this.required = false,
      this.onSaved,
      this.decoration});

  @override
  _XCheckboxGroupState createState() => _XCheckboxGroupState();
}

class _XCheckboxGroupState extends State<XCheckboxGroup> {
  InputDecoration decoration;
  XFocusNode focusNode;
  List<String> _values = [];
  String errorMsg;

  @override
  void initState() {
    super.initState();
    focusNode = XFormContainer.of(context).register(widget.name);
    List<String> values = focusNode.defaultValue == null
        ? widget.selected
        : focusNode.defaultValue;
    _onSaved(values: values, single: false);
  }

  _onSaved({Map<String, bool> value, List<String> values, bool single = true}) {
    if (single) {
      String key = value.keys.first;
      if (value[key]) {
        setState(() {
          _values.add(key);
        });
      } else {
        setState(() {
          _values.remove(key);
        });
      }
    } else {
      setState(() {
        values.remove('');
        _values.addAll(values);
      });
    }
    XFormContainer.of(context).onSave(widget.name, _values);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.decoration != null) {
      decoration = widget.decoration
          .copyWith(labelText: widget.decoration.labelText ?? widget.label);
    } else {
      decoration = InputDecoration(
        labelText: widget.label,
        errorText: errorMsg,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.label != '' ? Text(widget.label ?? '') : Container(),
        Wrap(
            children: widget.options.map((Option option) {
          return Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                XGroupCheckbox(
                  name: option.value,
                  label: option.name,
                  value: _values.contains(option.value) ? true : false,
                  onChanged: (val) => _onSaved(value: val),
                )
              ],
            ),
          );
        }).toList()),
      ],
    );
  }
}

class XGroupCheckbox extends StatelessWidget {
  final String name;
  final String label;
  final bool value;
  final Function onChanged;
  XGroupCheckbox({this.value = false, this.name, this.label, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: this.value,
          onChanged: (val) => onChanged({name: val}),
        ),
        Text(label)
      ],
    );
  }
}
