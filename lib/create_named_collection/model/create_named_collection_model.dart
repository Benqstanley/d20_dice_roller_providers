import 'package:d20_dice_roller/roller/ui/single_type_collection_row.dart';
import 'package:flutter/material.dart';

class NamedCollectionModel extends ChangeNotifier {
  bool isMultiPart = false;
  TextEditingController nameEditingController = TextEditingController();
  List<NamedMultiTypeCollectionModel> parts = [];
  NamedMultiTypeCollectionModel currentPart;

  NamedCollectionModel(){
    currentPart = NamedMultiTypeCollectionModel(
        dismissSingleTypeCollectionRow);
  }


  void changeMultiPartStatus(bool newValue) {
    isMultiPart = newValue;
    notifyListeners();
  }

  void resetCurrentList() {
    currentPart.resetList();
    notifyListeners();
  }

  void addSingleTypeCollectionRowForCurrentPart() {
    currentPart.addSingleTypeCollectionRow();
    notifyListeners();
  }

  void dismissSingleTypeCollectionRow(
      SingleTypeCollectionRow toBeDismissed,
      {NamedMultiTypeCollectionModel model}) {
    model = model ?? currentPart;
    model.singleTypeCollections.remove(toBeDismissed);
    if (model.singleTypeCollections.isEmpty) {
      model.addSingleTypeCollectionRow();
      notifyListeners();
    } else {
      notifyListeners();
    }
  }
}

class NamedMultiTypeCollectionModel {
  String name;
  List<SingleTypeCollectionRow> singleTypeCollections = [];
  var dismissRow;

  NamedMultiTypeCollectionModel(Function dismiss) {
    dismissRow = (SingleTypeCollectionRow toBeDismissed) =>
        dismiss(toBeDismissed, model: this);
    addSingleTypeCollectionRow();
  }

  void resetList() {
    singleTypeCollections = [];
  }

  void addSingleTypeCollectionRow() {
    singleTypeCollections.add(SingleTypeCollectionRow(
      dismissRow,
      needsCheckbox: false,
    ));
  }
}
