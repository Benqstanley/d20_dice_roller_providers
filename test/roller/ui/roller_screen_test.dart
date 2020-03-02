import 'package:d20_dice_roller/core/base_collection_rows/single_type_collection_row.dart';
import 'package:d20_dice_roller/roller/bloc/roller_screen_bloc.dart';
import 'package:d20_dice_roller/roller/ui/roller_screen.dart';
import 'package:d20_dice_roller/roller/ui/roller_screen_keys.dart';
import 'package:d20_dice_roller/session_history/model/session_history_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../container_widget.dart';

void main() {
  Future<int> addRow(
    WidgetTester tester,
    int currentCount,
    Finder buttonFinder,
  ) async {
    await tester.tap(buttonFinder);
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
    var addRowButton = find.byKey(RollerScreenKeys.addRowButtonKey);
    int currentCount = 1;
    currentCount = await addRow(tester, currentCount, addRowButton);
    expect(singleTypeCollectionRowFinder, findsNWidgets(currentCount));
    currentCount = await addRow(tester, currentCount, addRowButton);
    expect(singleTypeCollectionRowFinder, findsNWidgets(currentCount));
    currentCount = await addRow(tester, currentCount, addRowButton);
    expect(singleTypeCollectionRowFinder, findsNWidgets(currentCount));
    currentCount = await addRow(tester, currentCount, addRowButton);
    expect(singleTypeCollectionRowFinder, findsNWidgets(currentCount));
    currentCount = await addRow(tester, currentCount, addRowButton);
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);
    currentCount = await addRow(tester, currentCount, addRowButton);
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);
    currentCount = await addRow(tester, currentCount, addRowButton);
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);
    currentCount = await addRow(tester, currentCount, addRowButton);
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);
    currentCount = await addRow(tester, currentCount, addRowButton);
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);
    currentCount = await addRow(tester, currentCount, addRowButton);
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);
    currentCount = await addRow(tester, currentCount, addRowButton);
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);
    currentCount = await addRow(tester, currentCount, addRowButton);
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);
    currentCount = await addRow(tester, currentCount, addRowButton);
    expect(rollerScreenBloc.singleTypeModels.length, currentCount);


  });
}
