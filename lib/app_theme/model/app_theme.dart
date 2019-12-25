import 'package:flutter/material.dart';

const MaterialColor defaultColorSwatch = Colors.green;
const Color defaultFontColor = Colors.black;
const Color defaultDividerColor = Colors.black;
const Color defaultDrawerHeaderColor = Colors.white;
const Color defaultErrorColor = Colors.red;

class AppTheme {
  Color dividerColor;
  Color scaffoldColor;
  Color errorColor;
  MaterialColor primarySwatch;
  Color fontColor;
  Color drawerHeaderColor;
  Color appBarTitle;

  AppTheme({
    this.dividerColor,
    this.scaffoldColor,
    this.errorColor,
    this.primarySwatch,
    this.fontColor,
    this.drawerHeaderColor = Colors.white,
    this.appBarTitle,
  });

  factory AppTheme.defaultTheme() {
    return AppTheme(
      dividerColor: defaultDividerColor,
      fontColor: defaultFontColor,
      scaffoldColor: defaultColorSwatch[100],
      errorColor: defaultErrorColor,
      primarySwatch: defaultColorSwatch,
      appBarTitle: defaultDrawerHeaderColor,
      drawerHeaderColor: defaultDrawerHeaderColor,
    );
  }
}
