import 'package:flutter/material.dart';

class DiceRollerDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> drawerItems = [
      DrawerHeader(
        child: Text(
          'Dice Roller',
          style: TextStyle(
            fontSize: 26,
            color: Colors.white,
          ),
        ),
        decoration: BoxDecoration(color: Colors.blue),
      ),
      ListTile(
        leading: Icon(Icons.home),
        title: Text(
          "Home",
          style: TextStyle(fontSize: 20),
        ),
        onTap: () async => Navigator.of(context).pushNamed('/home'),
      )
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
