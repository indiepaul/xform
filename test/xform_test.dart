import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:xform/xform.dart';

class Parent extends StatelessWidget {
  final Widget child;
  Parent({this.child});
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return MaterialApp(home: Material(child: child));
    });
  }
}

void main() {
  group("Pages", () {
    testWidgets("pages count starts at 0", (WidgetTester tester) async {
      final GlobalKey<XFormState> formKey = GlobalKey<XFormState>();
      await tester.pumpWidget(Parent(
          child: XForm(key: formKey, children: <Widget>[], submit: (res) {})));
      expect(formKey.currentState.pages, 0);
      expect(formKey.currentState.page, 0);
    });

    testWidgets("pages count correctly", (WidgetTester tester) async {
      final GlobalKey<XFormState> formKey = GlobalKey<XFormState>();
      await tester.pumpWidget(Parent(
          child: XForm(
              key: formKey,
              children: <Widget>[
                ListView(
                  children: <Widget>[],
                ),
                ListView(
                  children: <Widget>[],
                ),
                ListView(
                  children: <Widget>[],
                ),
              ],
              submit: (res) {})));
      expect(formKey.currentState.pages, 3);
    });

    testWidgets("buttons don't render if pages = 0",
        (WidgetTester tester) async {
      final GlobalKey<XFormState> formKey = GlobalKey<XFormState>();
      await tester.pumpWidget(Parent(
          child: XForm(key: formKey, children: <Widget>[], submit: (res) {})));
      expect(find.byType(RaisedButton), findsNothing);
    });

    testWidgets("submit buttons renders if pages = 1",
        (WidgetTester tester) async {
      final GlobalKey<XFormState> formKey = GlobalKey<XFormState>();
      await tester.pumpWidget(Parent(
          child: XForm(
              key: formKey,
              children: <Widget>[
                ListView(children: <Widget>[]),
              ],
              submit: (res) {})));
      expect(find.byType(RaisedButton), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets("next/prev buttons renders if pages > 1",
        (WidgetTester tester) async {
      final GlobalKey<XFormState> formKey = GlobalKey<XFormState>();
      await tester.pumpWidget(Parent(
          child: XForm(
              key: formKey,
              children: <Widget>[
                ListView(children: <Widget>[]),
                ListView(children: <Widget>[]),
              ],
              submit: (res) {})));
      expect(find.byType(RaisedButton), findsNWidgets(2));
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Prev'), findsOneWidget);
    });

    testWidgets("submit button renders if pages > 1 and on last page",
        (WidgetTester tester) async {
      final GlobalKey<XFormState> formKey = GlobalKey<XFormState>();
      await tester.pumpWidget(Parent(
          child: XForm(
              key: formKey,
              children: <Widget>[
                ListView(children: <Widget>[]),
                ListView(children: <Widget>[]),
              ],
              submit: (res) {})));
      await tester.tap(find.text('Next'));
      await tester.pump();
      expect(find.byType(RaisedButton), findsNWidgets(2));
      expect(find.text('Next'), findsNothing);
      expect(find.text('Submit'), findsOneWidget);
      expect(find.text('Prev'), findsOneWidget);
    });
  });

  // testWidgets('xform test', (WidgetTester tester) async {
  //   final GlobalKey<XFormState> formKey = GlobalKey<XFormState>();
  //   var values;
  //   await tester.pumpWidget(
  //       Parent(
  //             child: XForm(
  //       key: formKey,
  //       submit: (formValues) {
  //         setState(() {
  //           values = formValues;
  //         });
  //       },
  //       children: <Widget>[
  //         ListView(children: <Widget>[
  //           XTextField(
  //             label: "Phone Number",
  //             name: "phone",
  //             type: FieldType.phone,
  //             defaultValue: "0999123234",
  //           ),
  //           XTextField(
  //             label: "Email Address",
  //             name: "email",
  //             type: FieldType.email,
  //             required: true,
  //             defaultValue: "email@mail.com",
  //           ),
  //           XTextField(
  //             label: "Password",
  //             name: "password",
  //             type: FieldType.password,
  //             minLength: 8,
  //             required: true,
  //             defaultValue: "password",
  //           ),
  //         ])
  //       ],
  //     )));
  //   formKey.currentState.submit();
  //   expect(
  //       values,
  //       equals({
  //         'phone': '0999123234',
  //         'email': 'email@mail.com',
  //         'password': 'password'
  //       }));
  // });
}
