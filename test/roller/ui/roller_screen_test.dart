import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_rows/collection_row.dart';
import 'package:d20_dice_roller/core/base_collection_rows/collection_row_keys.dart';
import 'package:d20_dice_roller/core/base_collection_rows/single_type_collection_row.dart';
import 'package:d20_dice_roller/core/dice_types.dart';
import 'package:d20_dice_roller/roller/bloc/roller_screen_bloc.dart';
import 'package:d20_dice_roller/roller/ui/roll_result.dart';
import 'package:d20_dice_roller/roller/ui/roller_modal_sheet.dart';
import 'package:d20_dice_roller/roller/ui/roller_screen.dart';
import 'package:d20_dice_roller/roller/ui/roller_screen_keys.dart';
import 'package:d20_dice_roller/session_history/model/session_history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preferences/preference_service.dart';

import '../../container_widget.dart';
import '../../test_collections.dart';

void main() {
  final Finder addRowButton = find.byKey(RollerScreenKeys.addRowButtonKey);
  final Finder rollButton = find.byKey(RollerScreenKeys.rollButtonKey);
  final Finder resetButton = find.byKey(RollerScreenKeys.clearButtonKey);

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      print(methodCall);
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{}; // set initial values here if desired
      }
      return null;
    });
    await PrefService.init(prefix: 'pref_');
    PrefService.setDefaultValues({'roll_detail': true, 'app_theme': 0});
  });

  Future<int> addRow(
    WidgetTester tester,
    int currentCount,
  ) async {
    await tester.tap(addRowButton);
    await tester.pumpAndSettle();
    currentCount = currentCount + 1;
    return currentCount;
  }

  testWidgets('Add Row Button test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    var rollerScreenBloc = RollerScreenBloc();
    var sessionHistory = SessionHistoryModel();
    var widget = ContainerWidget(
      [rollerScreenBloc, sessionHistory],
      RollerScreen(),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    var singleTypeCollectionRowFinder =
        find.byType(SingleTypeCollectionRow, skipOffstage: false);
    expect(singleTypeCollectionRowFinder, findsOneWidget);
    int currentCount = 1;
    currentCount = await addRow(tester, currentCount);
    expect(singleTypeCollectionRowFinder, findsNWidgets(currentCount));
    currentCount = await addRow(tester, currentCount);
    expect(singleTypeCollectionRowFinder, findsNWidgets(currentCount));
    currentCount = await addRow(tester, currentCount);
    expect(singleTypeCollectionRowFinder, findsNWidgets(currentCount));
    currentCount = await addRow(tester, currentCount);
    expect(singleTypeCollectionRowFinder, findsNWidgets(currentCount));
    currentCount = await addRow(tester, currentCount);
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);
    currentCount = await addRow(tester, currentCount);
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);
    currentCount = await addRow(tester, currentCount);
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);
    currentCount = await addRow(tester, currentCount);
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);
    currentCount = await addRow(tester, currentCount);
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);
    currentCount = await addRow(tester, currentCount);
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);
    currentCount = await addRow(tester, currentCount);
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);
    currentCount = await addRow(tester, currentCount);
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);
    currentCount = await addRow(tester, currentCount);
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);
    currentCount = 1;
    await tester.tap(resetButton);
    await tester.pumpAndSettle();
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);
  });

  testWidgets('Roll Single Collection Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    var rollerScreenBloc = RollerScreenBloc();
    var sessionHistory = SessionHistoryModel();
    var widget = ContainerWidget(
      [rollerScreenBloc, sessionHistory],
      RollerScreen(),
    );
    var numberOfDice = find.byKey(CollectionRowKeys.numberOfDiceTextField);
    var typeOfDice = find.byKey(CollectionRowKeys.diceTypeDropDown);
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    var singleTypeCollectionRowFinder =
        find.byType(SingleTypeCollectionRow, skipOffstage: false);
    expect(singleTypeCollectionRowFinder, findsOneWidget);
    await tester.enterText(numberOfDice, "5");
    await tester.pumpAndSettle();
    await tester.tap(typeOfDice);
    var dropDownMenuItem = find.byWidgetPredicate((w) {
      return w is DropdownMenuItem<DiceType>;
    });
    expect(dropDownMenuItem, findsNWidgets(7));
    await tester.pumpAndSettle();
    await tester.tap(dropDownMenuItem.first);
    await tester.pumpAndSettle();
    await tester.tap(rollButton);
    await tester.pumpAndSettle();
    expect(find.byType(RollerModalSheet), findsOneWidget);
    expect(find.byType(RollResult), findsNWidgets(1));
    await tester.tap(find.text("RollerScreen", skipOffstage: false));
    await tester.pumpAndSettle();
    expect(find.byType(RollerModalSheet), findsNothing);
  });

  testWidgets('Roll Multi Collections Test', (WidgetTester tester) async {
    var rollerScreenBloc = RollerScreenBloc();
    rollerScreenBloc.collectionModels.add(TestCollections.testNamedCollection);
    rollerScreenBloc.collectionModels
        .add(TestCollections.testNamedMultiCollection);
    var sessionHistory = SessionHistoryModel();
    var widget = ContainerWidget(
      [rollerScreenBloc, sessionHistory],
      RollerScreen(),
    );
    var namedCollectionRowFinder = find.byWidgetPredicate((w) {
      return w is CollectionRow<NamedCollectionModel>;
    });
    var namedMultiCollectionRowFinder = find.byWidgetPredicate((w) {
      return w is CollectionRow<NamedMultiCollectionModel>;
    });
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    expect(namedCollectionRowFinder, findsOneWidget);
    expect(namedMultiCollectionRowFinder, findsOneWidget);
    await tester.tap(rollButton);
    await tester.pumpAndSettle();
    expect(find.byType(RollerModalSheet), findsOneWidget);
    var rollerResultFinder = find.byWidgetPredicate((w) {
      return w is RollResult;
    });
    expect(rollerResultFinder, findsNWidgets(13));
    await tester.tap(find.text("RollerScreen", skipOffstage: false));
    await tester.pumpAndSettle();
    expect(find.byType(RollerModalSheet), findsNothing);
  });

  testWidgets('Roll Multi Not Detailed', (WidgetTester tester) async {
    await PrefService.setBool('roll_detail', false);
    var rollerScreenBloc = RollerScreenBloc();
    rollerScreenBloc.collectionModels.add(TestCollections.testNamedCollection);
    rollerScreenBloc.collectionModels
        .add(TestCollections.testNamedMultiCollection);
    var sessionHistory = SessionHistoryModel();
    var widget = ContainerWidget(
      [rollerScreenBloc, sessionHistory],
      RollerScreen(),
    );
    var namedCollectionRowFinder = find.byWidgetPredicate((w) {
      return w is CollectionRow<NamedCollectionModel>;
    });
    var namedMultiCollectionRowFinder = find.byWidgetPredicate((w) {
      return w is CollectionRow<NamedMultiCollectionModel>;
    });
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    expect(namedCollectionRowFinder, findsOneWidget);
    expect(namedMultiCollectionRowFinder, findsOneWidget);
    await tester.tap(rollButton);
    await tester.pumpAndSettle();
    expect(find.byType(RollerModalSheet), findsOneWidget);
    var rollerResultFinder = find.byWidgetPredicate((w) {
      return w is RollResult;
    });
    expect(rollerResultFinder, findsNWidgets(22));
    var first = sessionHistory.sessionResults.first;

    var namedResults = first['namedResults'];
    var firstNamed = namedResults.first;
    var firstSingle = firstNamed['singleResults'].first;
    var firstExpanded = firstSingle['expandedResult'];
    var firstShort = firstSingle['shortResult'];
    expect(find.text(firstExpanded.toString()), findsNothing);
    expect(find.text(firstShort.toString()), findsWidgets);
  });
}
