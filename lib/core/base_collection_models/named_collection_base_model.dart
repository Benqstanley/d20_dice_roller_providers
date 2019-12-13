import 'package:d20_dice_roller/core/base_collection_models/single_type_collection_base_model.dart';
import 'package:d20_dice_roller/core/single_type_collection_model.dart';
import 'package:flutter/material.dart';

class NamedCollectionBaseModel {
  final String name;
  final List<SingleTypeCollectionBaseModel> singleTypeCollections;

  NamedCollectionBaseModel({
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

  factory NamedCollectionBaseModel.fromJson(Map<String, dynamic> json) {
    List<SingleTypeCollectionBaseModel> collections = [];
    json["singleTypeCollections"].forEach((item) {
      Map<String, dynamic> map = item as Map<String, dynamic>;
      collections.add(SingleTypeCollectionBaseModel.fromJson(map));
    });
    print(collections);
    return NamedCollectionBaseModel(
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
