import 'dart:io';

import 'package:d20_dice_roller/core/single_type_collection_row.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/model/create_named_multi_type_collection_model.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/ui/multi_type_row.dart';
import 'package:d20_dice_roller/core/named_collection_model.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CreateNamedCollectionModel extends ChangeNotifier {
  bool isMultiPart = false;
  final TextEditingController nameEditingController = TextEditingController();
  TextEditingController partEditingController;
  List<MultiTypeRowForCreateScreen> parts = [];
  CreateNamedMultiTypeCollectionModel currentPart;

  TextEditingController nameController(bool isPartOfBigger) {
    if (isPartOfBigger) {
      return partEditingController;
    } else {
      return nameEditingController;
    }
  }

  CreateNamedCollectionModel() {
    currentPart =
        CreateNamedMultiTypeCollectionModel(dismissSingleTypeCollectionRow);
  }

  void dismissMultiPartRow(MultiTypeRowForCreateScreen row){
    parts.remove(row);
    notifyListeners();
  }

  void moveCurrentToList() {
    parts.add(MultiTypeRowForCreateScreen(currentPart, dismissMultiPartRow));
    currentPart =
        CreateNamedMultiTypeCollectionModel(dismissSingleTypeCollectionRow);
    notifyListeners();
  }

  void changeMultiPartStatus(bool newValue) {
    isMultiPart = newValue;
    notifyListeners();
  }

  void resetCurrentList() {
    currentPart.resetList();
    notifyListeners();
  }

  void resetPartsList() {
    parts.clear();
    notifyListeners();
  }

  void addSingleTypeCollectionRowForCurrentPart() {
    currentPart.addSingleTypeCollectionRow();
    notifyListeners();
  }

  void dismissSingleTypeCollectionRow(SingleTypeCollectionRow toBeDismissed,
      {CreateNamedMultiTypeCollectionModel model}) {
    model = model ?? currentPart;
    model.singleTypeCollections.remove(toBeDismissed);
    if (model.singleTypeCollections.isEmpty) {
      model.addSingleTypeCollectionRow();
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  void updateScreen() {
    notifyListeners();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }


  void saveNamedCollection() async {
    String jsonString = NamedMultiCollectionModel.fromCreate(this).toJsonString();
    String path = await _localPath;
    Directory directory = Directory("$path/MultiCollections");
    if(!await directory.exists()){
      directory.create();
    }
    File file = File("$path/MultiCollections/${nameEditingController.text}.txt");
    if(!(await file.exists())){
      file = await file.create();
      file.writeAsString(jsonString).then((file) async {
        bool fileSaved = await file.exists();
      });
    }
  }

}