import 'package:d20_dice_roller/app_preferences/ui/app_preferences.dart';
import 'package:d20_dice_roller/app_theme/model/app_theme.dart';
import 'package:d20_dice_roller/app_wide_strings.dart';
import 'package:d20_dice_roller/named_collections/choose_named_collection/ui/choose_named_collection_screen.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/ui/create_named_collection_screen.dart';
import 'package:d20_dice_roller/navigation/dice_roller_drawer.dart';
import 'package:d20_dice_roller/roller/bloc/roller_screen_bloc.dart';
import 'package:d20_dice_roller/roller/ui/roller_screen.dart';
import 'package:d20_dice_roller/session_history/model/session_history_model.dart';
import 'package:d20_dice_roller/session_history/ui/session_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');
  PrefService.setDefaultValues({
    'roll_detail': true,
    'theme_color': 'green'
  });

  runApp(DiceRollerMain());
}

class DiceRollerMain extends StatelessWidget {
  final SessionHistoryModel sessionHistoryModel = SessionHistoryModel();
  final RollerScreenBloc rollerScreenModel = RollerScreenBloc();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RollerScreenBloc>(
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
                  color: AppTheme.fontColor,
                )),
            primarySwatch: AppTheme.colorSwatch,
            dividerColor: AppTheme.dividerColor,
            scaffoldBackgroundColor: AppTheme.colorSwatch[100]),
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
          AppWideStrings.createCollectionPath: (ctx) =>
              CreateNamedCollectionScreen(),
          AppWideStrings.viewNamedCollectionsPath: (ctx) => PageWrapper(
                child: ChooseNamedCollectionsTop(),
                title: AppWideStrings.viewNamedCollectionTitle,
              ),
          AppWideStrings.preferencesScreenPath: (ctx) => PageWrapper(
            child: AppPreferences(),
            title: AppWideStrings.preferencesScreenTitle,
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
  final bool displayDrawer;

  PageWrapper(
      {@required this.child,
      this.displayDrawer = true,
      this.title,
      this.appBar,
      this.keyed = false})
      : assert(appBar != null || title != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: keyed ? UniqueKey() : null,
      drawer: displayDrawer ? DiceRollerDrawer() : null,
      body: child,
      appBar: appBar ??
          AppBar(
            title: Text(title),
          ),
    );
  }
}
