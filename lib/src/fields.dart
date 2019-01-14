import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'xfocusnode.dart';
import 'xformcontainer.dart';

class XDateField extends StatefulWidget {
  final String name;
  final String label;
  Function onSaved;
  final DateTime defaultValue;
  final DateTime firstDate;
  final DateTime lastDate;
  XDateField(
      {this.name,
      this.label,
      this.defaultValue,
      this.firstDate,
      this.lastDate});

  @override
  XDateFieldState createState() {
    return new XDateFieldState();
  }
}

class XDateFieldState extends State<XDateField> {
  DateTime _selected;
  XFocusNode focusNode;
  @override
  void initState() {
    super.initState();
    focusNode = XFormContainer.of(context).register(widget.name);
    _selected = focusNode.defaultValue != null
        ? DateTime.parse(focusNode.defaultValue)
        : widget.defaultValue ?? null;
    _onSaved(_selected);
  }

  _onSaved(picked) {
    if (picked != null) {
      setState(() => _selected = picked);
      print("saving: ${_selected} != null = ${_selected != null}");
      XFormContainer.of(context).onSave(widget.name, picked.toString());
    }
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: widget.defaultValue ?? DateTime.now(),
        firstDate: widget.firstDate ?? DateTime(2017),
        lastDate: widget.lastDate ?? DateTime(2020));
    if (picked != null) {
      _onSaved(picked);
    }
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30.0),
      child: Ink(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1.0, color: Colors.black))),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _selected != null
                  ? Text(
                      widget.label ?? widget.name,
                      style: TextStyle(color: Colors.black54, fontSize: 12.0),
                    )
                  : Container(),
              InkWell(
                  onTap: _selectDate,
                  child: new Text(
                    _selected != null
                        ? DateFormat.yMMMEd().format(_selected)
                        : widget.label,
                    style: TextStyle(
                        color:
                            _selected != null ? Colors.black : Colors.black54,
                        fontSize: 17.0),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class FormNotes extends StatelessWidget {
  final String title;
  final String notes;
  FormNotes({this.notes, this.title});
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FormTitle(title),
        Text(
          notes,
          style: TextStyle(fontSize: 20.0),
        ),
      ],
    );
  }
}

class FormTitle extends StatelessWidget {
  final String title;
  FormTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Divider(
            color: Colors.black,
            height: 2.0,
          ),
        ),
      ],
    );
  }
}
