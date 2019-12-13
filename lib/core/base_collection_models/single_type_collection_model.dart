import 'package:d20_dice_roller/core/dice_types.dart';
import 'package:flutter/material.dart';

class SingleTypeCollectionModel extends ChangeNotifier {
  String name;
  int numberOfDice;
  DiceType diceType;
  int modifier;

  //for managing a checkbox if one is needed on the associated RowType
  bool checkBox = false;

  void changeCheckbox(bool newValue){
    checkBox = newValue;
    notifyListeners();
  }

  SingleTypeCollectionModel();

  factory SingleTypeCollectionModel.fromJson(Map<String, dynamic> json){
    SingleTypeCollectionModel toReturn = SingleTypeCollectionModel();
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
    return name != null && numberOfDice > 0 && diceType != null;
  }
}
