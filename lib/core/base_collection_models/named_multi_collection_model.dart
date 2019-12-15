import 'dart:convert';

import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:flutter/material.dart';

class NamedMultiCollectionModel extends ChangeNotifier {
  final String path;
  final String name;
  final List<NamedCollectionModel> parts;
  bool checkBox;
  int counterState = 1;

  void changeCheckbox(bool newValue) {
    checkBox = newValue;
    notifyListeners();
  }

  void increment() {
    counterState++;
    notifyListeners();
  }

  void decrement() {
    if (counterState > 1) {
      counterState--;
    } else {
      counterState = 1;
      checkBox = false;
    }
    notifyListeners();
  }

  NamedMultiCollectionModel({
    this.path,
    @required this.name,
    @required this.parts,
  });

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
