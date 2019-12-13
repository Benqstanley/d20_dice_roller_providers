import 'package:d20_dice_roller/roller/collection_management/collection_models/single_type_collection_roller_model.dart';
import 'package:d20_dice_roller/roller/collection_management/collection_rows/single_type_collection_roller_row.dart';
import 'package:d20_dice_roller/roller/ui/named_multi_collection_roller_row.dart';
import 'package:d20_dice_roller/roller/ui/roller_modal_sheet.dart';
import 'package:d20_dice_roller/session_history/model/session_history_model.dart';
import 'package:d20_dice_roller/utility/utility_class.dart';
import 'package:flutter/material.dart';

class RollerScreenModel extends ChangeNotifier {
  bool showExpanded = true;
  List<SingleTypeCollectionRollerRow> singleTypeCollections = [];
  List<NamedMultiCollectionRollerRow> namedMultiCollections = [];

  RollerScreenModel() {
    addSingleTypeCollectionRow();
  }

  void dismissSingleTypeCollectionRow(SingleTypeCollectionRollerRow toBeDismissed) {
    singleTypeCollections.remove(toBeDismissed);
    if (singleTypeCollections.isEmpty) {
      addSingleTypeCollectionRow();
    } else {
      notifyListeners();
    }
  }

  void dismissNamedMultiCollectionRollerRow(
      NamedMultiCollectionRollerRow toBeDismissed) {
    namedMultiCollections.remove(toBeDismissed);
    notifyListeners();
  }

  void addSingleTypeCollectionRow() {
    singleTypeCollections.add(SingleTypeCollectionRollerRow(
      dismissSingleTypeCollectionRow,
      SingleTypeCollectionRollerModel()
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
    for (SingleTypeCollectionRollerRow row in singleTypeCollections) {
      if (row.collectionModel.determineValidity()) {
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
