import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'xfocusnode.dart';
import 'xformcontainer.dart';

enum XDateFormat { date, time, datetime }

class XDateField extends StatefulWidget {
  final String name;
  final String label;
  final String placeholder;
  final bool required;
  final DateTime defaultValue;
  final XDateFormat format;
  final DateTime firstDate;
  final DateTime lastDate;
  final TextStyle style;
  final Widget icon;
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
      this.icon,
      this.decoration,
      this.validate,
      this.style,
      this.format = XDateFormat.date});

  @override
  XDateFieldState createState() {
    return new XDateFieldState();
  }
}

class XDateFieldState extends State<XDateField> {
  DateTime _selected;
  TimeOfDay _tod;
  XFocusNode focusNode;
  InputDecoration decoration;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    focusNode = XFormContainer.of(context).register(widget.name);
    switch (widget.format) {
      case XDateFormat.date:
        _selected = focusNode.defaultValue != null
            ? focusNode.defaultValue
            : widget.defaultValue ?? null;
        _onSaved(_selected);
        break;
      case XDateFormat.time:
        // _tod = focusNode.defaultValue != null
        // ? focusNode.defaultValue
        // : widget.defaultValue ?? null;
        _tod = TimeOfDay(
            hour: widget.defaultValue.hour, minute: widget.defaultValue.minute);
        _onSaved(_tod);
        break;
      case XDateFormat.datetime:
        _selected = focusNode.defaultValue != null
            ? focusNode.defaultValue
            : widget.defaultValue ?? null;
        _selected = _selected.subtract(
            Duration(hours: _selected.hour, minutes: _selected.minute));
        _onSaved(_selected);
        _tod = TimeOfDay(
            hour: widget.defaultValue.hour, minute: widget.defaultValue.minute);
        _onSaved(_tod);
        break;
      default:
        _selected = focusNode.defaultValue != null
            ? focusNode.defaultValue
            : widget.defaultValue ?? null;
        _onSaved(_selected);
    }
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

  Future _chooseTime(BuildContext context, String time) async {
    var initialTime = TimeOfDay.now();
    // var initialTime =
    //     widget.defaultValue ?? convertToDate(time) ?? DateTime.now();
    var result =
        await showTimePicker(context: context, initialTime: initialTime);
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

  TimeOfDay convertToTime(String input) {
    try {
      var d = TimeOfDay.fromDateTime(DateTime.parse(input));
      return d;
    } catch (e) {
      return null;
    }
  }

  _validate(String value) {
    if (widget.validate != null) {
      return widget.validate(value);
    }
    // var d = _selected;
    // if (widget.required && d == null) {
    //   return "Enter a valid date format";
    // }
    if (widget.required && value.isEmpty) {
      return "${widget.label ?? widget.name} is required";
    }
  }

  _onSaved(picked) {
    if (picked.runtimeType == String) {
      picked = convertToDate(picked);
    }
    if (picked != null && picked.runtimeType == DateTime) {
      _selected = picked;
    }
    if (picked != null && picked is TimeOfDay) {
      _tod = picked;
    }
    var val;
    setState(() {
      if (_tod != null && _selected != null) {
        val = _selected.add(Duration(hours: _tod.hour, minutes: _tod.minute));
        _controller.text =
            DateFormat.MMMMEEEEd().addPattern("jm", ', ').format(val);
      } else if (_tod != null) {
        val = _tod;
        _controller.text = _tod.format(context);
      } else if (_selected != null) {
        val = _selected;
        _controller.text = DateFormat.yMMMMd().format(_selected);
      }
    });
    XFormContainer.of(context).onSave(widget.name, val);
  }

  Widget build(BuildContext context) {
    if (focusNode.focus.hasFocus) {
      focusNode.focus.unfocus();
    }
    if (widget.decoration != null) {
      decoration = widget.decoration.copyWith(
          icon: widget.icon ?? null,
          hintText:
              widget.decoration.hintText ?? widget.placeholder ?? widget.label,
          labelText: widget.decoration.labelText ?? widget.label);
    } else {
      decoration = InputDecoration(
          icon: widget.icon ?? null,
          hintText: widget.placeholder ?? widget.label,
          labelText: widget.label);
    }
    return InkWell(
      onTap: (() async {
        if (widget.format == XDateFormat.date ||
            widget.format == XDateFormat.datetime)
          await _chooseDate(context, _controller.text);
        if (widget.format == XDateFormat.time ||
            widget.format == XDateFormat.datetime)
          await _chooseTime(context, _controller.text);
      }),
      child: IgnorePointer(
          ignoring: true,
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
    );
  }
}
