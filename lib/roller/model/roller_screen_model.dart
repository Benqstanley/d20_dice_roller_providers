import 'package:d20_dice_roller/core/base_collection_rows/single_type_collection_base_row.dart';
import 'package:d20_dice_roller/named_collections/choose_named_collection/model/view_named_collections_row_cn.dart';
import 'package:d20_dice_roller/roller/ui/named_multi_collection_roller_row.dart';
import 'package:d20_dice_roller/roller/ui/roller_modal_sheet.dart';
import 'package:d20_dice_roller/session_history/model/session_history_model.dart';
import 'package:d20_dice_roller/utility/utility_class.dart';
import 'package:flutter/material.dart';

class RollerScreenModel extends ChangeNotifier {
  bool showExpanded = true;
  List<SingleTypeCollectionBaseRow> singleTypeCollections = [];
  List<NamedMultiCollectionRollerRow> namedMultiCollections = [];

  RollerScreenModel() {
    addSingleTypeCollectionRow();
  }

  void dismissSingleTypeCollectionRow(SingleTypeCollectionBaseRow toBeDismissed) {
    singleTypeCollections.remove(toBeDismissed);
    if (singleTypeCollections.isEmpty) {
      addSingleTypeCollectionRow();
    } else {
      notifyListeners();
    }
  }

  void dismissNamedMultiCollectionRollerRow(
      ViewNamedCollectionsRowCN toBeDismissed) {
    namedMultiCollections.removeWhere((row) {
      return row.changeNotifier == toBeDismissed;
    });
    notifyListeners();
  }

  void addSingleTypeCollectionRow() {
    singleTypeCollections.add(SingleTypeCollectionBaseRow(
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
    for (SingleTypeCollectionBaseRow row in singleTypeCollections) {
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
