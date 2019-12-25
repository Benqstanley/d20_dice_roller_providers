import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';

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

          return GridView(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
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
