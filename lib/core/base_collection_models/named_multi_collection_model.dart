import 'dart:convert';

import 'package:d20_dice_roller/core/base_collection_models/collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:flutter/material.dart';

class NamedMultiCollectionModel extends CollectionModel {
  NamedMultiCollectionModel({
    String path,
    @required String name,
    @required List<NamedCollectionModel> parts,
  }) : super(
          name,
          path: path,
          parts: parts,
        );

  factory NamedMultiCollectionModel.fromJson(
      Map<String, dynamic> json, String path) {
    List<NamedCollectionModel> partsToReturn = [];
    json["parts"].forEach((part) {
      partsToReturn.add(NamedCollectionModel.fromJson(part));
    });
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

  @override
  NamedMultiCollectionModel copy() {
    return NamedMultiCollectionModel(
      name: name,
      path: path,
      parts: parts,
    );
  }
}
