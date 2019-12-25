import 'package:d20_dice_roller/app_theme/model/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';

List<MaterialColor> themeColors = [
  Colors.deepOrange,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.blueGrey,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lime,
];

int currentTheme = -1;

AppTheme nextTheme() {
  if (currentTheme < themeColors.length - 1) {
    currentTheme++;
  } else {
    currentTheme = 0;
  }
  return AppTheme(primarySwatch: themeColors[currentTheme]);
}

class AppThemeBloc extends ChangeNotifier {
  AppTheme appTheme;
  ThemeData themeData;

  AppThemeBloc({this.appTheme}) {
    int themeNumber = PrefService.getInt('app_theme');
    print(themeNumber);
    appTheme = AppTheme(primarySwatch: themeColors[themeNumber ?? 0]);
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

  void updateFromPreferences() {
    PrefService.disableCaching();
    int themeNumber = PrefService.getInt('app_theme');
    appTheme = AppTheme(primarySwatch: themeColors[themeNumber ?? 0]);
    requestThemeUpdate(appTheme);
  }

  void tempUpdate(int index) {
    int themeNumber = index;
    AppTheme tempAppTheme =
        AppTheme(primarySwatch: themeColors[themeNumber ?? 0]);
    requestThemeUpdate(tempAppTheme);
  }

  void undoTemp() {
    requestThemeUpdate(appTheme);
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
            title: TextStyle(color: appTheme.appBarTitle),
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
