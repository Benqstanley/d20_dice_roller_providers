import 'package:flutter/material.dart';

class MultButton extends StatelessWidget {
  final Function onTap;
  final String text;

  MultButton({
    this.onTap,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: Theme.of(context).buttonColor,
        border: Border.all(),
      ),
      height: 30,
      width: 50,
      child: InkWell(
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
