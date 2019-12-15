import 'dart:convert';
import 'dart:io';

import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_model.dart';
import 'package:d20_dice_roller/core/streams/pipes.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class ViewNamedCollectionsBloc extends ChangeNotifier {
  Directory collectionsDirectory;
  List<NamedMultiCollectionModel> namedMultiCollections = [];
  bool requested = false;
  BroadcastPipe<List<NamedMultiCollectionModel>> collectionsPipe =
      BroadcastPipe();
  EventPipe requestCollectionsPipe = EventPipe();

  ViewNamedCollectionsBloc() {
    requestCollectionsPipe.listen(() => getSavedFiles().then((result) {
          if (result) {
            collectionsPipe.send(namedMultiCollections);
          }
        }));
  }

  Future<bool> deleteFile(NamedMultiCollectionModel model) async {
    bool fileDeleted;
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
    List<FileSystemEntity> entities = collectionsDirectory.listSync();
    await decodeFiles(entities);
    return namedMultiCollections?.isNotEmpty ?? false;
  }

  Future<void> decodeFiles(List<FileSystemEntity> entities) async {
    for(FileSystemEntity entity in entities){
      await decodeFile(entity);
    }
  }

  Future<bool> decodeFile(FileSystemEntity entity) async {
    if (await File(entity.path).exists()) {
      String jsonString = await File(entity.path).readAsString();
      try {
        namedMultiCollections.add(NamedMultiCollectionModel.fromJson(
            json.decode(jsonString), entity.path));
        return true;
      } catch (error) {
        return false;
      }
    }
    return false;
  }
}
