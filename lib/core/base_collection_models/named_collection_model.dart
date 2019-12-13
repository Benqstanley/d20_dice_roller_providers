import 'package:d20_dice_roller/core/base_collection_models/single_type_collection_model.dart';
import 'package:d20_dice_roller/core/dice_types.dart';
import 'package:flutter/material.dart';

class NamedCollectionModel {
  final String name;
  final List<SingleTypeCollectionModel> singleTypeCollections;

  NamedCollectionModel({
    @required this.name,
    @required this.singleTypeCollections,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> toReturn = {};
    toReturn["name"] = name;
    toReturn["singleTypeCollections"] = singleTypeCollections
        .map((collection) => {
      "numberOfDice": collection.numberOfDice,
      "diceType": diceTypeStrings[collection.diceType],
      "modifier": collection.modifier,
    })
        .toList();
    return toReturn;
  }

  factory NamedCollectionModel.fromJson(Map<String, dynamic> json) {
    List<SingleTypeCollectionModel> collections = [];
    json["singleTypeCollections"].forEach((item) {
      Map<String, dynamic> map = item as Map<String, dynamic>;
      collections.add(SingleTypeCollectionModel.fromJson(map));
    });
    print(collections);
    return NamedCollectionModel(
        name: json["name"],
        singleTypeCollections:collections);
  }

  @override
  String toString() {
    StringBuffer toReturn = StringBuffer(name);
    toReturn.write(": ");
    singleTypeCollections.forEach((element) => toReturn.write(element.toString()));
    return toReturn.toString();
  }
}
