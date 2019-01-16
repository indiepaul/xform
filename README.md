# XForm

## Flutter forms with superpowers.

Simplifies form creation and management. Simply create form fields and the xform will take care of the rest. Moving to the next field on enter, keyboard type based on field type, validation, multipage forms, etc.

## Supported Fields
* XTextField - Your usual text field
* XDateField - Text field with a date picker
* XSelectField - Dropdown selection box

## Quick Start

* Add the XForm widget to a stateful widget
* Add XFields as children, each page wrapped in a ListView.
* Add a submit function to handle the data on submission.

### Example

``` dart
import 'package:flutter/material.dart';
import 'package:xform/xform.dart';

void main() => runApp(MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Text('XForm')), body: FormWidget()),
    ));

class FormWidget extends StatefulWidget {
  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  _submit(formData) {
    print(formData);
  }
  
  @override
  Widget build(BuildContext context) {  
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: XForm(submit: _submit, children: <Widget>[
        ListView(children: <Widget>[
          XTextField(
            name: "name",
            label: "Name",
            required: true,
          ),
          XTextField(
            name: "email",
            label: "Email Address",
            type: FieldType.email,
          ),
        ]),
      ]),
    );
  }
}
```