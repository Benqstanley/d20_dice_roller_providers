import 'dart:convert';

import 'package:d20_dice_roller/core/single_type_collection_model.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/model/create_named_collection_model.dart';
import 'package:flutter/material.dart';

class NamedMultiCollectionModel {
  final String path;
  final String name;
  final List<NamedCollectionModel> parts;

  NamedMultiCollectionModel({
    this.path,
    @required this.name,
    @required this.parts,
  });

  factory NamedMultiCollectionModel.fromCreate(
      CreateNamedCollectionModel model) {
    return NamedMultiCollectionModel(
      name: model.nameEditingController.text,
      parts: model.parts.map((multiTypeRow) {
        return NamedCollectionModel(
          name: multiTypeRow.model.name,
          singleTypeCollections: multiTypeRow.model.singleTypeCollections
              .map((item) => item.collectionModel)
              .toList(),
        );
      }).toList(),
    );
  }

  factory NamedMultiCollectionModel.fromJson(Map<String, dynamic> json, String path) {
    List<NamedCollectionModel> partsToReturn = [];
    partsToReturn = (json["parts"] as List<Map<String, dynamic>>)
        .map((part) => NamedCollectionModel.fromJson(part))
        .toList();
    NamedMultiCollectionModel model = NamedMultiCollectionModel(
        name: json['name'], parts: partsToReturn, path: path);
    return model;
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
    return NamedCollectionModel(
        name: json["name"],
        singleTypeCollections:
            (json["singleTypeCollections"] as List<Map<String, dynamic>>)
                .map((json) => SingleTypeCollectionModel.fromJson(json)));
  }
}
