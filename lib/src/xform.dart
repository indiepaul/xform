import 'dart:async';

import 'package:flutter/material.dart';
import 'xfocusnode.dart';
import 'xformcontainer.dart';

class XForm extends StatefulWidget {
  final Function nextPage;
  final Function prevPage;
  final Function(Map<String, dynamic>) submit;
  final Function(Map<String, dynamic>, bool) onSave;
  final bool autoValidate;
  final bool autoFocus;
  final bool autoPageSwitch;
  final bool showButtons;
  final List<Widget> children;
  const XForm(
      {Key key,
      this.children,
      @required this.submit,
      this.onSave,
      this.nextPage,
      this.prevPage,
      this.autoValidate = false,
      this.autoPageSwitch = true,
      this.autoFocus = true,
      this.showButtons = true})
      : super(key: key);
  static XFormState of(BuildContext context) {
    final _XFormScope scope =
        context.dependOnInheritedWidgetOfExactType<_XFormScope>();
    return scope?._formState;
  }

  @override
  XFormState createState() => XFormState();
}

class XFormState extends State<XForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PageController _controller = new PageController();
  Map<String, dynamic> formValues = {};
  bool autoValidate;
  List<FocusNode> _focusNodes = [];
  FocusNode currentFocus;
  bool switching = false;
  int page;
  int pages;

  @override
  void initState() {
    super.initState();
    if (widget.children == null) {
      page = 0;
      pages = 0;
    } else {
      pages = widget.children.length;
      page = pages > 0 ? 1 : 0;
    }
    autoValidate = widget.autoValidate;
  }

  prevPage() {
    _formKey.currentState.save();
    if (page != 1) {
      if (_formKey.currentState.validate()) {
        setState(() {
          autoValidate = widget.autoValidate;
          page = page - 1;
        });
      } else {
        setState(() {
          autoValidate = true;
        });
      }
      _controller.animateToPage(page - 1,
          curve: Curves.ease, duration: Duration(milliseconds: 250));
    }
  }

  nextPage({int i}) {
    _formKey.currentState.save();
    if (page != pages) {
      if (_formKey.currentState.validate()) {
        setState(() {
          autoValidate = widget.autoValidate;
          page = page + 1;
        });
        _controller.animateToPage(page - 1,
            curve: Curves.ease, duration: Duration(milliseconds: 250));
        if (i != null) FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
      } else {
        setState(() {
          autoValidate = true;
        });
      }
    } else {
      submit();
    }
    cancelSwitch();
  }

  cancelSwitch() async {
    await Future.delayed(Duration(milliseconds: 500));
    switching = false;
  }

  register(name) {
    XFocusNode xFocus = XFocusNode();
    xFocus.focus = FocusNode();
    if (switching || widget.autoFocus && _focusNodes.length == 0) {
      xFocus.autoFocus = true;
      currentFocus = xFocus.focus;
      FocusScope.of(context).requestFocus(currentFocus);
      switching = false;
    }
    _focusNodes.add(xFocus.focus);
    if (formValues.containsKey(name)) {
      xFocus.defaultValue = formValues[name];
    }
    return xFocus;
  }

  submit() {
    setState(() {
      autoValidate = true;
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _focusNodes.last.unfocus();
      widget.submit(formValues);
    }
  }

  bool save() {
    _formKey.currentState.save();
    return _formKey.currentState.validate();
  }

  void onSave(field, value) {
    formValues.addEntries([new MapEntry(field, value)]);
  }

  void next(FocusNode focusNode) {
    currentFocus = focusNode;
    focusNode.unfocus();
    FocusScope.of(context).unfocus();
    switching = true;
    int i = _focusNodes.lastIndexOf(focusNode);
    if (i != _focusNodes.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
    } else {
      if (page == pages) {
        submit();
      } else {
        if (widget.autoPageSwitch) nextPage(i: i);
        if (widget.onSave != null)
          widget.onSave(formValues, _formKey.currentState.validate());
      }
    }
  }

  _buildButtons(int pages) {
    var backButton = RaisedButton(
      child: Text("Prev"),
      onPressed: page != 1 ? () => prevPage() : null,
    );
    var nextButton = RaisedButton(
      child: Text("Next"),
      // color: Theme.of(context).primaryColorLight,
      onPressed: () => nextPage(),
    );
    var submitButton = RaisedButton(
      child: Text("Submit"),
      // color: Theme.of(context).primaryColorLight,
      onPressed: () => submit(),
    );
    List<Widget> buttons = [];
    if (widget.showButtons) {
      if (pages > 1) {
        buttons.add(backButton);
        buttons.add(Text("Page $page of $pages"));
      }
      if (pages == page) {
        buttons.add(submitButton);
      } else {
        buttons.add(nextButton);
      }
    }
    if (pages > 0)
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: buttons);
  }

  @override
  Widget build(BuildContext context) {
    widget.children.map((c) {
      if (c is ListView) {}
    });
    return XFormContainer(
      register: (name) => register(name),
      onSave: (field, value) => onSave(field, value),
      next: (focusNode) => next(focusNode),
      save: () => save(),
      child: Form(
          key: _formKey,
          autovalidate: autoValidate,
          child: Column(
            children: <Widget>[
              Flexible(
                fit: FlexFit.loose,
                child: PageView(
                    physics: ScrollPhysics(),
                    controller: _controller,
                    children: widget.children),
              ),
              Container(
                child: _buildButtons(pages),
              ),
            ],
          )),
    );
  }
}
// widget.children.length == 1
//                           ? Column(children: widget.children)
//                           : PageView(
//                               physics: ScrollPhysics(),
//                               controller: _controller,
//                               children: widget.children),

class _XFormScope extends InheritedWidget {
  const _XFormScope({Key key, Widget child, XFormState formState})
      : _formState = formState,
        // _generation = generation,
        super(key: key, child: child);

  final XFormState _formState;

  /// Incremented every time a form field has changed. This lets us know when
  /// to rebuild the form.
  // final int _generation;

  /// The [Form] associated with this widget.
  // XForm get form => _formState.widget;

  @override
  bool updateShouldNotify(_XFormScope old) => true;
}
