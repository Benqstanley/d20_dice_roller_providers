import 'package:d20_dice_roller/core/single_type_collection_model.dart';
import 'package:flutter/material.dart';

class SingleTypeCollectionBaseModel extends ChangeNotifier {
  String name;
  int numberOfDice;
  DiceType diceType;
  int modifier;
  bool checkBox;

  SingleTypeCollectionBaseModel();

  factory SingleTypeCollectionBaseModel.fromJson(Map<String, dynamic> json){
    SingleTypeCollectionBaseModel toReturn = SingleTypeCollectionBaseModel();
    toReturn.numberOfDice = json["numberOfDice"];
    toReturn.diceType = diceStringTypes[json["diceType"]];
    toReturn.modifier = json["modifier"];
    return toReturn;
  }

  void updateWith({
    int numberOfDice,
    DiceType diceType,
    int modifier,
  }) {
    bool noChanges = numberOfDice == null &&
        diceType == null &&
        modifier == null;
    this.numberOfDice = numberOfDice ?? this.numberOfDice;
    this.diceType = diceType ?? this.diceType;
    this.modifier = modifier ?? this.modifier;
    if (!noChanges) {
      notifyListeners();
    }
  }

  String modifierString() {
    return modifier != null && modifier != 0 ? " + $modifier" : "";
  }

  @override
  String toString() {
    return "$numberOfDice x ${diceTypeStrings[diceType]}" + modifierString() +
        ": ";
  }

  //To Be Overridden by any extending class.

  bool determineValidity(){
    return false;
  }
}
