import 'package:flutter/material.dart';

class MultButton extends StatelessWidget {
  final Function onTap;
  final String text;

  MultButton({
    Key key,
    this.onTap,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool active = onTap != null;
    return Ink(
      decoration: BoxDecoration(
        color: active
            ? Theme.of(context).buttonColor
            : Theme.of(context).disabledColor,
        border: Border.all(),
      ),
      height: 30,
      width: 50,
      child: InkWell(
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
