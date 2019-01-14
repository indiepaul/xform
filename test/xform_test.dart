import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:xform/xform.dart';

void main() {
  testWidgets('xform test', (WidgetTester tester) async {
    final GlobalKey<XFormState> formKey = GlobalKey<XFormState>();
    var values;
    await tester.pumpWidget(
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return MaterialApp(
          home: Material(
              child: XForm(
        key: formKey,
        submit: (formValues) {
          setState(() {
            values = formValues;
          });
        },
        children: <Widget>[
          ListView(children: <Widget>[
            XTextField(
              label: "Phone Number",
              name: "phone",
              type: FieldType.phone,
              defaultValue: "0999123234",
            ),
            XTextField(
              label: "Email Address",
              name: "email",
              type: FieldType.email,
              required: true,
              defaultValue: "email@mail.com",
            ),
            XTextField(
              label: "Password",
              name: "password",
              type: FieldType.password,
              minLength: 8,
              required: true,
              defaultValue: "password",
            ),
          ])
        ],
      )));
    }));
    formKey.currentState.submit();
    expect(
        values,
        equals({
          'phone': '0999123234',
          'email': 'email@mail.com',
          'password': 'password'
        }));
  });
}
