import 'package:d20_dice_roller/named_collections/create_named_collection/model/named_multi_type_collection_model.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/ui/multi_type_row.dart';
import 'package:d20_dice_roller/roller/ui/single_type_collection_row.dart';
import 'package:flutter/material.dart';

class NamedCollectionModel extends ChangeNotifier {
  bool isMultiPart = false;
  final TextEditingController nameEditingController = TextEditingController();
  TextEditingController partEditingController;
  List<MultiTypeRow> parts = [];
  NamedMultiTypeCollectionModel currentPart;

  TextEditingController nameController(bool isPartOfBigger){
    if(isPartOfBigger){
      return partEditingController;
    }else{
      return nameEditingController;
    }
  }

  NamedCollectionModel() {
    currentPart = NamedMultiTypeCollectionModel(dismissSingleTypeCollectionRow);
  }

  void moveCurrentToList() {
    parts.add(MultiTypeRow(currentPart));
    currentPart = NamedMultiTypeCollectionModel(dismissSingleTypeCollectionRow);
    notifyListeners();
  }

  void changeMultiPartStatus(bool newValue) {
    isMultiPart = newValue;
    notifyListeners();
  }

  void resetCurrentList() {
    currentPart.resetList();
    notifyListeners();
  }

  void resetPartsList(){
    parts.clear();
    notifyListeners();
  }

  void addSingleTypeCollectionRowForCurrentPart() {
    currentPart.addSingleTypeCollectionRow();
    notifyListeners();
  }

  void dismissSingleTypeCollectionRow(SingleTypeCollectionRow toBeDismissed,
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

  void updateScreen(){
    notifyListeners();
  }
}
