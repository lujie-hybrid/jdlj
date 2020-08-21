import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jdlj/screen.dart';

class JdInput extends StatelessWidget {
  final String inputVal;

  final String placeholder;

  final int maxLength;

  final bool isPassword;

  final ValueChanged<String> onChanged;

  final List<TextInputFormatter> formatters;

  const JdInput(
      {Key key,
      this.placeholder,
      this.maxLength,
      this.isPassword = false,
      this.formatters,
      @required this.inputVal,
      @required this.onChanged})
      : assert(inputVal != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    InputDecoration ide = this.maxLength == null
        ? InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: ScreenAdaptor.height(20.0)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.2))),
            hintText: this.placeholder,
            hintStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.2)))
        : InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: ScreenAdaptor.height(20.0)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.2))),
            helperText: "最大长度不能超过${this.maxLength}个",
            counterText:
                '${this.inputVal.length > this.maxLength ? this.maxLength : this.inputVal.length}/${this.maxLength}',
            hintText: this.placeholder,
            hintStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.2)));
    return TextField(
      onChanged: this.onChanged,
      obscureText: this.isPassword,
      maxLength: this.maxLength,
      decoration: ide,
      inputFormatters: this.formatters,
    );
  }
}
