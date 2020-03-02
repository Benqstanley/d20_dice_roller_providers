import 'package:d20_dice_roller/core/base_collection_models/collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/single_type_collection_model.dart';
import 'package:d20_dice_roller/roller/ui/roller_modal_sheet.dart';
import 'package:d20_dice_roller/session_history/model/session_history_model.dart';
import 'package:d20_dice_roller/utility/utility_class.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';

class RollerScreenBloc extends ChangeNotifier {
  bool showExpanded = true;
  List<SingleTypeCollectionModel> singleTypeModels = [];
  List<CollectionModel> collectionModels = [];

  RollerScreenBloc() {
    addSingleTypeCollectionModel();
  }

  void dismissSingleTypeCollectionModel(
      SingleTypeCollectionModel toBeDismissed) {
    singleTypeModels.remove(toBeDismissed);
    if (singleTypeModels.isEmpty && collectionModels.isEmpty) {
      addSingleTypeCollectionModel();
    } else {
      notifyListeners();
    }
  }

  void dismissCollectionModel(CollectionModel toBeDismissed) {
    collectionModels.remove(toBeDismissed);
    if(collectionModels.isEmpty && singleTypeModels.isEmpty){
      addSingleTypeCollectionModel();
    }
    notifyListeners();
  }

  void addSingleTypeCollectionModel() {
    singleTypeModels.add(SingleTypeCollectionModel());
    notifyListeners();
  }

  void resetScreen() {
    if (singleTypeModels.isNotEmpty && collectionModels.isNotEmpty) {
      singleTypeModels.clear();
      notifyListeners();
    } else if (singleTypeModels.isNotEmpty && collectionModels.isEmpty) {
      singleTypeModels.clear();
      addSingleTypeCollectionModel();
    } else {
      collectionModels.clear();
      addSingleTypeCollectionModel();
      return;
    }
  }

  void rollCollections(
      BuildContext context, SessionHistoryModel sessionHistoryModel) {
    showExpanded = PrefService.getBool('roll_detail');
    List<Map<String, dynamic>> results = [];
    for (SingleTypeCollectionModel collectionModel in singleTypeModels) {
      if (collectionModel.determineRollability()) {
        Map result = Utility.rollSingleTypeCollection(collectionModel);
        results.add(result);
      }
    }
    for (CollectionModel model in collectionModels) {
      if (model.checkBox) {
        List<Map<String, dynamic>> result =
            Utility.rollCollectionWithMultiplier(model);
        results.addAll(result);
      }
    }
    if (results.isNotEmpty) {
      sessionHistoryModel.addSessionResult(results);
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return FractionallySizedBox(
              child: RollerModalSheet(
                results,
                showExpanded,
              ),
              heightFactor: .8,
            );
          });
    }
  }
}
