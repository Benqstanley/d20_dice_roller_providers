import 'package:d20_dice_roller/core/base_collection_rows/single_type_collection_row.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/bloc/create_screen_bloc.dart';
import 'package:d20_dice_roller/roller/bloc/roller_screen_bloc.dart';
import 'package:d20_dice_roller/roller/ui/roller_screen.dart';
import 'package:d20_dice_roller/roller/ui/roller_screen_keys.dart';
import 'package:d20_dice_roller/session_history/model/session_history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preferences/preference_service.dart';

import '../../../container_widget.dart';

void main() {
  final Finder addRowButton = find.byKey(RollerScreenKeys.addRowButtonKey);
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
    var createScreenBloc = CreateScreenBloc();
    var widget = ContainerWidget(
      [
        rollerScreenBloc,
        sessionHistory,
        createScreenBloc,
      ],
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
}
