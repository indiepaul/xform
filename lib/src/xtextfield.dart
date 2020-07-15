import 'package:flutter/material.dart';
import 'xfocusnode.dart';
import 'xformcontainer.dart';
import 'package:validate/validate.dart';

enum FieldType { text, password, email, numeric, phone, textarea, date }

class XTextField extends StatefulWidget {
  final String name;
  final String label;
  final String placeholder;
  final defaultValue;
  final FieldType type;
  final bool required;
  final int minLength;
  final int maxLength;
  final Widget icon;
  final TextStyle style;
  final InputDecoration decoration;
  final Function validate;
  final bool autocorrect;
  final bool disabled;
  final bool enableSuggestions;
  final TextCapitalization textCapitalization;
  XTextField(
      {this.name,
      this.label,
      this.type,
      this.defaultValue,
      this.placeholder,
      this.required = false,
      this.minLength,
      this.maxLength,
      this.style,
      this.validate,
      this.decoration,
      this.icon,
      this.textCapitalization,
      this.disabled = false,
      this.autocorrect = true,
      this.enableSuggestions = true});

  @override
  XTextFieldState createState() {
    return new XTextFieldState();
  }
}

class XTextFieldState extends State<XTextField> {
  XFocusNode focusNode;
  TextInputType keyboardType;
  InputDecoration decoration;
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
    if (widget.type == FieldType.numeric) {
      final n = num.tryParse(text);
      XFormContainer.of(context).onSave(widget.name, n);
    } else {
      XFormContainer.of(context).onSave(widget.name, text);
    }
  }

  _validate(String value) {
    if (widget.validate != null) {
      return widget.validate(value);
    } else {
      if (value.isNotEmpty) {
        if (widget.type == FieldType.email) {
          try {
            Validate.isEmail(value);
          } catch (e) {
            return '${widget.label ?? widget.name} must be a valid email address.';
          }
        }
        if (widget.type == FieldType.phone) {
          try {
            Validate.matchesPattern(value, RegExp(r'^[+]?\d*$'));
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
    }

    if (widget.required && value.isEmpty) {
      return "${widget.label ?? widget.name} is required";
    }
  }

  String getInitialValue() {
    if (widget.type == FieldType.numeric) {
      if (focusNode.defaultValue != null) {
        return focusNode.defaultValue.toString() ?? '';
      }
      if (widget.defaultValue != null) {
        return widget.defaultValue.toString() ?? '';
      }
    }
    return focusNode.defaultValue ?? widget.defaultValue;
  }

  Widget build(BuildContext context) {
    if (widget.decoration != null) {
      decoration = widget.decoration.copyWith(
          icon: widget.icon ?? null,
          hintText:
              widget.decoration.hintText ?? widget.placeholder ?? widget.label,
          filled: widget.disabled,
          fillColor: Theme.of(context).disabledColor,
          labelText: widget.decoration.labelText ?? widget.label);
    } else {
      decoration = InputDecoration(
          filled: widget.disabled,
          fillColor: Theme.of(context).disabledColor,
          icon: widget.icon ?? null,
          hintText: widget.placeholder ?? widget.label,
          labelText: widget.label);
    }
    return TextFormField(
        readOnly: widget.disabled,
        autofocus: focusNode.autoFocus,
        focusNode: focusNode.focus,
        onFieldSubmitted: (text) {
          _onSaved(text);
          XFormContainer.of(context).next(focusNode.focus);
        },
        textInputAction: focusNode.focus != null
            ? TextInputAction.next
            : TextInputAction.done,
        initialValue: getInitialValue(),
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        onSaved: _onSaved,
        validator: (value) => _validate(value),
        enableSuggestions:
            widget.type == FieldType.email ? false : widget.enableSuggestions,
        obscureText: widget.type == FieldType.password,
        keyboardType: keyboardType,
        maxLines: widget.type == FieldType.textarea ? 5 : 1,
        style: widget.style,
        autocorrect:
            widget.type == FieldType.email ? false : widget.autocorrect,
        decoration: decoration);
  }
}
