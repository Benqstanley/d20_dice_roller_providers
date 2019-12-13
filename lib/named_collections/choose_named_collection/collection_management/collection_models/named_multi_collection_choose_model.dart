import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_model.dart';
import 'package:flutter/material.dart';

class NamedMultiCollectionChooseModel extends NamedMultiCollectionModel {
  final Key key = UniqueKey();

  factory NamedMultiCollectionChooseModel.fromBaseModel(
      NamedMultiCollectionModel model) {
    return NamedMultiCollectionChooseModel(model.name, model.parts);
  }

  NamedMultiCollectionChooseModel(
      String name, List<NamedCollectionModel> parts)
      : super(name: name, parts: parts);

  void increment() {
    counterState++;
    notifyListeners();
  }

  void decrement() {
    if (counterState > 1) {
      counterState--;
    }
    if (counterState == 1) {
      checkBox = false;
    }
    notifyListeners();
  }

  void resetNum() {
    counterState = 1;
    checkBox = false;
    notifyListeners();
  }

  void changeCheckbox(bool value) {
    checkBox = value;
    notifyListeners();
  }

}
