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
    ]);
  }
}
