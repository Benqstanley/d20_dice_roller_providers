import 'package:flutter/material.dart';

enum DiceType {
  d4,
  d6,
  d8,
  d10,
  d12,
  d20,
  d100,
}

Map<DiceType, String> diceTypeStrings = {
  DiceType.d4: "d4",
  DiceType.d6: "d6",
  DiceType.d8: "d8",
  DiceType.d10: "d10",
  DiceType.d12: "d12",
  DiceType.d20: "d20",
  DiceType.d100: "d100",
};

Map<String, DiceType> diceStringTypes = {
  "d4": DiceType.d4,
  "d6": DiceType.d6,
  "d8": DiceType.d8,
  "d10": DiceType.d10,
  "d12": DiceType.d12,
  "d20": DiceType.d20,
  "d100": DiceType.d100,
};


Map<DiceType, int> diceTypeInts = {
  DiceType.d4: 4,
  DiceType.d6: 6,
  DiceType.d8: 8,
  DiceType.d10: 10,
  DiceType.d12: 12,
  DiceType.d20: 20,
  DiceType.d100: 100,
};

List<DiceType> diceTypes = [
  DiceType.d4,
  DiceType.d6,
  DiceType.d8,
  DiceType.d10,
  DiceType.d12,
  DiceType.d20,
  DiceType.d100,
];

class SingleTypeCollectionModel extends ChangeNotifier {
  int numberOfDice;
  DiceType diceType;
  int modifier;
  bool toRoll = true;
  Function onDismissed;

  SingleTypeCollectionModel();

  factory SingleTypeCollectionModel.fromJson(Map<String, dynamic> json){
    SingleTypeCollectionModel toReturn = SingleTypeCollectionModel();
    toReturn.numberOfDice = json["numberOfDice"];
    toReturn.diceType = diceStringTypes[json["diceType"]];
    toReturn .modifier = json["modifier"];
    return toReturn;
  }

  void updateWith({
    int numberOfDice,
    DiceType diceType,
    int modifier,
    bool toRoll,
  }) {
    bool noChanges = numberOfDice == null &&
        diceType == null &&
        modifier == null &&
        toRoll == null;
    this.numberOfDice = numberOfDice ?? this.numberOfDice;
    this.diceType = diceType ?? this.diceType;
    this.modifier = modifier ?? this.modifier;
    this.toRoll = toRoll ?? this.toRoll;
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

  bool determineValidity() {
    return toRoll && diceType != null && numberOfDice != null;
  }
}
