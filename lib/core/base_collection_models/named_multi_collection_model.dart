import 'dart:convert';

import 'package:d20_dice_roller/core/base_collection_models/collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:flutter/material.dart';

class NamedMultiCollectionModel extends CollectionModel {
  NamedMultiCollectionModel({
    String path,
    @required String name,
    @required List<NamedCollectionModel> parts,
    int multiplier = 1,
  }) : super(
          name,
          path: path,
          parts: parts,
          multiplier: multiplier,
        );

  factory NamedMultiCollectionModel.fromJson(
      Map<String, dynamic> json, String path) {
    int multiplier = 1;
    List<NamedCollectionModel> partsToReturn = [];
    json["parts"].forEach((part) {
      partsToReturn.add(NamedCollectionModel.fromJson(part));
    });
    if (json.containsKey("multiplier")) {
      multiplier = json["multiplier"];
    }
    NamedMultiCollectionModel model = NamedMultiCollectionModel(
      name: json['name'],
      parts: partsToReturn,
      path: path,
      multiplier: multiplier,
    );
    return model;
  }

  String toJsonString() {
    Map<String, dynamic> canEncode = {};
    canEncode["name"] = name;
    canEncode["parts"] = parts.map((part) => part.toMap()).toList();
    canEncode["multiplier"] = multiplier;
    return json.encode(canEncode);
  }

  @override
  NamedMultiCollectionModel copy() {
    return NamedMultiCollectionModel(
      name: name,
      path: path,
      parts: parts,
      multiplier: multiplier,
    );
  }
}
