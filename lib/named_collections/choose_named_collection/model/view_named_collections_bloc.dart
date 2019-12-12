import 'dart:convert';
import 'dart:io';

import 'package:d20_dice_roller/core/named_multi_collection_model.dart';
import 'package:d20_dice_roller/named_collections/choose_named_collection/model/view_named_collections_row_cn.dart';
import 'package:d20_dice_roller/roller/ui/named_multi_collection_roller_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class ViewNamedCollectionsBloc extends ChangeNotifier {
  Directory collectionsDirectory;
  List<NamedMultiCollectionModel> namedMultiCollections = [];

  ViewNamedCollectionsBloc(){
    getSavedFiles();
  }

  Future<bool> deleteFile(ViewNamedCollectionsRowCN row) async {
    NamedMultiCollectionModel model = row.model;
    bool fileDeleted = false;
    bool hasDirectory = collectionsDirectory != null;
    if(!hasDirectory){
      hasDirectory = await getCollectionsDirectory();
    }
    if(!hasDirectory){
      return false;
    }
    File fileToDelete = File("${collectionsDirectory.path}/${model.name}.txt");
    if(await fileToDelete.exists()){
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
    if (namedMultiCollections.isEmpty) {
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
    return false;
  }
}
