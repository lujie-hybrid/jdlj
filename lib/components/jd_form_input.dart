import 'package:flutter/material.dart';
import 'package:jdlj/screen.dart';

class JdFormInput extends StatefulWidget {
  final String placeholder;

  final int maxLength;

  final bool isPassword;

  final String Function(String) validator;

  final void Function(String) onSaved;

  final bool isArea;

  final String initialValue;

  const JdFormInput(
      {Key key,
      this.placeholder,
      this.maxLength,
      this.isPassword = false,
      this.onSaved,
      this.isArea = false,
      this.initialValue,
      this.validator})
      : super(key: key);

  @override
  _JdFormInputState createState() => _JdFormInputState();
}

class _JdFormInputState extends State<JdFormInput> {
  FocusNode _fn = FocusNode();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _fn,
      onFieldSubmitted: (value) {
        _fn.unfocus();
      },
      onEditingComplete: () {
        _fn.unfocus();
      },
      initialValue: widget.initialValue,
      obscureText: widget.isPassword,
      maxLength: widget.maxLength,
      validator: widget.validator,
      onSaved: widget.onSaved,
      minLines: widget.isArea ? 4 : 1,
      maxLines: widget.isArea ? 4 : 1,
      decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: ScreenAdaptor.height(20.0)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.2))),
          hintText: widget.placeholder,
          hintStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.2))),
    );
    ;
  }
}
