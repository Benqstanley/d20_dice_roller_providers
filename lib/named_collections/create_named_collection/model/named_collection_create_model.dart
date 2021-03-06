import 'dart:io';

import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/single_type_collection_model.dart';
import 'package:d20_dice_roller/named_collections/create_named_collection/model/create_model.dart';

class NamedCollectionCreateModel extends CreateModel {
  List<SingleTypeCollectionModel> singleTypeCollections = [];

  NamedCollectionCreateModel({NamedCollectionModel model}) {
    List<SingleTypeCollectionModel> models = model?.singleTypeCollections;
    if (model?.name != null) {
      nameController.text = model.name;
      this.multiplier = model.multiplier;
    }
    if (models == null) {
      addSingleTypeCollectionModel();
    } else {
      models.forEach((model) {
        addSingleTypeCollectionModel(singleTypeCollectionModel: model);
      });
    }
  }

  void dismissRow(SingleTypeCollectionModel toDismiss) {
    singleTypeCollections.remove(toDismiss);
    if (singleTypeCollections.isEmpty) {
      addSingleTypeCollectionModel();
    }
    notifyListeners();
  }

  void resetList() {
    singleTypeCollections = [];
    addSingleTypeCollectionModel();
  }

  void addSingleTypeCollectionModel(
      {SingleTypeCollectionModel singleTypeCollectionModel}) {
    singleTypeCollections
        .add(singleTypeCollectionModel ?? SingleTypeCollectionModel());
    notifyListeners();
  }

  @override
  String toString() {
    return nameController.text;
  }

  factory NamedCollectionCreateModel.fromCollectionModel(
      NamedCollectionModel model) {
    var namedCollectionCreateModel = NamedCollectionCreateModel(model: model);
    namedCollectionCreateModel.nameController.text = model.name;
    return namedCollectionCreateModel;
  }

  NamedCollectionModel returnModel() {
    var collectionModel = NamedCollectionModel(
      name: nameController.text,
      singleTypeCollections: singleTypeCollections,
      multiplier: multiplier,
    );
    return collectionModel;
  }

  @override
  Future<bool> saveCollection({bool forEditing = false}) async {
    String jsonString = returnModel().toJsonString();
    print(jsonString);
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
    } else if (forEditing) {
      await file.writeAsString(jsonString);
      return true;
    }
    return false;
  }
}
