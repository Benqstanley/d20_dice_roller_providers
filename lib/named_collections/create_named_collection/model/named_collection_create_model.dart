import 'dart:io';

import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/single_type_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_rows/single_type_collection_row.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/model/create_model.dart';
import 'package:flutter/cupertino.dart';

class NamedCollectionCreateModel extends CreateModel {
  TextEditingController nameController = TextEditingController();
  List<SingleTypeCollectionRow> singleTypeRows = [];

  NamedCollectionCreateModel() {
    addSingleTypeCollectionRow();
  }

  void dismissRow(SingleTypeCollectionRow toDismiss) {
    singleTypeRows.remove(toDismiss);
    if (singleTypeRows.isEmpty) {
      addSingleTypeCollectionRow();
    }
    notifyListeners();
  }

  void resetList() {
    singleTypeRows = [];
    addSingleTypeCollectionRow();
  }

  void addSingleTypeCollectionRow() {
    singleTypeRows.add(
      SingleTypeCollectionRow(
        SingleTypeCollectionModel(),
        dismissRow,
      ),
    );
    notifyListeners();
  }

  @override
  String toString() {
    return nameController.text;
  }

  NamedCollectionModel returnModel() {
    var collectionModel = NamedCollectionModel(
        name: nameController.text,
        singleTypeCollections:
            singleTypeRows.map((row) => row.collectionModel).toList());
    return collectionModel;
  }

  @override
  Future<bool> saveCollection() async {
    String jsonString = returnModel().toJsonString();
    String path = await localPath();
    Directory directory = Directory("$path/NamedCollections");
    if (!await directory.exists()) {
      directory.create();
    }
    File file = File("$path/NamedCollections/${nameController.text}.txt");
    if (!(await file.exists())) {
      file = await file.create();
      await file.writeAsString(jsonString);
      return true;
    }
    return false;
  }
}
