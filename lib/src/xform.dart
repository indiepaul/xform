import 'package:flutter/material.dart';
import 'xfocusnode.dart';
import 'xformcontainer.dart';

class XForm extends StatefulWidget {
  final Function nextPage;
  final Function prevPage;
  final Function submit;
  final bool autoValidate;
  final bool showButtons;
  final List<Widget> children;
  const XForm(
      {Key key,
      this.children,
      @required this.submit,
      this.nextPage,
      this.prevPage,
      this.autoValidate = false,
      this.showButtons = true})
      : super(key: key);
  static XFormState of(BuildContext context) {
    final _XFormScope scope = context.inheritFromWidgetOfExactType(_XFormScope);
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
  int page = 1;
  int pages;

  @override
  void initState() {
    super.initState();
    pages = widget.children.length;
    autoValidate = widget.autoValidate;
  }

  prevPage() {
    _formKey.currentState.save();
    if (page != 1) {
      setState(() {
        page = page - 1;
      });
      _controller.animateToPage(page - 1,
          curve: Curves.ease, duration: Duration(milliseconds: 200));
    }
  }

  nextPage() {
    _formKey.currentState.save();
    if (page != pages) {
      setState(() {
        page = page + 1;
      });
      _controller.animateToPage(page - 1,
          curve: Curves.ease, duration: Duration(milliseconds: 200));
    } else {
      submit();
    }
  }

  register(name) {
    XFocusNode xFocus = XFocusNode();
    if (_focusNodes.length == 0) {
      xFocus.autoFocus = true;
    }
    xFocus.focus = FocusNode();
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
      widget.submit(formValues);
    }
  }

  void onSave(field, value) {
    formValues.addEntries([new MapEntry(field, value)]);
  }

  void next(focusNode) {
    int i = _focusNodes.lastIndexOf(focusNode);
    if (i != _focusNodes.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
    } else {
      if (page == pages) {
        submit();
      } else {
        nextPage();
      }
    }
  }

  _buildButtons(int pages) {
    var backButton = RaisedButton(
      child: Text("Back"),
      onPressed: page != 1 ? () => prevPage() : null,
    );
    var nextButton = RaisedButton(
      child: Text("Next"),
      color: Theme.of(context).primaryColorLight,
      onPressed: () => nextPage(),
    );
    var submitButton = RaisedButton(
      child: Text("Submit"),
      color: Theme.of(context).primaryColorLight,
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
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: buttons);
  }

  @override
  Widget build(BuildContext context) {
    return XFormContainer(
      register: (name) => register(name),
      onSave: (field, value) => onSave(field, value),
      next: (focusNode) => next(focusNode),
      child: Form(
          key: _formKey,
          autovalidate: autoValidate,
          child: Stack(
            children: <Widget>[
              Positioned(
                child: PageView(
                    physics: ScrollPhysics(),
                    controller: _controller,
                    children: widget.children),
              ),
              Positioned(
                child: _buildButtons(pages),
                bottom: 10.0,
                left: 0.0,
                right: 0.0,
              ),
            ],
          )),
    );
  }
}

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
