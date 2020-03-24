import 'package:d20_dice_roller/core/mult_counter.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/bloc/create_screen_bloc.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/ui/create_named_collection_screen.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/ui/create_named_collection_screen_keys.dart';
import 'package:d20_dice_roller/roller/bloc/roller_screen_bloc.dart';
import 'package:d20_dice_roller/session_history/model/session_history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preferences/preference_service.dart';

import '../../../container_widget.dart';

void main() {
  final Finder addRowButton =
      find.byKey(CreateNamedCollectionScreenKeys.addRowKey);
  final Finder multiStatusBox =
      find.byKey(CreateNamedCollectionScreenKeys.multiStatusBox);
  final Finder multiPartCreator =
      find.byKey(CreateNamedCollectionScreenKeys.multiPartCreator);
  final Finder partCreator =
      find.byKey(CreateNamedCollectionScreenKeys.partCreator);
  final Finder singleTypeRows = find.byWidgetPredicate((w) {
    if (w is MultCounter) return w.key.toString().contains('rowIncrementerKey');
    return false;
  });
  final Finder clearButton =
      find.byKey(CreateNamedCollectionScreenKeys.clearScreenKey);

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

  testWidgets('CreateNamedCollectionScreen topIncrementerTest',
      (WidgetTester tester) async {
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
      CreateNamedCollectionScreen(),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    expect(partCreator, findsOneWidget);
    expect(find.byKey(CreateNamedCollectionScreenKeys.topLevelIncrementer),
        findsOneWidget);
    expect(multiStatusBox, findsOneWidget);
    expect(singleTypeRows, findsOneWidget);
    await tester.tap(addRowButton);
    await tester.pumpAndSettle();
    await tester.tap(addRowButton);
    await tester.pumpAndSettle();
    expect(singleTypeRows, findsNWidgets(3));
    await tester.tap(clearButton);
    await tester.pumpAndSettle();
    expect(singleTypeRows, findsOneWidget);
  });

  testWidgets('CreateNamedCollectionScreen topIncrementerTest',
      (WidgetTester tester) async {
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
      CreateNamedCollectionScreen(),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    await tester.tap(multiStatusBox);
    await tester.pumpAndSettle();
    expect(multiPartCreator, findsOneWidget);
  });
}
