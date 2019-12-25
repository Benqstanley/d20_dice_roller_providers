import 'package:d20_dice_roller/app_theme/bloc/app_theme_bloc.dart';
import 'package:d20_dice_roller/app_theme/model/app_theme.dart';
import 'package:d20_dice_roller/app_wide_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiceRollerDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ColorScheme appColor = Theme.of(context).colorScheme;
    List<Widget> drawerItems = [
      DrawerHeader(
        child: Text(
          'Dice Roller',
          style: TextStyle(
            fontSize: 26,
            color: Provider.of<AppThemeBloc>(context).appTheme.drawerHeaderColor,
          ),
        ),
        decoration: BoxDecoration(color: appColor.primary),
      ),
      ListTile(
          leading: Icon(Icons.home),
          title: Text(
            "Home",
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context)
                .pushReplacementNamed(AppWideStrings.rollerScreenPath);
          }),
      Divider(),
      ListTile(
          leading: Icon(Icons.add),
          title: Text(
            "Create Named Collection",
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context)
                .pushReplacementNamed(AppWideStrings.createCollectionPath);
          }),
      Divider(),
      ListTile(
          leading: Icon(Icons.folder),
          title: Text(
            "View Named Collections",
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context)
                .pushReplacementNamed(AppWideStrings.viewNamedCollectionsPath);
          }),
      Divider(),
      ListTile(
          leading: Icon(Icons.history),
          title: Text(
            "History",
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context)
                .pushReplacementNamed(AppWideStrings.sessionHistoryScreenPath);
          }),
      Divider(),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text("Preferences", style: TextStyle(fontSize: 20)),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context)
              .pushReplacementNamed(AppWideStrings.preferencesScreenPath);
        },
      ),
      Divider(),
    ];
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: drawerItems.length,
          itemBuilder: (context, index) {
            return drawerItems[index];
          },
        ),
      ),
    );
  }
}
