import 'dart:convert';

import 'package:d20_dice_roller/core/base_collection_models/named_collection_base_model.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/model/create_named_collection_model.dart';
import 'package:flutter/material.dart';

class NamedMultiCollectionBaseModel extends ChangeNotifier{
  final String path;
  final String name;
  final List<NamedCollectionBaseModel> parts;

  NamedMultiCollectionBaseModel({
    this.path,
    @required this.name,
    @required this.parts,
  });

  factory NamedMultiCollectionBaseModel.fromCreate(
      CreateNamedCollectionModel model) {
    return NamedMultiCollectionBaseModel(
      name: model.nameEditingController.text,
      parts: model.rows.map((multiTypeRow) {
        return NamedCollectionBaseModel(
          name: multiTypeRow.model.name,
          singleTypeCollections: multiTypeRow.model.singleTypeCollections
              .map((item) => item.collectionModel)
              .toList(),
        );
      }).toList(),
    );
  }

  factory NamedMultiCollectionBaseModel.fromJson(
      Map<String, dynamic> json, String path) {
    List<NamedCollectionBaseModel> partsToReturn = [];
    json["parts"].forEach((part){
      partsToReturn.add(NamedCollectionBaseModel.fromJson(part));

    });
    print("partsToReturn");
    NamedMultiCollectionBaseModel model = NamedMultiCollectionBaseModel(
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

