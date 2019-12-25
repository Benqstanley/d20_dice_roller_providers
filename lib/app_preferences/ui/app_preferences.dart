import 'package:d20_dice_roller/app_theme/bloc/app_theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

class AppPreferences extends StatefulWidget {
  @override
  _AppPreferencesState createState() => _AppPreferencesState();
}

class _AppPreferencesState extends State<AppPreferences> {
  @override
  Widget build(BuildContext context) {
    return PreferencePage([
      PreferenceTitle('Show Detailed Rolls'),
      SwitchPreference(
        "Detailed Rolls",
        'roll_detail',
        defaultVal: true,
      ),
      PreferenceTitle('App Theme'),
      PreferenceDialogLink(
        "Theme",
        onPop: () {
          Provider.of<AppThemeBloc>(context).updateFromPreferences();
        },
        dialog: ThemePicker(
          null,
          cancelText: "Cancel",
          submitText: "Ok",
          onlySaveOnSubmit: true,
        ),
      )
    ]);
  }
}

class ThemePicker extends PreferenceDialog {
  ThemePicker(List<Widget> preferences,
      {String title,
      String submitText,
      bool onlySaveOnSubmit = false,
      String cancelText})
      : super(
          preferences,
          title: title,
          submitText: submitText,
          onlySaveOnSubmit: onlySaveOnSubmit,
          cancelText: cancelText,
        );

  @override
  PreferenceDialogState createState() {
    return ThemePickerState();
  }
}

class ThemePickerState extends PreferenceDialogState {
  int selectedWidget = PrefService.getInt('app_theme');

  void initState() {
    super.initState();

    if (widget.onlySaveOnSubmit) {
      PrefService.clearCache();
      PrefService.enableCaching();
    }
  }

  @override
  void dispose() {
    PrefService.disableCaching();
    PrefService.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title == null ? null : Text(widget.title),
      content: FutureBuilder(
        future: PrefService.init(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          return Container(
            width: double.maxFinite,
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              shrinkWrap: true,
              itemCount: themeColors.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: ColorTile(themeColors[index], index, selectedWidget, () {
                  PrefService.setInt("app_theme", index);
                  Provider.of<AppThemeBloc>(context).tempUpdate(index);
                  setState(() {
                    selectedWidget = index;
                  });
                }),
              ),
            ),
          );
        },
      ),
      actions: <Widget>[]
        ..addAll(widget.cancelText == null
            ? []
            : [
                FlatButton(
                  child: Text(widget.cancelText),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ])
        ..addAll(widget.submitText == null
            ? []
            : [
                FlatButton(
                  child: Text(widget.submitText),
                  onPressed: () {
                    if (widget.onlySaveOnSubmit) {
                      PrefService.applyCache();
                    }
                    Navigator.of(context).pop();
                  },
                )
              ]),
    );
  }
}

class ColorTile extends StatefulWidget {
  final MaterialColor color;
  final int index;
  final int selectedIndex;
  final Function setIndex;

  ColorTile(this.color, this.index, this.selectedIndex, this.setIndex);

  @override
  _ColorTileState createState() => _ColorTileState();
}

class _ColorTileState extends State<ColorTile> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    print("Widget ${widget.index} is Selected $isSelected");
    print("selected index is ${widget.selectedIndex}");
    isSelected = widget.selectedIndex == widget.index;
    return InkWell(
      onTap: () {
        setState(() {
          widget.setIndex();
          isSelected = true;
        });
      },
      child: Container(
        child: Stack(
          children: isSelected
              ? [
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(Icons.check),
                  )
                ]
              : <Widget>[],
        ),
        color: widget.color,
      ),
    );
  }
}
