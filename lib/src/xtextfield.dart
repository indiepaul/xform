import 'package:flutter/material.dart';
import 'xfocusnode.dart';
import 'xformcontainer.dart';
// import 'package:validate/validate.dart';

enum FieldType { text, password, email, numeric, phone, textarea }

class XTextField extends StatefulWidget {
  final String name;
  final String label;
  final String placeholder;
  final String defaultValue;
  final FieldType type;
  final bool required;
  final int minLength;
  final int maxLength;
  XTextField({
    this.name,
    this.label,
    this.type,
    this.defaultValue,
    this.placeholder,
    this.required = false,
    this.minLength,
    this.maxLength,
  });

  @override
  XTextFieldState createState() {
    return new XTextFieldState();
  }
}

class XTextFieldState extends State<XTextField> {
  XFocusNode focusNode;
  TextInputType keyboardType;
  @override
  void initState() {
    super.initState();
    focusNode = XFormContainer.of(context).register(widget.name);
    switch (widget.type) {
      case FieldType.text:
        keyboardType = TextInputType.text;
        break;
      case FieldType.email:
        keyboardType = TextInputType.emailAddress;
        break;
      case FieldType.numeric:
        keyboardType = TextInputType.number;
        break;
      case FieldType.phone:
        keyboardType = TextInputType.phone;
        break;
      case FieldType.textarea:
        keyboardType = TextInputType.multiline;
        break;
      default:
        keyboardType = TextInputType.text;
    }
    if (widget.type == FieldType.email) {
      keyboardType = TextInputType.emailAddress;
    }
  }

  _onSaved(text) {
    XFormContainer.of(context).onSave(widget.name, text);
  }

  _validate(String value) {
    if (value.isNotEmpty) {
      if (widget.type == FieldType.email) {
        try {
          // Validate.isEmail(value);
        } catch (e) {
          return '${widget.label ?? widget.name} must be a valid email address.';
        }
      }
      if (widget.type == FieldType.phone) {
        try {
          // Validate.isAlphaNumeric(value);
        } catch (e) {
          return '${widget.label ?? widget.name} must be a valid phone number.';
        }
      }
      if (widget.type == FieldType.numeric) {
        try {
          int.parse(value);
        } catch (e) {
          try {
            double.parse(value);
          } catch (e) {
            return '${widget.label ?? widget.name} must be a number.';
          }
        }
      }
    }
    if (widget.minLength != null) {
      if (value.length < widget.minLength) {
        return '${widget.label ?? widget.name} must be atlease ${widget.minLength} characters long.';
      }
    }
    if (widget.required && value.isEmpty) {
      return "${widget.label ?? widget.name} should not be empty";
    }
  }

  Widget build(BuildContext context) {
    return TextFormField(
        autofocus: focusNode.autoFocus,
        focusNode: focusNode.focus,
        onFieldSubmitted: (text) =>
            XFormContainer.of(context).next(focusNode.focus),
        textInputAction: focusNode.focus != null
            ? TextInputAction.next
            : TextInputAction.done,
        initialValue: focusNode.defaultValue ?? widget.defaultValue,
        onSaved: _onSaved,
        validator: (value) => _validate(value),
        obscureText: widget.type == FieldType.password,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            hintText: widget.placeholder ?? widget.label,
            labelText: widget.label));
  }
}
