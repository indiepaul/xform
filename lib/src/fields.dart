import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'xfocusnode.dart';
import 'xformcontainer.dart';

class XDateField extends StatefulWidget {
  final String name;
  final String label;
  final String placeholder;
  final bool required;
  final DateTime defaultValue;
  final DateTime firstDate;
  final DateTime lastDate;
  final TextStyle style;
  final InputDecoration decoration;
  final Function validate;
  XDateField(
      {this.name,
      this.label,
      this.placeholder,
      this.required = false,
      this.defaultValue,
      this.firstDate,
      this.lastDate,
      this.decoration,
      this.validate,
      this.style});

  @override
  XDateFieldState createState() {
    return new XDateFieldState();
  }
}

class XDateFieldState extends State<XDateField> {
  DateTime _selected;
  XFocusNode focusNode;
  InputDecoration decoration;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    focusNode = XFormContainer.of(context).register(widget.name);
    _selected = focusNode.defaultValue != null
        ? DateTime.parse(focusNode.defaultValue)
        : widget.defaultValue ?? null;
    _onSaved(_selected);
    _controller.text = _selected != null
        ? DateFormat.yMMMMd().format(_selected)
        : widget.label ?? '';
  }

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var initialDate = widget.defaultValue ??
        convertToDate(initialDateString) ??
        DateTime.now();
    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: widget.firstDate ?? DateTime(1900),
        lastDate: widget.lastDate ?? DateTime(initialDate.year + 100));
    if (result == null) return;
    _onSaved(result);
  }

  DateTime convertToDate(String input) {
    try {
      var d = DateFormat.yMMMMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  _validate(String value) {
    if (widget.validate != null) {
      return widget.validate(value);
    }
    var d = convertToDate(value);
    if (d == null) {
      return "Enter a valid date format";
    }
    if (widget.required && value.isEmpty) {
      return "${widget.label ?? widget.name} is required";
    }
  }

  _onSaved(picked) {
    if (picked.runtimeType == String) {
      picked = convertToDate(picked);
    }
    if (picked != null) {
      setState(() {
        _selected = picked;
        _controller.text = DateFormat.yMMMMd().format(picked);
      });
      XFormContainer.of(context).onSave(widget.name, picked.toString());
    }
  }

  Widget build(BuildContext context) {
    if (widget.decoration != null) {
      decoration = widget.decoration.copyWith(
          hintText:
              widget.decoration.hintText ?? widget.placeholder ?? widget.label,
          labelText: widget.decoration.labelText ?? widget.label);
    } else {
      decoration = InputDecoration(
          hintText: widget.placeholder ?? widget.label,
          labelText: widget.label);
    }
    return Row(children: <Widget>[
      Expanded(
          child: TextFormField(
        autofocus: focusNode.autoFocus,
        focusNode: focusNode.focus,
        onSaved: _onSaved,
        validator: (value) => _validate(value),
        decoration: decoration,
        controller: _controller,
        onFieldSubmitted: (text) =>
            XFormContainer.of(context).next(focusNode.focus),
        textInputAction: focusNode.focus != null
            ? TextInputAction.next
            : TextInputAction.done,
        keyboardType: TextInputType.datetime,
      )),
      IconButton(
        icon: Icon(Icons.more_horiz),
        tooltip: 'Choose date',
        onPressed: (() {
          _chooseDate(context, _controller.text);
        }),
      )
    ]);
  }
}
