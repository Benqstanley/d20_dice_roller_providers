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
  ThemeData themeData = ThemeData(
      textTheme: TextTheme(
          headline: TextStyle(fontSize: 26),
          button: TextStyle(
            fontSize: 18,
          ),
          display1: TextStyle(
            fontSize: 22,
            color: AppTheme.fontColor,
          )),
      primarySwatch: AppTheme.colorSwatch,
      dividerColor: AppTheme.dividerColor,
      scaffoldBackgroundColor: AppTheme.quantityBoxBackground,
      errorColor: AppTheme.dismissBackground);

  void requestThemeUpdate({
    Color dividerColor,
    Color scaffoldColor,
    Color errorColor,
    MaterialColor primarySwatch,
    Color fontColor,
  }) {
    if(primarySwatch == null && fontColor == null) {
      themeData = themeData.copyWith(
        errorColor: errorColor,
        dividerColor: dividerColor,
        scaffoldBackgroundColor: scaffoldColor,
      );
    }else{
      dividerColor = dividerColor ?? themeData.dividerColor;
      errorColor = errorColor ?? themeData.errorColor;
      scaffoldColor = scaffoldColor ?? themeData.scaffoldBackgroundColor;
      fontColor = fontColor ?? themeData.textTheme.display1.color;
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
          primarySwatch: primarySwatch,
          dividerColor: dividerColor,
          scaffoldBackgroundColor: scaffoldColor,
          errorColor: errorColor);
    }
    notifyListeners();
  }
}
