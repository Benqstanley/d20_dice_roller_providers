import 'dart:convert';
import 'dart:io';

import 'package:d20_dice_roller/core/named_collection_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class ViewNamedCollectionsModel extends ChangeNotifier {
  List<NamedMultiCollectionModel> namedMultiCollections = [];
  void printNamedMultis() async {
    if(await getSavedFiles()){
      print(namedMultiCollections);
    }}
  Future<bool> getSavedFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final collectionsDirectory = Directory("$path/MultiCollections");
    if(!await collectionsDirectory.exists()){
      return false;
    }
    Stream<FileSystemEntity> entityStream = collectionsDirectory.list();
    entityStream.listen((entity) async {
      print('we have $entity');
      if (await File(entity.path).exists()) {
        String jsonString = await File(entity.path).readAsString();
        try {
          namedMultiCollections.add(NamedMultiCollectionModel.fromJson(
              json.decode(jsonString), entity.path));
        }catch (error, stackTrace){
          print('saved files: ' + error.toString());
          print('saved files stackTrace: $stackTrace');
        }
      }
    });

    return namedMultiCollections?.isNotEmpty ?? false;
  }
}