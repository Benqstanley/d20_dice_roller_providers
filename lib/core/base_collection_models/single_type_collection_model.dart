import 'package:d20_dice_roller/core/dice_types.dart';
import 'package:flutter/material.dart';

class SingleTypeCollectionModel extends ChangeNotifier {
  int numberOfDice;
  DiceType diceType;
  int modifier;
  int multiplier = 1;

  //for managing a checkbox if one is needed on the associated RowType
  bool checkBox = true;

  void incrementMultiplier() {
    multiplier++;
    notifyListeners();
  }

  void decrementMultiplier() {
    if (multiplier > 1) {
      multiplier--;
    } else {
      multiplier = 1;
    }
    notifyListeners();
  }

  void changeCheckbox(bool newValue) {
    checkBox = newValue;
    notifyListeners();
  }

  SingleTypeCollectionModel();

  factory SingleTypeCollectionModel.fromJson(Map<String, dynamic> json) {
    SingleTypeCollectionModel toReturn = SingleTypeCollectionModel();
    toReturn.numberOfDice = json["numberOfDice"];
    toReturn.diceType = diceStringTypes[json["diceType"]];
    toReturn.modifier = json["modifier"];
    if (json.containsKey("multiplier")) {
      toReturn.multiplier = json["multiplier"];
    }
    return toReturn;
  }

  void updateWith({
    int numberOfDice,
    DiceType diceType,
    int modifier,
    int multiplier,
  }) {
    bool noChanges = numberOfDice == null &&
        diceType == null &&
        modifier == null &&
        multiplier == null;
    this.numberOfDice = numberOfDice ?? this.numberOfDice;
    this.diceType = diceType ?? this.diceType;
    this.modifier = modifier ?? this.modifier;
    this.multiplier = multiplier ?? this.multiplier;
    if (!noChanges) {
      notifyListeners();
    }
  }

  String modifierString() {
    return modifier != null && modifier != 0 ? " + $modifier" : "";
  }

  @override
  String toString() {
    String baseString =
        "$numberOfDice x ${diceTypeStrings[diceType]}" + modifierString();
    if (multiplier != 1) {
      baseString = "($baseString) x $multiplier";
    }
    return baseString;
  }

  String toStringForRoller() {
    String baseString =
        "$numberOfDice x ${diceTypeStrings[diceType]}" + modifierString();
    return baseString;
  }

  //To Be Overridden by any extending class.

  bool determineRollability() {
    return checkBox &&
        numberOfDice != null &&
        numberOfDice > 0 &&
        diceType != null;
  }
}
