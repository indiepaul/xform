import 'package:flutter/material.dart';
import 'package:xform/xform.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    _submit(formData) async {
      showDialog(
        context: scaffoldKey.currentState.context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Form Data"),
            content: Text(formData.toString()),
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
              ),
              XTextField(
                name: "value",
                label: "Value",
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
