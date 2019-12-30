import 'dart:convert';
import 'dart:io';

import 'package:d20_dice_roller/core/base_collection_models/collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_model.dart';
import 'package:d20_dice_roller/core/streams/pipes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ViewNamedCollectionsBloc extends ChangeNotifier {
  Directory multiCollectionsDirectory;
  Directory namedCollectionsDirectory;
  List<NamedMultiCollectionModel> namedMultiCollections = [];
  List<NamedCollectionModel> namedCollections = [];
  List<CollectionModel> collections = [];
  bool filesLoaded = false;
  BuildContext context;

  bool requested = false;
  BroadcastPipe<List<ChangeNotifier>> collectionsPipe = BroadcastPipe();
  EventPipe requestCollectionsPipe = EventPipe();

  ViewNamedCollectionsBloc() {
    requestCollectionsPipe.listen(() => getSavedFiles().then((result) {
      print('getSavedFiles + $result');
          if (result) {
            filesLoaded = true;
            collectionsPipe.send(collections);
          } else{
            collectionsPipe.send(null);
          }
        }));
  }

  void setContext(BuildContext context) {
    this.context = context;
  }

  Future<bool> pendingDelete(CollectionModel model) async {
    bool fileDeleted;
    bool hasDirectory = multiCollectionsDirectory != null;
    int indexOfModel = collections.indexOf(model);
    collections.remove(model);
    notifyListeners();
    Scaffold.of(context)
        .showSnackBar(
          SnackBar(
            content: Text("File Deleted"),
            action: SnackBarAction(
              label: "Undo",
              onPressed: () {
                collections.insert(indexOfModel, model);
                collectionsPipe.send(collections);
              },
            ),
          ),
        )
        .closed
        .then((reason) async {
      if (reason != SnackBarClosedReason.action) {
        if (!hasDirectory) {
          hasDirectory = await getCollectionsDirectory();
        }
        if (!hasDirectory) {
          return false;
        }
        Directory directory;
        if(model is NamedCollectionModel){
          directory = namedCollectionsDirectory;
        }else if(model is NamedMultiCollectionModel){
          directory = multiCollectionsDirectory;
        }
        File fileToDelete =
            File("${directory.path}/${model.name}.txt");
        if (await fileToDelete.exists()) {
          fileToDelete.delete().then((file) async {
            fileDeleted = !await file.exists();
          });
        }
      }
      return fileDeleted;
    });
    return fileDeleted;
  }

  Future<bool> getCollectionsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    try {
      multiCollectionsDirectory = Directory("$path/MultiCollections");
      namedCollectionsDirectory = Directory("$path/NamedCollections");
    } catch (error) {}
    return multiCollectionsDirectory != null ||
        namedCollectionsDirectory != null;
  }

  Future<bool> getSavedFiles() async {
    if(filesLoaded) return true;
    namedMultiCollections = [];
    namedCollections = [];
    if (!await getCollectionsDirectory()) return false;
    if (await multiCollectionsDirectory.exists()) {
      List<FileSystemEntity> multiEntitites =
          multiCollectionsDirectory?.listSync();
      if (multiEntitites.isNotEmpty) await decodeMultiFiles(multiEntitites);
    }
    if (await namedCollectionsDirectory.exists()) {
      List<FileSystemEntity> namedEntitites =
          namedCollectionsDirectory?.listSync();
      if (namedEntitites.isNotEmpty) await decodeNamedFiles(namedEntitites);
    }
    collections.addAll(namedCollections);
    collections.addAll(namedMultiCollections);
    return namedMultiCollections.isNotEmpty || namedCollections.isNotEmpty;
  }

  Future<void> decodeMultiFiles(List<FileSystemEntity> entities) async {
    for (FileSystemEntity entity in entities) {
      await decodeMultiFile(entity);
    }
  }

  Future<void> decodeNamedFiles(List<FileSystemEntity> entities) async {
    for (FileSystemEntity entity in entities) {
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
            json.decode(jsonString),
            path: entity.path));
        return true;
      } catch (error) {
        return false;
      }
    }
    return false;
  }
}
