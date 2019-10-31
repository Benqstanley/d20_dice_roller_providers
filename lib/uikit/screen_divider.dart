import 'package:flutter/material.dart';

class ScreenDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 2,
      color: Theme.of(context).dividerColor,
    );
  }
}
