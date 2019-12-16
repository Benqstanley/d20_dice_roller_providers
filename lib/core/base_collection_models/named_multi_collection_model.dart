import 'dart:convert';

import 'package:d20_dice_roller/core/base_collection_models/named_collection_base.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:flutter/material.dart';

class NamedMultiCollectionModel extends NamedCollectionBaseModel {
  final List<NamedCollectionModel> parts;

  NamedMultiCollectionModel({
    String path,
    @required String name,
    @required this.parts,
  }) : super(name, path: path);

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
}
