import 'package:d20_dice_roller/roller/ui/single_type_collection_row.dart';
import 'package:d20_dice_roller/utility/utility_class.dart';
import 'package:flutter/material.dart';

class RollerScreenModel extends ChangeNotifier {
  List<SingleTypeCollectionRow> singleTypeCollections = [];

  RollerScreenModel() {
    addSingleTypeCollectionRow();
  }

  void dismissSingleTypeCollectionRow(SingleTypeCollectionRow toBeDismissed) {
    singleTypeCollections.remove(toBeDismissed);
    if(singleTypeCollections.isEmpty){
      addSingleTypeCollectionRow();
    }else{
      notifyListeners();
    }
  }

  void addSingleTypeCollectionRow() {
    singleTypeCollections.add(SingleTypeCollectionRow(
      dismissSingleTypeCollectionRow,
    ));
    notifyListeners();
  }

  void resetScreen() {
    singleTypeCollections.clear();
    addSingleTypeCollectionRow();
  }

  void rollCollections(){
    for(SingleTypeCollectionRow row in singleTypeCollections){
      if(row.collectionModel.determineValidity()){
       Map result = Utility.rollSingleTypeCollection(row.collectionModel);
       print(result['rollValue']);
       print(result['expandedResult']);
      }
    }
  }
}
