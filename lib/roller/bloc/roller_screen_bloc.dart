import 'package:d20_dice_roller/core/base_collection_models/single_type_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_rows/named_multi_collection_row.dart';
import 'package:d20_dice_roller/core/base_collection_rows/single_type_collection_row.dart';
import 'package:d20_dice_roller/roller/ui/roller_modal_sheet.dart';
import 'package:d20_dice_roller/session_history/model/session_history_model.dart';
import 'package:d20_dice_roller/utility/utility_class.dart';
import 'package:flutter/material.dart';

class RollerScreenBloc extends ChangeNotifier {
  bool showExpanded = true;
  List<SingleTypeCollectionRow> singleTypeCollections = [];
  List<NamedMultiCollectionRow> namedMultiCollections = [];

  RollerScreenBloc() {
    addSingleTypeCollectionRow();
  }

  void dismissSingleTypeCollectionRow(SingleTypeCollectionRow toBeDismissed) {
    singleTypeCollections.remove(toBeDismissed);
    if (singleTypeCollections.isEmpty) {
      addSingleTypeCollectionRow();
    } else {
      notifyListeners();
    }
  }

  void dismissNamedMultiCollectionRollerRow(
      NamedMultiCollectionRow toBeDismissed) {
    namedMultiCollections.remove(toBeDismissed);
    notifyListeners();
  }

  void addSingleTypeCollectionRow() {
    singleTypeCollections.add(SingleTypeCollectionRow.forRoller(
      SingleTypeCollectionModel(),
      dismissSingleTypeCollectionRow,
    ));
    notifyListeners();
  }

  void resetScreen() {
    singleTypeCollections.clear();
    addSingleTypeCollectionRow();
  }

  void rollCollections(
      BuildContext context, SessionHistoryModel sessionHistoryModel) {
    List<Map<String, dynamic>> results = [];
    for (SingleTypeCollectionRow row in singleTypeCollections) {
      if (row.collectionModel.determineRollability()) {
        Map result = Utility.rollSingleTypeCollection(row.collectionModel);
        results.add(result);
      }
    }
    if (results.isNotEmpty) {
      sessionHistoryModel.addSessionResult(results);
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return RollerModalSheet(results);
          });
    }
  }
}
