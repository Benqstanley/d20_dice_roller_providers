import 'package:d20_dice_roller/app_wide_strings.dart';
import 'package:flutter/material.dart';

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
            color: Colors.white,
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
          })
    ];
    return Drawer(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: drawerItems.length,
        itemBuilder: (context, index) {
          return drawerItems[index];
        },
      ),
    );
  }
}
