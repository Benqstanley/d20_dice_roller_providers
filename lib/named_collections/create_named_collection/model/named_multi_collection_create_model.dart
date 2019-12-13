import 'dart:io';

import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_rows/named_collection_row.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class NamedMultiCollectionCreateModel extends ChangeNotifier {
  bool isMultiPart = false;
  final TextEditingController nameController = TextEditingController();
  List<NamedCollectionRow> rows = [];

  NamedMultiCollectionCreateModel();

  void dismissMultiPartRow(NamedCollectionRow row) {
    rows.remove(row);
    notifyListeners();
  }

  void absorbNamedCollection(NamedCollectionModel currentPart) {
    rows.add(
        NamedCollectionRow(currentPart, dismissMultiPartRow));
    notifyListeners();
  }

  void changeMultiStatus(bool newValue) {
    isMultiPart = newValue;
    notifyListeners();
  }

  void resetRowsList() {
    rows.clear();
    notifyListeners();
  }

  void updateScreen() {
    notifyListeners();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  NamedMultiCollectionModel returnModel(){
    return NamedMultiCollectionModel(
      name: nameController.text,
      parts: rows.map((multiTypeRow) {
        return NamedCollectionModel(
          name: multiTypeRow.collectionModel.name,
          singleTypeCollections:
          multiTypeRow.collectionModel.singleTypeCollections,
        );
      }).toList(),
    );
  }

  Future<bool> saveNamedCollection() async {
    String jsonString =
        returnModel().toJsonString();
    String path = await _localPath;
    Directory directory = Directory("$path/MultiCollections");
    if (!await directory.exists()) {
      directory.create();
    }
    File file =
        File("$path/MultiCollections/${nameController.text}.txt");
    if (!(await file.exists())) {
      file = await file.create();
      await file.writeAsString(jsonString);
      return true;
    }
    return false;
  }
}
