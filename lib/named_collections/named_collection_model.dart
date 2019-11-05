import 'dart:convert';

import 'package:d20_dice_roller/named_collections/create_named_collection/model/create_named_collection_model.dart';
import 'package:d20_dice_roller/roller/model/single_type_collection_model.dart';
import 'package:flutter/material.dart';

class NamedMultiCollectionModel {
  final String name;
  final List<NamedCollectionModel> parts;

  NamedMultiCollectionModel({
    @required this.name,
    @required this.parts,
  });

  factory NamedMultiCollectionModel.fromCreate(
      CreateNamedCollectionModel model){
    return NamedMultiCollectionModel(name: model.nameEditingController.text,
      parts: model.parts.map((multiTypeRow) {
        return NamedCollectionModel(name: multiTypeRow.model.name,
          singleTypeCollections: multiTypeRow.model.singleTypeCollections.map((
              item) => item.collectionModel).toList(),);
      }).toList(),
    );
  }

  String toJsonString() {
    Map<String, dynamic> canEncode = {};
    canEncode["name"] = name;
    canEncode["parts"] = parts.map((part) => part.toMap()).toList();
    return json.encode(canEncode);
  }


}

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
    toReturn["singleTypeCollections"] =
        singleTypeCollections.map((collection) => {
          "numberOfDice":collection.numberOfDice,
          "diceType":diceTypeStrings[collection.diceType],
          "modifier": collection.modifier,
        }).toList();
    return toReturn;
  }
}
