import 'package:flutter/material.dart';
import 'package:xform/xform.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Future _submit(Map<String, dynamic> formData) async {
      List<Widget> children = [];
      formData.forEach((key, value) {
        children.add(Text("$key: ${value.toString()} ${value.runtimeType}"));
      });
      showDialog(
        context: scaffoldKey.currentState.context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Form Data"),
            content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children),
            actions: <Widget>[
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('XForm'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: XForm(submit: _submit, children: <Widget>[
            ListView(children: <Widget>[
              XTextField(
                name: "name",
                label: "Name",
                required: true,
              ),
              XTextField(
                name: "number",
                label: "Number",
                type: FieldType.numeric,
              ),
              XTextField(
                name: "email",
                label: "Email Address",
                type: FieldType.email,
              ),
              XTextField(
                name: "password",
                label: "Password",
                type: FieldType.password,
              ),
            ]),
            ListView(children: <Widget>[
              XCheckbox(
                name: "agree",
                label: "I agree",
                defaultValue: true,
              ),
              XRadioGroup(
                name: 'radios',
                selected: "male",
                options: [
                  Option(name: "Male", value: "male"),
                  Option(name: "Female", value: "female"),
                ],
              ),
              XCheckboxGroup(
                name: 'favourite',
                label: 'Favourite Food',
                selected: ["cake"],
                options: [
                  Option(name: "Cake", value: "cake"),
                  Option(name: "Candy", value: "candy"),
                ],
              ),
            ]),
            ListView(children: <Widget>[
              XDateField(
                name: "date",
                label: "Date of Birth",
                defaultValue: DateTime.now(),
              ),
              XSelectField(
                name: "options",
                label: "Options",
                required: true,
                options: [Option(name: "Name", value: "value")],
              )
            ]),
          ]),
        ),
      ),
    );
  }
}
