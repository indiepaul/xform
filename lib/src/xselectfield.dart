import 'package:flutter/material.dart';
import 'xfocusnode.dart';
import 'xformcontainer.dart';

class Option {
  String index;
  String name;
  String value;
  Option({this.name, this.value});
}

class XSelectField extends StatefulWidget {
  String name;
  String label;
  Option selected = Option();
  List<Option> options;
  final Function onSaved;
  XSelectField(
      {this.name, this.label, this.options, this.selected, this.onSaved});

  @override
  XSelectFieldState createState() {
    return new XSelectFieldState();
  }
}

class XSelectFieldState extends State<XSelectField> {
  String _selected = '';
  XFocusNode focusNode;
  @override
  void initState() {
    super.initState();
    focusNode = XFormContainer.of(context).register(widget.name);
    _selected = focusNode.defaultValue;
    _onSaved(_selected);
  }

  _onSaved(text) {
    XFormContainer.of(context).onSave(widget.name, text);
  }

  Widget build(BuildContext context) {
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
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
            // icon: const Icon(Icons.color_lens),
            labelText: widget.label ?? widget.name,
          ),
          isEmpty: _selected == '',
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
