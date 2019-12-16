import 'dart:convert';
import 'dart:io';

import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_model.dart';
import 'package:d20_dice_roller/core/streams/pipes.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class ViewNamedCollectionsBloc extends ChangeNotifier {
  Directory multiCollectionsDirectory;
  Directory namedCollectionsDirectory;
  List<NamedMultiCollectionModel> namedMultiCollections = [];
  List<NamedCollectionModel> namedCollections = [];
  List<ChangeNotifier> collections;

  bool requested = false;
  BroadcastPipe<List<ChangeNotifier>> collectionsPipe =
      BroadcastPipe();
  EventPipe requestCollectionsPipe = EventPipe();

  ViewNamedCollectionsBloc() {
    requestCollectionsPipe.listen(() => getSavedFiles().then((result) {
          if (result) {
            collectionsPipe.send(collections);
          }
        }));
  }

  Future<bool> deleteFile(NamedMultiCollectionModel model) async {
    bool fileDeleted;
    bool hasDirectory = multiCollectionsDirectory != null;
    if (!hasDirectory) {
      hasDirectory = await getCollectionsDirectory();
    }
    if (!hasDirectory) {
      return false;
    }
    File fileToDelete = File("${multiCollectionsDirectory.path}/${model.name}.txt");
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
    multiCollectionsDirectory = Directory("$path/MultiCollections");
    namedCollectionsDirectory = Directory("$path/NamedCollections");
    return multiCollectionsDirectory != null || namedCollectionsDirectory != null;
  }

  Future<bool> getSavedFiles() async {
    namedMultiCollections = [];
    namedCollections = [];
    if (!await getCollectionsDirectory()) return false;
    List<FileSystemEntity> multiEntitites = multiCollectionsDirectory.listSync();
    List<FileSystemEntity> namedEntitites = namedCollectionsDirectory.listSync();
    await decodeMultiFiles(multiEntitites);
    await decodeNamedFiles(namedEntitites);
    return namedMultiCollections.isNotEmpty || namedCollections.isNotEmpty;
  }

  Future<void> decodeMultiFiles(List<FileSystemEntity> entities) async {
    for(FileSystemEntity entity in entities){
      await decodeMultiFile(entity);
    }
  }

  Future<void> decodeNamedFiles(List<FileSystemEntity> entities) async {
    for(FileSystemEntity entity in entities){
      await decodeNamedFile(entity);
    }
  }

  Future<bool> decodeMultiFile(FileSystemEntity entity) async {
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

  Future<bool> decodeNamedFile(FileSystemEntity entity) async {
    if (await File(entity.path).exists()) {
      String jsonString = await File(entity.path).readAsString();
      try {
        namedCollections.add(NamedCollectionModel.fromJson(
            json.decode(jsonString), path: entity.path));
        return true;
      } catch (error) {
        return false;
      }
    }
    return false;
  }
}
