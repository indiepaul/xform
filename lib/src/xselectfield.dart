import 'package:flutter/material.dart';
import 'xfocusnode.dart';
import 'xformcontainer.dart';
import 'option.dart';

class XSelectField extends StatefulWidget {
  final String name;
  final String label;
  final String selected;
  final bool required;
  final List<Option> options;
  final Function onSaved;
  final InputDecoration decoration;
  XSelectField(
      {this.name,
      this.label,
      this.required = false,
      this.options,
      this.selected,
      this.onSaved,
      this.decoration});

  @override
  XSelectFieldState createState() {
    return new XSelectFieldState();
  }
}

class XSelectFieldState extends State<XSelectField> {
  String _selected;
  XFocusNode focusNode;
  InputDecoration decoration;
  String errorMsg;
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
      _selected = val;
    });
    XFormContainer.of(context).onSave(widget.name, val);
  }

  _validate(value) {
    setState(() {
      errorMsg = null;
    });
    if (widget.required && (_selected == '' || _selected == null)) {
      setState(() {
        errorMsg = "${widget.label ?? widget.name} is required";
      });
      return "${widget.label ?? widget.name} is required";
    }
  }

  Widget build(BuildContext context) {
    if (widget.decoration != null) {
      decoration = widget.decoration
          .copyWith(labelText: widget.decoration.labelText ?? widget.label);
    } else {
      decoration =
          InputDecoration(labelText: widget.label, errorText: errorMsg);
    }
    List<DropdownMenuItem<String>> items = [
      DropdownMenuItem(value: '', child: Text(''))
    ];
    widget.options.map((Option option) {
      items.add(DropdownMenuItem(
        value: option.value,
        child: Text(option.name),
      ));
    }).toList();
    return FormField(
      validator: (val) => _validate(val),
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: decoration,
          isEmpty: _selected == '' || _selected == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: _selected,
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  _selected = newValue;
                });
                _onSaved(newValue);
              },
              items: items,
            ),
          ),
        );
      },
    );
  }
}
