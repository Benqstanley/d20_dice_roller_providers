import 'package:d20_dice_roller/app_wide_strings.dart';
import 'package:d20_dice_roller/choose_named_collection/ui/choose_named_collection_screen.dart';
import 'package:d20_dice_roller/create_named_collection/ui/create_named_collection_screen.dart';
import 'package:d20_dice_roller/navigation/dice_roller_drawer.dart';
import 'package:d20_dice_roller/roller/ui/roller_screen.dart';
import 'package:d20_dice_roller/session_history/ui/session_history_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(DiceRollerMain());

class DiceRollerMain extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice Roller',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: PageWrapper(
        title: AppWideStrings.rollerScreenTitle,
        child: RollerScreen(),
      ),
      routes: {
        AppWideStrings.sessionHistoryScreenPath: (ctx)  {
          return PageWrapper(
              title: AppWideStrings.sessionHistoryScreenTitle,
              child: SessionHistoryScreen(),
            );},
        AppWideStrings.createCollectionPath: (ctx) => PageWrapper(
              child: CreateNamedCollection(),
              title: AppWideStrings.createCollectionTitle,
            ),
        AppWideStrings.viewNamedCollectionsPath: (ctx) => PageWrapper(
              child: ViewNamedCollections(),
              title: AppWideStrings.viewNamedCollectionTitle,
            )
      },
    );
  }
}

class PageWrapper extends StatelessWidget {
  final String title;
  final Widget child;

  PageWrapper({@required this.child, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      drawer: DiceRollerDrawer(),
      body: child,
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}
