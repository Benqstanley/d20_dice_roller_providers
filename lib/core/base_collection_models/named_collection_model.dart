import 'dart:convert';

import 'package:d20_dice_roller/core/base_collection_models/collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/single_type_collection_model.dart';
import 'package:d20_dice_roller/core/dice_types.dart';
import 'package:flutter/cupertino.dart';

class NamedCollectionModel extends CollectionModel {
  bool checkBox;

  NamedCollectionModel({
    String path,
    @required String name,
    @required List<SingleTypeCollectionModel> singleTypeCollections,
    int multiplier = 1,
  }) : super(
          name,
          path: path,
          singleTypeCollections: singleTypeCollections,
          multiplier: multiplier,
        );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> toReturn = {};
    toReturn["name"] = name;
    toReturn["multiplier"] = multiplier;
    toReturn["singleTypeCollections"] = singleTypeCollections
        .map((collection) => {
              "numberOfDice": collection.numberOfDice,
              "diceType": diceTypeStrings[collection.diceType],
              "modifier": collection.modifier,
              "multiplier": collection.multiplier,
            })
        .toList();
    return toReturn;
  }

  factory NamedCollectionModel.fromJson(Map<String, dynamic> json,
      {String path}) {
    List<SingleTypeCollectionModel> collections = [];
    json["singleTypeCollections"].forEach((item) {
      Map<String, dynamic> map = item as Map<String, dynamic>;
      collections.add(SingleTypeCollectionModel.fromJson(map));
    });
    int multiplier = 1;
    if (json.containsKey("multiplier")) {
      multiplier = json["multiplier"];
    }
    return NamedCollectionModel(
      path: path,
      name: json["name"],
      singleTypeCollections: collections,
      multiplier: multiplier,
    );
  }

  @override
  String toString() {
    bool hasMult = multiplier != 1;
    String nameString = name;
    if (hasMult) {
      nameString = nameString + " x $multiplier";
    }
    StringBuffer toReturn = StringBuffer(nameString);
    toReturn.write(": ");

    singleTypeCollections.forEach((element) {
      toReturn.write(element.toString());
      toReturn.write(", ");
    });
    String returnString = toReturn.toString().substring(0, toReturn.length - 2);
    return returnString;
  }

  String toJsonString() {
    return json.encode(toMap());
  }

  @override
  NamedCollectionModel copy() {
    return NamedCollectionModel(
        name: name,
        path: path,
        singleTypeCollections: singleTypeCollections,
        multiplier: multiplier);
  }
}
