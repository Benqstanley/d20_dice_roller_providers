import 'package:d20_dice_roller/app_wide_strings.dart';
import 'package:d20_dice_roller/choose_named_collection/ui/choose_named_collection_screen.dart';
import 'package:d20_dice_roller/create_named_collection/ui/create_named_collection_screen.dart';
import 'package:d20_dice_roller/navigation/dice_roller_drawer.dart';
import 'package:d20_dice_roller/roller/model/roller_screen_model.dart';
import 'package:d20_dice_roller/roller/ui/roller_screen.dart';
import 'package:d20_dice_roller/session_history/model/session_history_model.dart';
import 'package:d20_dice_roller/session_history/ui/session_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(DiceRollerMain());

class DiceRollerMain extends StatelessWidget {
  final SessionHistoryModel sessionHistoryModel = SessionHistoryModel();
  final RollerScreenModel rollerScreenModel = RollerScreenModel();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RollerScreenModel>(
            builder: (context) => rollerScreenModel),
        ChangeNotifierProvider<SessionHistoryModel>(
            builder: (context) => sessionHistoryModel),
      ],
      child: MaterialApp(
        title: 'Dice Roller',
        theme: ThemeData(
            textTheme: TextTheme(
                headline: TextStyle(fontSize: 26),
                button: TextStyle(
                  fontSize: 18,
                ),
                display1: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                )),
            primarySwatch: Colors.green,
            dividerColor: Colors.black,
            scaffoldBackgroundColor: Colors.green[100]),
        home: PageWrapper(
          title: AppWideStrings.rollerScreenTitle,
          child: RollerScreen(),
        ),
        routes: {
          AppWideStrings.sessionHistoryScreenPath: (ctx) {
            return PageWrapper(
              title: AppWideStrings.sessionHistoryScreenTitle,
              child: SessionHistoryScreen(),
            );
          },
          AppWideStrings.createCollectionPath: (ctx) => CreateNamedCollection(),
          AppWideStrings.viewNamedCollectionsPath: (ctx) => PageWrapper(
                child: ViewNamedCollections(),
                title: AppWideStrings.viewNamedCollectionTitle,
              ),
        },
      ),
    );
  }
}

class PageWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  final AppBar appBar;
  final bool keyed;

  PageWrapper({
    @required this.child,
    this.title,
    this.appBar,
    this.keyed = false
  }) : assert(appBar != null || title != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: keyed ? UniqueKey() : null,
      drawer: DiceRollerDrawer(),
      body: child,
      appBar: appBar ??
          AppBar(
            title: Text(title),
          ),
    );
  }
}

