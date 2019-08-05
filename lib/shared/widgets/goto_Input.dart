import 'package:flutter/material.dart';

/// 跳转page时的输入框
class GoToInput extends StatelessWidget {
  GoToInput({
    Key key,
    @required this.controller,
    @required this.onChanged,
  }) : super(key: key);
  final TextEditingController controller;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff17181a),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        onChanged: onChanged,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'PAGE #',
          hintStyle: TextStyle(color: Colors.white60),
          border: InputBorder.none,
        ),
        textAlign: TextAlign.center,
        cursorColor: Theme.of(context).accentColor,
        cursorWidth: 2,
        cursorRadius: Radius.circular(4.0),
      ),
    );
  }
}
