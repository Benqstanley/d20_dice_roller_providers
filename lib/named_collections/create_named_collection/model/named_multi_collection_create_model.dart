import 'dart:io';

import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_model.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/model/create_model.dart';
import 'package:flutter/material.dart';

class NamedMultiCollectionCreateModel extends CreateModel {
  bool isMultiPart = false;
  final TextEditingController nameController = TextEditingController();
  List<NamedCollectionModel> namedModels = [];

  NamedMultiCollectionCreateModel({NamedMultiCollectionModel model}){
    if(model != null){
      namedModels = model.parts;
      nameController.text = model.name;
    }
  }

  void dismissMultiPartRow(NamedCollectionModel modelToRemove) {
    namedModels.remove(modelToRemove);
    notifyListeners();
  }

  void absorbNamedCollection(NamedCollectionModel currentPart) {
    namedModels.add(currentPart);
    notifyListeners();
  }

  void changeMultiStatus(bool newValue) {
    isMultiPart = newValue;
    notifyListeners();
  }

  void resetRowsList() {
    namedModels.clear();
    notifyListeners();
  }

  void updateScreen() {
    notifyListeners();
  }

  NamedMultiCollectionModel returnModel() {
    return NamedMultiCollectionModel(
      name: nameController.text,
      parts: namedModels);
  }

  @override
  Future<bool> saveCollection({bool forEditing = false}) async {
    String jsonString = returnModel().toJsonString();
    String path = await localPath();
    Directory directory = Directory("$path/MultiCollections");
    if (!await directory.exists()) {
      directory.create();
    }
    File file = File("$path/MultiCollections/${nameController.text}.txt");
    if (!(await file.exists())) {
      await file.writeAsString(jsonString);
      return true;
    }else if(forEditing){
      await file.writeAsString(jsonString);
      return true;
    }
    return false;
  }
}
