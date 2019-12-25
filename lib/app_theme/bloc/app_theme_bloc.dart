import 'package:d20_dice_roller/app_theme/model/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ThemeColors {
  green,
  blue,
  cyan,
  purple,
  bluegrey,
}

class AppThemeBloc extends ChangeNotifier {
  AppTheme appTheme;
  ThemeData themeData;

  AppThemeBloc({this.appTheme}){
    appTheme = appTheme ?? AppTheme.defaultTheme();
    themeData = themeData = ThemeData(
        textTheme: TextTheme(
            headline: TextStyle(fontSize: 26),
            title: TextStyle(color: appTheme.appBarTitle),
            button: TextStyle(
              fontSize: 18,
            ),
            display1: TextStyle(
              fontSize: 22,
              color: defaultFontColor,
            )),
        primarySwatch: defaultColorSwatch,
        dividerColor: defaultDividerColor,
        scaffoldBackgroundColor: defaultColorSwatch[100],
        errorColor: defaultErrorColor);
  }

  void requestThemeUpdate(AppTheme appTheme) {
    Color dividerColor;
    Color errorColor;
    Color scaffoldColor;
    Color fontColor;
    MaterialColor colorSwatch;
    if (appTheme.primarySwatch == null) {
      appTheme.primarySwatch = this.appTheme.primarySwatch;
    }
    this.appTheme = appTheme;
    dividerColor = appTheme.dividerColor ?? themeData.dividerColor;
    errorColor = appTheme.errorColor ?? themeData.errorColor;
    scaffoldColor = appTheme.scaffoldColor ?? themeData.scaffoldBackgroundColor;
    fontColor = appTheme.fontColor ?? themeData.textTheme.display1.color;
    colorSwatch = appTheme.primarySwatch;
    themeData = ThemeData(
        textTheme: TextTheme(
            headline: TextStyle(fontSize: 26),
            button: TextStyle(
              fontSize: 18,
            ),
            display1: TextStyle(
              fontSize: 22,
              color: fontColor,
            )),
        primarySwatch: colorSwatch,
        dividerColor: dividerColor,
        scaffoldBackgroundColor: scaffoldColor,
        errorColor: errorColor);
    notifyListeners();
  }

}
