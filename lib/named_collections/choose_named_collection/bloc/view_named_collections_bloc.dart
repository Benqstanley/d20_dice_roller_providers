import 'dart:convert';
import 'dart:io';
import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_model.dart';
import 'package:d20_dice_roller/named_collections/choose_named_collection/collection_management/collection_models/named_multi_collection_choose_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class ViewNamedCollectionsBloc extends ChangeNotifier {
  Directory collectionsDirectory;
  List<NamedMultiCollectionChooseModel> namedMultiCollections = [];
  bool requested = false;

  ViewNamedCollectionsBloc() {
    getSavedFiles();
  }

  Future<bool> deleteFile(NamedMultiCollectionChooseModel row) async {
    NamedMultiCollectionModel model = row;
    bool fileDeleted = false;
    bool hasDirectory = collectionsDirectory != null;
    if (!hasDirectory) {
      hasDirectory = await getCollectionsDirectory();
    }
    if (!hasDirectory) {
      return false;
    }
    File fileToDelete = File("${collectionsDirectory.path}/${model.name}.txt");
    if (await fileToDelete.exists()) {
      fileToDelete.delete().then((file) async {
        fileDeleted = !await file.exists();
        print(fileDeleted);
      });
    }
    namedMultiCollections.remove(model);
    notifyListeners();
    return fileDeleted;
  }

  Future<bool> getCollectionsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    collectionsDirectory = Directory("$path/MultiCollections");
    return collectionsDirectory != null;
  }

  Future<bool> getSavedFiles() async {
    namedMultiCollections = [];
    if (!await getCollectionsDirectory()) return false;
    Stream<FileSystemEntity> entityStream = collectionsDirectory.list();
    entityStream.listen((entity) async {
      if (await File(entity.path).exists()) {
        String jsonString = await File(entity.path).readAsString();
        try {
          namedMultiCollections.add(NamedMultiCollectionModel.fromJson(
              json.decode(jsonString), entity.path));
        } catch (error, stackTrace) {
          print('saved files: ' + error.toString());
          print('saved files stackTrace: $stackTrace');
        }
      }
    });
    notifyListeners();
    return namedMultiCollections?.isNotEmpty ?? false;
  }
}
