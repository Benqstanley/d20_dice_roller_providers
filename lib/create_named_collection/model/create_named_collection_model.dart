import 'package:d20_dice_roller/roller/model/single_type_collection_model.dart';
import 'package:flutter/material.dart';

class NamedCollectionModel extends ChangeNotifier{
  bool isMultiPart = false;
  TextEditingController nameEditingController = TextEditingController();
  List<NamedMultiTypeCollection> parts = [];

  void changeMultiPartStatus(bool newValue){
    isMultiPart = newValue;
    notifyListeners();
  }

}

class NamedMultiTypeCollection{
  List<SingleTypeCollectionModel> singleTypeCollections = [];

}